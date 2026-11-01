#!/usr/bin/env python3
"""Checks the search and sharing metadata of every page in the built site.

Part of `make check` and CI. It reads public/sitemap.xml and, for each page
listed there, checks the tags that layouts/_partials/head_meta.html writes:

- exactly one non-empty meta description, canonical link, og:title,
  og:description, og:url, and og:image;
- the canonical link and og:url are the page's own sitemap URL;
- the og:image URL is under the site's base URL, and the file is in public/;
- the robots noindex tag is there if, and only if, the sitemap's host is not
  `productionHost` from hugo.toml. This keeps the staging copy out of search
  engines, and makes sure the live site never ships with noindex. A host
  that is a subdomain of productionHost (www) fails, because it means the
  two disagree.

robots.txt must name the sitemap. Uses only the Python standard library.
Exits 1 with one line per problem.
"""

import re
import sys
import tomllib
import xml.etree.ElementTree as ET
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlsplit

PUBLIC = Path("public")
SITEMAP_NS = {"s": "http://www.sitemaps.org/schemas/sitemap/0.9"}
REQUIRED_ONCE = [
    ("meta", "name", "description"),
    ("link", "rel", "canonical"),
    ("meta", "property", "og:title"),
    ("meta", "property", "og:description"),
    ("meta", "property", "og:url"),
    ("meta", "property", "og:image"),
]


class HeadTags(HTMLParser):
    """Collects the <meta> and <link> tags as (tag, attributes) pairs."""

    def __init__(self):
        super().__init__()
        self.tags = []

    def handle_starttag(self, tag, attrs):
        if tag in ("meta", "link"):
            self.tags.append((tag, {k: v or "" for k, v in attrs}))


def find(tags, tag, key, value):
    """Returns the matching tags' content (or href) attributes."""
    out = []
    for t, attrs in tags:
        if t == tag and value in attrs.get(key, "").split():
            out.append(attrs.get("href" if tag == "link" else "content", ""))
    return out


def main():
    problems = []
    production_host = tomllib.loads(Path("hugo.toml").read_text())["params"][
        "productionHost"
    ]

    sitemap = PUBLIC / "sitemap.xml"
    if not sitemap.is_file():
        print("check-meta: public/sitemap.xml not found; run make build first")
        return 1
    urls = [
        loc.text.strip() for loc in ET.parse(sitemap).findall(".//s:loc", SITEMAP_NS)
    ]
    if not urls:
        print("check-meta: the sitemap lists no pages")
        return 1

    # The base URL is the homepage's URL, the shortest in the sitemap.
    base = min(urls, key=len)
    host = urlsplit(base).hostname
    staging = host != production_host
    # A subdomain of the live domain (www) is not staging: it means the Pages
    # custom domain and productionHost disagree, and the live site would
    # ship with noindex.
    if host.endswith("." + production_host):
        problems.append(
            f"the site's host is {host}, but productionHost in hugo.toml is "
            f"{production_host}; make them match"
        )

    def local_path(url):
        """Maps a URL under the base URL to its file in public/."""
        if not url.startswith(base):
            return None
        path = PUBLIC / url[len(base) :]
        return path / "index.html" if url.endswith("/") else path

    for url in urls:
        page = local_path(url)
        if page is None or not page.is_file():
            problems.append(f"{url}: no file in public/ for this sitemap URL")
            continue
        parser = HeadTags()
        parser.feed(page.read_text(encoding="utf-8"))
        tags = parser.tags
        where = page.relative_to(PUBLIC)

        for tag, key, value in REQUIRED_ONCE:
            found = find(tags, tag, key, value)
            if len(found) != 1:
                problems.append(f"{where}: {len(found)} {value} tags, expected 1")
            elif not found[0].strip():
                problems.append(f"{where}: empty {value}")

        for value, found in (
            ("canonical", find(tags, "link", "rel", "canonical")),
            ("og:url", find(tags, "meta", "property", "og:url")),
        ):
            if found and found[0] != url:
                problems.append(f"{where}: {value} is {found[0]}, expected {url}")

        for image in find(tags, "meta", "property", "og:image"):
            file = local_path(image)
            if file is None or not file.is_file():
                problems.append(f"{where}: og:image {image} is not in public/")

        noindex = any(
            "noindex" in re.split(r"[\s,]+", c)
            for c in find(tags, "meta", "name", "robots")
        )
        if staging and not noindex:
            problems.append(f"{where}: no noindex tag on a non-production build")
        if not staging and noindex:
            problems.append(f"{where}: noindex tag on a production build")

    robots = PUBLIC / "robots.txt"
    if not robots.is_file():
        problems.append("robots.txt: missing")
    elif f"Sitemap: {base}sitemap.xml" not in robots.read_text():
        problems.append(f"robots.txt: does not name {base}sitemap.xml")

    for p in problems:
        print(f"check-meta: {p}")
    kind = "staging (noindex)" if staging else "production"
    if problems:
        print(f"check-meta: {len(problems)} problem(s) in a {kind} build")
        return 1
    print(f"check-meta: {len(urls)} pages passed, {kind} build")
    return 0


if __name__ == "__main__":
    sys.exit(main())
