# Content guide

How to make routine updates to the website's content. You don't need to know how to program, but you do need to be able to edit text files and use Git, or to use GitHub's web editor.

Every page is a Markdown file (`.md`) inside `content/`. The section between the `---` lines at the top of each file is the **front matter**: settings such as the page title and image. Everything below it is the page text.

Preview your changes with `hugo server` before publishing them (see [README.md](../README.md)).

## Editing a page's text

1. Open the page's file:

   | Page            | File                              |
   | --------------- | --------------------------------- |
   | Registration    | `content/registration/index.md`   |
   | Schedule        | `content/schedule/index.md`       |
   | Payment         | `content/payment/index.md`        |
   | Contact         | `content/contact/index.md`        |
   | Summer Academy  | `content/summer-academy/index.md` |
   | Studios (intro) | `content/studios/_index.md`       |

2. Edit the text below the front matter. Use `##` for headings, `-` for bullet lists, and `[link text](https://example.com)` for links.

3. To replace a page's banner image, replace the image file in the same folder and keep the file name the front matter uses (`params.image`).

## Editing the homepage

All the homepage text is in the front matter of `content/_index.md`: hero, story, stats, faculty, Summer Academy, and the "Ready" section. Each section has an `eyebrow` (the small label above it), a `title`, and the body text. Buttons are lists of:

```yaml
- label: "Register Now" # button text
  page: "/registration" # page to link to (must exist)
  style: "primary" # "primary" or "outline"
```

The Dean's letter is the Markdown text below the front matter.

## Adding or updating a faculty member

1. Create a folder under `content/faculty/` named `lastname_firstname`, such as `content/faculty/bak_brian/`.
2. Add a headshot to the folder, named `headshot`, with any common image extension (`headshot.jpg`, `.png`, `.webp`). Portrait photos work best. The top of the photo is kept when it is cropped.
3. Create `index.md` in that folder:

   ```markdown
   ---
   title: Firstname Lastname
   layout: "page_faculty_bio"
   weight: 0
   draft: false
   studios:
     - "piano"
   params:
     postNominal: "M.M."
   ---

   The biography goes here.
   ```

   - `studios` lists the studios this person teaches in. Each entry must match a folder name under `content/studios/`.
   - `postNominal` is optional. It is shown after the name, as in "Brian Bak, DMA".
   - `weight` sets the order. Lower numbers come first. `0` means "no weight": those pages are listed after weighted ones, sorted by title, which is the first name. Every current faculty member uses `0`.

To remove a faculty member, delete their folder.

## Adding a studio

1. Create `content/studios/<name>/`, using a lowercase name such as `flute`.
2. Add `instrument.jpg` to that folder.
3. Create `_index.md`:

   ```markdown
   ---
   title: Flute
   draft: false
   weight: 90
   params:
     image: "instrument.jpg"
   ---

   A short description of the studio.
   ```

4. Add the studio's name to the `studios:` list of each faculty member who teaches it.

## Contact details

The address, phone number, and email in the footer come from `[params.contact]` in `hugo.toml`.

## Registration and payment links

_To be completed in Phase 4._ This section will describe where each registration form and payment link is kept, how to replace them each semester and each summer, and the checklist to follow before a registration period opens. The current links are listed in [SITE-INVENTORY.md](SITE-INVENTORY.md).

## Publishing changes

Every change committed to the `main` branch is checked and published automatically.

1. On GitHub, open the file you want to change, and click the pencil icon (**Edit this file**).
2. Make your edit, then click **Commit changes…**. Write a short description, such as "Update fall schedule", and commit directly to `main`.
3. Open the **Actions** tab. Within a couple of minutes, the newest "Build and deploy" run shows either:
   - **a green tick**: the change is live. Check the page on the website.
   - **a red X**: the change was **not** published, because the automatic checks found a problem, such as a broken link. The website still shows the previous version. Fix the problem, or ask the site maintainer for help.
4. If a published change turns out to be wrong, edit it again, or ask the maintainer to revert it. See "Rollback and recovery" in [DEPLOYMENT.md](DEPLOYMENT.md).
