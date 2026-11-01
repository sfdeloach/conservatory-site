#!/usr/bin/env bash
# Checks the old WordPress URLs and the 404 page on a deployed copy of the
# site. Run it with `make check-redirects BASE=<url>` after `make build`;
# it is not part of `make check` or CI, because it needs the deployed site.
#
#   make check-redirects BASE=https://sfdeloach.github.io/conservatory-site/
#   make check-redirects BASE=https://saintandrewsconservatory.org/
#
# The old URLs are the redirect pages in the local public/ (one per entry
# in a page's front matter `aliases`). For each, at BASE, it fails (exit 1)
# when:
#   - the old URL, with its trailing slash, doesn't return 200 with a
#     refresh to a page under BASE;
#   - the old URL without the trailing slash doesn't end, after any
#     redirects, at that same redirect page (GitHub Pages adds the slash);
#   - the page it refreshes to doesn't return 200.
# Then it requests a path that doesn't exist, and fails unless the answer
# is a 404 with the site's "Page not found" page.
#
# The local build's base URL doesn't matter: only paths are compared.

set -u

base="${1:-}"
if [ -z "$base" ]; then
  echo "usage: $0 BASE_URL (for example https://saintandrewsconservatory.org/)" >&2
  exit 2
fi
base="${base%/}/"

if [ ! -d public ]; then
  echo "check-redirects: public/ not found; run make build first" >&2
  exit 2
fi

status=0
count=0
fail() {
  echo "  FAIL: $1"
  status=1
}

# The refresh target in a page's HTML (minified or not).
refresh_target() {
  grep -io 'http-equiv="\{0,1\}refresh"\{0,1\} content="0; url=[^"]*"' |
    head -n 1 | sed 's/.*url=//; s/"$//'
}

aliases=$(grep -rlis --include=index.html 'http-equiv="\{0,1\}refresh' public |
  sed 's|^public/||; s|index\.html$||' | sort)

for path in $aliases; do
  count=$((count + 1))
  url="$base$path"
  echo "$url"

  body=$(curl -sS --max-time 20 -w '\n%{http_code}' "$url") || {
    fail "can't be reached"
    continue
  }
  code=$(printf '%s' "$body" | tail -n 1)
  target=$(printf '%s' "$body" | sed '$d' | refresh_target)
  if [ "$code" != "200" ]; then
    fail "returned $code, expected 200"
    continue
  fi
  if [ -z "$target" ]; then
    fail "is not a redirect page"
    continue
  fi
  echo "  -> $target"
  case "$target" in
    "$base"*) ;;
    *) fail "redirects outside $base" ;;
  esac

  # Without the trailing slash: follow redirects, and expect the same page.
  final=$(curl -sSL --max-time 20 -w '\n%{http_code}' "${url%/}") || final=""
  if [ "$(printf '%s' "$final" | tail -n 1)" != "200" ] ||
    [ "$(printf '%s' "$final" | sed '$d' | refresh_target)" != "$target" ]; then
    fail "${url%/} (no trailing slash) doesn't reach the redirect page"
  fi

  target_code=$(curl -sS --max-time 20 -o /dev/null -w '%{http_code}' "$target") ||
    target_code="unreachable"
  [ "$target_code" = "200" ] || fail "its new page returned $target_code"
done

missing="${base}check-redirects-no-such-page-$$/"
echo "$missing"
body=$(curl -sS --max-time 20 -w '\n%{http_code}' "$missing") || body=$'\nunreachable'
code=$(printf '%s' "$body" | tail -n 1)
[ "$code" = "404" ] || fail "returned $code, expected 404"
printf '%s' "$body" | grep -q '<h1>Page not found' ||
  fail "is not the site's \"Page not found\" page"

if [ "$count" -eq 0 ]; then
  echo "check-redirects: no redirect pages in public/" >&2
  status=1
fi
if [ "$status" -eq 0 ]; then
  echo "check-redirects: $count old URLs and the 404 page passed at $base"
else
  echo "check-redirects: problems found at $base"
fi
exit "$status"
