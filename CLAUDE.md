# CLAUDE.md

Static website for Saint Andrew's Conservatory of Music, built with Hugo. It will replace the current WordPress site at `saintandrewsconservatory.org`.

Read [docs/ROADMAP.md](docs/ROADMAP.md) before starting work. It defines the phases, the working principles, and the execution protocol to follow for every task.

## Toolchain

- **Hugo extended**, v0.168.0 (the version verified locally). The extended edition is required for image processing to WebP.
- **Dart Sass**, which must be on `PATH` as `sass`. `layouts/baseof.html` compiles `assets/sass/main.scss` using `"transpiler" "dartsass"`, and the build fails without it. Verified with 1.106.1.
- **Node and npm**, for formatting only: Prettier 3 with `prettier-plugin-go-template`. Verified with Node 20.

Versions are not yet pinned anywhere in the repo. Pinning them is roadmap Phase 1.2.

## Commands

| Command                  | Purpose                                                                 |
| ------------------------ | ----------------------------------------------------------------------- |
| `hugo server`            | Local development server with live reload, at `http://localhost:1313/`. |
| `make build`             | Production build (`hugo --minify`) into `public/`.                      |
| `make clean`             | Delete `public/` and `resources/`.                                      |
| `npm install`            | Install Prettier and its plugin.                                        |
| `npx prettier --check .` | Check formatting. Use `--write` to fix it.                              |

No tests, link checks, or CI exist yet (roadmap Phase 1.0).

## Architecture

- `hugo.toml` holds the site config: `baseURL`, the title, contact details under `params.contact`, and the `studios` taxonomy (`studio = "studios"`).
- **Content** uses page bundles with YAML front matter. Images sit in the same folder as the page that uses them.
  - `content/_index.md` drives the homepage. Every homepage section is defined in front matter `params` (hero, story, studyAreas, welcome, faculty, summerAcademy, ready). The Markdown body is the Dean's letter.
  - `content/faculty/<last>_<first>/index.md` holds one faculty bio. It uses `layout: page_faculty_bio`, a `headshot.*` image, a `studios:` list of taxonomy terms, `weight` for ordering, and an optional `params.postNominal`.
  - `content/studios/<term>/_index.md` holds the content for each `studios` taxonomy term page, with an `instrument.jpg` image. Faculty pages are tagged with these terms.
  - Top-level pages (`registration`, `payment`, `schedule`, `contact`, `summer-academy`) get into the main navigation through `menus.main.weight` and use `params.image`.
- **Layouts** (`layouts/`):
  - `baseof.html` is the shell: Sass pipeline, fingerprinted CSS and JS, font preload.
  - `home.html` is the homepage.
  - `page.html` and `section.html` are generic. `section.html` renders a card list of child pages.
  - `page_faculty_bio.html` is the faculty bio layout.
  - `studios/taxonomy.html` and `studios/term.html` render the studio pages.
- **Partials** (`layouts/_partials/`):
  - `responsive_image.html` builds a WebP `srcset` from a page-bundle image. Its header comment documents the parameters it takes. Always use it rather than writing `<img>` tags by hand.
  - `card.html` is the card in card lists.
  - `cta.html` and `cta_group.html` render buttons from `{label, page, style}` lists in front matter. A missing target page triggers a build warning.
  - `header.html`, `footer.html`, `site_nav_list.html`, `logo.html`, `page_header.html`, and `studios_text.html` cover the rest of the page chrome.
- **Styles:** `assets/sass/main.scss` imports partials. Design tokens live in `_tokens.scss`, with one partial per area (`_home.scss`, `_cards.scss`, and so on).
- **Script:** `assets/js/script.js` toggles the mobile navigation menu.
- **Static files:** `static/` holds self-hosted fonts (EB Garamond, Nunito, Incognito Pro) and the favicon.

## Conventions

- Follow the existing patterns. Reuse the partials, put content in front matter `params`, and keep images in page bundles.
- Write YAML front matter in content files. Note that `archetypes/default.md` still produces TOML.
- Format with Prettier before committing. Templates use the go-template parser (see `.prettierrc`).
- Make small, focused changes. After each one, run `make build` and confirm there are no warnings.

## Constraints

- Do not change DNS, hosting, payment configuration, or secrets without explicit human approval.
- Never commit credentials. Registration and payment are handled by external providers (Wufoo, Breeze ChMS). The site only links to them.
- Do not claim that a build, deployment, or integration works unless it was actually tested.

## Known limitations and technical debt

- There is no validation, link checking, or CI, and the toolchain versions are not pinned.
- `npx prettier --check .` fails on 7 files that were never formatted: `.prettierrc`, `layouts/baseof.html`, `layouts/_partials/logo.html`, and the four front-matter-only pages. Format them in a separate change.
- `content/registration/`, `content/payment/`, `content/schedule/`, and `content/contact/` have front matter only and no body. Their content is still on the old site (see [docs/SITE-INVENTORY.md](docs/SITE-INVENTORY.md)).
- The old site's contact form has no static-site replacement yet.
- The student handbook PDF is hosted only on the old WordPress site.
- The Summer Academy dates (July 2026) in `content/summer-academy/index.md` have already passed.
- The homepage study-areas section is incomplete (TODO in `layouts/home.html`).
- Every faculty member has `weight: 0`, so the faculty list sorts by title, which is the first name. The old site sorted by last name.
- Faculty and summer URLs differ from the old site's, so redirects are needed at cutover (roadmap Phase 6).

## Documentation

- [docs/ROADMAP.md](docs/ROADMAP.md): phases, status, open decisions, and the execution protocol.
- [docs/SITE-INVENTORY.md](docs/SITE-INVENTORY.md): the old site's pages, files, and external links, with migration status.
- [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md): hosting, CI/CD, DNS cutover, and rollback.
- [docs/CONTENT-GUIDE.md](docs/CONTENT-GUIDE.md): how to make routine content updates.
- [README.md](README.md): setup for developers and maintainers.
