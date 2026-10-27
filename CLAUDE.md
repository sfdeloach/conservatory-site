# CLAUDE.md

Static website for Saint Andrew's Conservatory of Music, built with Hugo. It will replace the current WordPress site at `saintandrewsconservatory.org`.

Read [docs/ROADMAP.md](docs/ROADMAP.md) before starting work. It defines the phases, the working principles, and the execution protocol to follow for every task.

## Toolchain

- **Hugo extended** 0.168.0. The extended edition is required for image processing to WebP. `hugo.toml` (`[module.hugoVersion]`) refuses to build on an older or non-extended Hugo.
- **Dart Sass**, which must be on `PATH` as `sass`. `layouts/baseof.html` compiles `assets/sass/main.scss` using `"transpiler" "dartsass"`, and the build fails without it. Version 1.106.1.
- **lychee**, for the internal link check in `make check`. Version 0.24.2.
- **Node and npm**, for formatting only: Prettier 3 with `prettier-plugin-go-template`. Verified with Node 20.

The Hugo, Dart Sass, and lychee versions are pinned in the `env` block of `.github/workflows/deploy.yml`. That is the source of truth, and CI uses exactly those versions.

## Commands

| Command                  | Purpose                                                                 |
| ------------------------ | ----------------------------------------------------------------------- |
| `hugo server`            | Local development server with live reload, at `http://localhost:1313/`. |
| `make build`             | Strict production build into `public/`. Any Hugo warning fails it.      |
| `make check`             | `make build`, then lychee offline check of internal links and anchors.  |
| `make clean`             | Delete `public/` and `resources/`.                                      |
| `npm install`            | Install Prettier and its plugin.                                        |
| `npx prettier --check .` | Check formatting. Use `--write` to fix it.                              |

Run `make check` before every commit. CI runs the same command on every push and pull request. See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md#build-and-validation) for what it covers.

## Architecture

- `hugo.toml` holds the site config: `baseURL`, the title, contact details under `params.contact`, the `studios` taxonomy (`studio = "studios"`), and Markdown settings: Goldmark block attributes are on (for `{.full-bleed}`), a standalone image is not wrapped in a paragraph (`wrapStandAloneImageWithinParagraph = false`, so the image hook can render a figure), and code-fence highlighting is off.
- **Content** uses page bundles with YAML front matter. Images sit in the same folder as the page that uses them.
  - `content/_index.md` drives the homepage. Every homepage section is defined in front matter `params` (hero, story, studyAreas, welcome, faculty, summerAcademy, ready). `faculty.featured` lists the faculty page paths shown as homepage cards, in order; a path with no page fails the build. The Markdown body is the Dean's letter.
  - `content/faculty/<last>_<first>/index.md` holds one faculty bio. It uses `layout: page_faculty_bio`, a `headshot.*` image, a `studios:` list of taxonomy terms, and an optional `params.postNominal`. Faculty lists sort by folder name (last name) through `_partials/faculty_sort.html`, not by `weight`.
  - `content/studios/<term>/_index.md` holds the content for each `studios` taxonomy term page, with an `instrument.jpg` image. Faculty pages are tagged with these terms.
  - Top-level pages (`registration`, `payment`, `schedule`, `contact`, `summer-academy`) get into the main navigation through `menus.main.weight` and use `params.image`.
  - Draft pages, shown only by `hugo server -D` and never published: `content/style-test/` has every Markdown element the site styles, for checking typography; `content/handbook/` is the student handbook in progress (roadmap Phase 3).
- **Layouts** (`layouts/`):
  - `baseof.html` is the shell: Sass pipeline, fingerprinted CSS and JS, font preload.
  - `home.html` is the homepage. The Summer Academy and "Ready" sections are full-width `.band`s; the Summer Academy band's photo is the `/summer-academy` page's `params.image`.
  - `page.html` and `section.html` are generic. `section.html` renders a card list of child pages.
  - `page_faculty_bio.html` is the faculty bio layout.
  - `studios/taxonomy.html` and `studios/term.html` render the studio pages. `term.html` fails the build when a studio in a faculty page's `studios:` list has no `content/studios/<term>/_index.md`, which catches a misspelling.
- **Partials** (`layouts/_partials/`):
  - `responsive_image.html` builds a WebP `srcset` from a page-bundle image. Its header comment documents the parameters it takes. Always use it rather than writing `<img>` tags by hand. It fails the build when no bundle image matches, and uses one WebP at the image's own size when the image is smaller than every requested width.
  - `card.html` is the card in card lists. Its header comment documents its parameters, including the optional `sizes` and `headingLevel` (use `3` when cards sit under a section's `<h2>`, as on the homepage).
  - `prose.html` wraps a page's Markdown content in `.prose` (reading width and typography). Use it instead of a bare `.Content`. The homepage is the exception: its Dean's letter is styled by `_home.scss`.
  - `cta.html` and `cta_group.html` render buttons from `{label, page, style}` lists in front matter. A missing target page triggers a build warning.
  - `header.html`, `footer.html`, `site_nav_list.html`, `logo.html`, `page_header.html`, and `studios_text.html` cover the rest of the page chrome.
- **Render hooks** (`layouts/_markup/`), each with a header comment:
  - `render-link.html` outputs internal links as the target page's or bundle file's `RelPermalink` (subpath-safe), and fails the build with the source file and line if the target doesn't exist. External and `#fragment` links are output as written.
  - `render-image.html` renders bundle images through `responsive_image.html`. A standalone image becomes a `<figure>` with the Markdown title as its caption. The build fails on a missing file or missing alt text.
  - `render-table.html` wraps tables in a focusable `.table-scroll` region that scrolls sideways on narrow screens.
  - There is no heading hook: Goldmark's automatic heading ids are enough.
- **Shortcodes** (`layouts/_shortcodes/`): `registration_button.html` shows a registration button from `params.registration.<key>` (`open`, `label`, `url`) only while `open` is true. Used on the Summer Academy page.
- **Styles:** `assets/sass/main.scss` imports partials. Design tokens live in `_tokens.scss`, with one partial per area (`_home.scss`, `_cards.scss`, and so on). `_prose.scss` styles Markdown inside `.prose`: a 55ch column on the same named-line grid as `main`, which `.full-bleed` children escape.
- **Script:** `assets/js/script.js` toggles the mobile navigation menu.
- **Static files:** `static/` holds self-hosted fonts (EB Garamond, Nunito, Incognito Pro) and the favicon.

## Conventions

- Follow the existing patterns. Reuse the partials, put content in front matter `params`, and keep images in page bundles.
- Write YAML front matter in content files. Note that `archetypes/default.md` still produces TOML.
- Format with Prettier before committing. Templates use the go-template parser (see `.prettierrc`).
- Make small, focused changes. After each one, run `make check`.

## Deployment

Every push to `main` that passes `make check` is deployed to GitHub Pages by `.github/workflows/deploy.yml`. Pull requests are checked but never deployed. Templates must stay subpath-safe: use `RelPermalink` or `relURL` (without a leading slash) in templates, and relative `url()`s in Sass. Never hard-code root-absolute paths such as `/images/...`, because the site is served from `/conservatory-site/` until the Phase 6 cutover.

## Constraints

- Do not change DNS, hosting, payment configuration, or secrets without explicit human approval.
- Never commit credentials. Registration and payment are handled by external providers (Wufoo, Breeze ChMS). The site only links to them.
- Do not claim that a build, deployment, or integration works unless it was actually tested.

## Known limitations and technical debt

- External links are not checked automatically.
- `npx prettier --check .` fails on 7 files that were never formatted: `.prettierrc`, `layouts/baseof.html`, `layouts/_partials/logo.html`, and the four front-matter-only pages. Format them in a separate change.
- `content/registration/`, `content/payment/`, `content/schedule/`, and `content/contact/` have front matter only and no body. Their content is still on the old site (see [docs/SITE-INVENTORY.md](docs/SITE-INVENTORY.md)).
- The old site's contact form will not be replaced. Staff decided an email link and phone number are enough.
- The student handbook PDF is hosted only on the old WordPress site. Phase 3 replaces it with a web page at `/handbook/` (see the roadmap).
- Faculty and summer URLs differ from the old site's, so redirects are needed at cutover (roadmap Phase 6).

## Documentation

- [docs/ROADMAP.md](docs/ROADMAP.md): phases, status, open decisions, and the execution protocol.
- [docs/SITE-INVENTORY.md](docs/SITE-INVENTORY.md): the old site's pages, files, and external links, with migration status.
- [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md): hosting, CI/CD, DNS cutover, and rollback.
- [docs/CONTENT-GUIDE.md](docs/CONTENT-GUIDE.md): how to make routine content updates.
- [README.md](README.md): setup for developers and maintainers.
