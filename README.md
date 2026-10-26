# Saint Andrew's Conservatory of Music website

The source for the Saint Andrew's Conservatory of Music website (`saintandrewsconservatory.org`). It is a static site built with [Hugo](https://gohugo.io/).

## Prerequisites

| Tool                                                             | Version            | Needed for                    |
| ---------------------------------------------------------------- | ------------------ | ----------------------------- |
| [Hugo, extended edition](https://gohugo.io/installation/)        | 0.168.0 or later   | Building the site             |
| [Dart Sass](https://sass-lang.com/install/) (the `sass` command) | 1.106 or later     | Compiling the stylesheets     |
| [Node.js](https://nodejs.org/) and npm                           | 20 or later        | Formatting with Prettier      |
| [lychee](https://lychee.cli.rs/)                                 | 0.24 or later      | Checking links (`make check`) |
| Git and `make`                                                   | any recent version | Getting the code, shortcuts   |

To confirm Hugo and Sass are installed, run `hugo version` and `sass --version`. The Hugo output must contain `+extended`.

## Getting started

```sh
git clone <repository-url> conservatory-site
cd conservatory-site
npm install        # only needed for formatting
hugo server
```

Open `http://localhost:1313/`. The page reloads when you save a change.

## Common tasks

| Command                  | What it does                                                                                 |
| ------------------------ | -------------------------------------------------------------------------------------------- |
| `hugo server`            | Runs the local preview server.                                                               |
| `make build`             | Builds the production site into `public/`. Any Hugo warning fails the build.                 |
| `make check`             | Runs the strict build, then checks every internal link and anchor. Run it before committing. |
| `make clean`             | Deletes the generated `public/` and `resources/` folders.                                    |
| `make help`              | Lists the Make targets.                                                                      |
| `npx prettier --check .` | Checks formatting. Use `--write` to fix it.                                                  |

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
