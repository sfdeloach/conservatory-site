# Saint Andrew's Conservatory of Music website

The source for the Saint Andrew's Conservatory of Music website (`saintandrewsconservatory.org`). It is a static site built with [Hugo](https://gohugo.io/).

## Prerequisites

| Tool                                                             | Version            | Needed for                                           |
| ---------------------------------------------------------------- | ------------------ | ---------------------------------------------------- |
| [Hugo, extended edition](https://gohugo.io/installation/)        | 0.168.0            | Building the site                                    |
| [Dart Sass](https://sass-lang.com/install/) (the `sass` command) | 1.106.1            | Compiling the stylesheets                            |
| [Node.js](https://nodejs.org/) and npm                           | 24 (`.nvmrc`)      | Formatting and checks                                |
| [lychee](https://lychee.cli.rs/)                                 | 0.24.2             | Checking links (`make check`)                        |
| Git, `make`, `curl`, and python3                                 | any recent version | Getting the code, shortcuts, the accessibility check |

These are the versions CI uses, pinned in `.github/workflows/deploy.yml`, except Node, which is pinned in `.nvmrc`. Newer versions usually work, but if a local build differs from CI, install these exact versions first.

To confirm Hugo and Sass are installed, run `hugo version` and `sass --version`. The Hugo output must contain `+extended`.

## Getting started

```sh
git clone <repository-url> conservatory-site
cd conservatory-site
nvm use            # Node 24, from .nvmrc
npm install        # needed for formatting and make check
hugo server
```

Open `http://localhost:1313/`. The page reloads when you save a change.

## Common tasks

| Command                   | What it does                                                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `hugo server`             | Runs the local preview server.                                                                                                  |
| `make build`              | Builds the production site into `public/`. Any Hugo warning fails the build.                                                    |
| `make check`              | Runs the strict build, then checks formatting, links, HTML, and accessibility. Run it before committing.                        |
| `make check-a11y`         | Runs only the accessibility (axe) check, against the last build.                                                                |
| `make check-destinations` | Checks the registration and payment forms online (needs `curl`). Run it before a registration period opens and after it closes. |
| `make clean`              | Deletes the generated `public/` and `resources/` folders.                                                                       |
| `make help`               | Lists the Make targets.                                                                                                         |
| `npx prettier --check .`  | Checks formatting. Use `--write` to fix it.                                                                                     |

## Project structure

```text
content/        Pages, written in Markdown, with their images beside them
  _index.md     Homepage text, configured in the front matter
  faculty/      One folder per faculty member (index.md + headshot)
  studios/      One folder per studio (_index.md + instrument.jpg)
layouts/        Hugo templates; reusable pieces are in layouts/_partials/
assets/sass/    Stylesheets
assets/js/      JavaScript (mobile navigation menu)
static/         Fonts and favicon, copied to the site unchanged
docs/           Roadmap, deployment, content, and old-site inventory
hugo.toml       Site configuration, including contact details
```

For routine content changes, such as adding a faculty member or a studio, see [docs/CONTENT-GUIDE.md](docs/CONTENT-GUIDE.md).

## Documentation

- [docs/ROADMAP.md](docs/ROADMAP.md): project phases and status.
- [docs/CONTENT-GUIDE.md](docs/CONTENT-GUIDE.md): updating content.
- [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md): hosting, deployment, and recovery.
- [docs/SITE-INVENTORY.md](docs/SITE-INVENTORY.md): what is on the current site and what has been migrated.
- [CLAUDE.md](CLAUDE.md): architecture and conventions, written for AI-assisted development and also useful to developers.
