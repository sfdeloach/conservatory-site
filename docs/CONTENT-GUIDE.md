# Content guide

How to make routine updates to the website's content. You don't need to know how to program, but you do need to be able to edit text files and use Git, or to use GitHub's web editor.

Every page is a Markdown file (`.md`) inside `content/`. The section between the `---` lines at the top of each file is the **front matter**: settings such as the page title and image. Everything below it is the page text.

Preview your changes with `hugo server` before publishing them (see [README.md](../README.md)).

## Editing a page's text

1. Open the page's file:

   | Page             | File                              |
   | ---------------- | --------------------------------- |
   | Student handbook | `content/handbook/index.md`       |
   | Registration     | `content/registration/index.md`   |
   | Schedule         | `content/schedule/index.md`       |
   | Payment          | `content/payment/index.md`        |
   | Contact          | `content/contact/index.md`        |
   | Summer Academy   | `content/summer-academy/index.md` |
   | Studios (intro)  | `content/studios/_index.md`       |

2. Edit the text below the front matter. Use `##` for headings, `-` for bullet lists, and `[link text](https://example.com)` for links.

   Page text is shown in a narrow column that is comfortable to read. To make one block, such as a table, span the full width of the window, put `{.full-bleed}` on the line directly after it.

### Links and images

- **Link to another page** by its path: `[Schedule](/schedule/)`. To link to a section, add the heading's id, which is the heading in lowercase with spaces replaced by `-`: `[Withdrawal](/handbook/#withdrawal)`, or `[Withdrawal](#withdrawal)` on the same page.
- **Add an image** by putting the file in the page's folder and writing it on its own line: `![A description of the image](photo.jpg "An optional caption")`. The description (alt text) is required; it is read aloud to people who can't see the image. Images inside a sentence are not supported.
- Links open in the same tab, including links to other websites.
- **Add a quotation with an attribution** with the `quote` shortcode. Put the quoted text between the tags, give the person's name as `by`, and optionally their title as `role`:

  ```
  {{< quote by="Dr. R.C. Sproul" role="Founder of Saint Andrew’s Conservatory" >}}
  If music is, as Martin Luther says, a gift from God — then we are obliged to develop that gift.
  {{< /quote >}}
  ```

  The attribution is shown below the quotation, on the right. A line starting with `>` also makes a quotation, but without an attribution. The build fails if `by` is missing.

- **Add a video** with Hugo's built-in shortcode, on its own line: `{{< youtube id="VIDEO_ID" >}}` (or `vimeo`). The id is the part of the video's address after `v=`. Other HTML can't be pasted into a page; it is removed.
- The build fails, and nothing is published, if a link points to a page that doesn't exist, if an image file is missing, or if an image has no description. The error names the file and line to fix.

3. To replace a page's banner image, replace the image file in the same folder and keep the file name the front matter uses (`params.image`).

## Editing the homepage

All the homepage text is in the front matter of `content/_index.md`: hero, story, stats, faculty, Summer Academy, and the "Ready" section. Each section has an `eyebrow` (the small label above it), a `title`, and the body text. Buttons are lists of:

```yaml
- label: "Register Now" # button text
  page: "/registration" # page to link to (must exist)
  style: "primary" # "primary" or "outline"
```

The Dean's letter is the Markdown text below the front matter.

The studio cards in "Studio Offerings" come from `content/studios/` automatically, in `weight` order.

The photo behind the Summer Academy section is the Summer Academy page's banner image (`content/summer-academy/`, `params.image`). Replacing that image changes both.

### Featured faculty

The faculty shown on the homepage are listed under `faculty.featured`, as paths to their pages. They appear in the order listed. Four fit on one row on a computer screen.

```yaml
featured:
  - "/faculty/yount_terry"
  - "/faculty/bak_brian"
```

Each path must match a folder under `content/faculty/`. If it doesn't, the build fails with a `home.html: no faculty page found` message and nothing is published.

## Adding or updating a faculty member

1. Create a folder under `content/faculty/` named `lastname_firstname` in lowercase, such as `content/faculty/bak_brian/`. Faculty lists are sorted by this folder name, so it sets the last-name order. For a compound last name, write the whole last name first, with words joined by `_`, as in `traylor_chen_angelyn`.
2. Add a headshot to the folder, named `headshot`, with any common image extension (`headshot.jpg`, `.png`, `.webp`). Portrait photos work best. The top of the photo is kept when it is cropped.
3. Create `index.md` in that folder:

   ```markdown
   ---
   title: Firstname Lastname
   layout: "page_faculty_bio"
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
     To remove a faculty member, delete their folder. If they are featured on the homepage, also remove them from `faculty.featured` in `content/_index.md`, or the build fails.

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

### Studio requirements

A studio can list requirements for new students, such as an audition or a minimum age. They appear on the studio's page under "Requirements" and in the student handbook. Add them to the studio's `_index.md`:

```yaml
params:
  image: "instrument.jpg"
  requirements:
    - "An audition with the teacher is required."
    - "Students must be at least 14 years old."
```

Leave `requirements` out if there are none. The studio page then shows no Requirements section, and the handbook says "No additional requirements."

## Updating the semester schedule

The semester calendars are in the front matter of `content/schedule/index.md`, under `semesters`. They appear on the Schedule page and in the student handbook, so you only edit them here. Update them when each new calendar is ready: Spring in early November, Summer in March or April, and Fall in June or July.

```yaml
semesters:
  - name: "Fall 2026" # the heading
    summary: "15 weeks of instruction." # one line under the heading
    dates:
      - date: "July 1" # any text, such as "October 5–9"
        event: "Registration opens"
```

Add the new semester's entry, and remove a semester once it has ended. Semesters appear in the order listed. The build fails if the list is empty.

## The student handbook

The handbook is one page at `/handbook/`, edited in `content/handbook/index.md`. Edit its text like any other page. Some parts come from elsewhere, so change them there:

| Part of the handbook                        | Where to change it                                                 |
| ------------------------------------------- | ------------------------------------------------------------------ |
| Academic calendar                           | `content/schedule/index.md` (see "Updating the semester schedule") |
| Conservatory faculty                        | The faculty pages (see "Adding or updating a faculty member")      |
| Studios and their requirements              | The studio pages (see "Studio requirements")                       |
| Contact email and phone                     | `[params.contact]` in `hugo.toml`                                  |
| Fees, discounts, lesson rates, refund table | The handbook's own front matter (below)                            |

Fees are written into the text with a shortcode, such as `{{< handbook_value "fees.late" >}}`, which shows the value stored in the front matter:

```yaml
params:
  fees:
    late: "$15" # change the amount here; every mention updates
  lessonRates:
    - length: "30-minute lesson"
      price: "$33.00"
```

The contents menu is built from the headings (`##` and `###`), and the "Last updated" date changes by itself whenever the handbook or one of those sources changes.

The Registration and Payment pages show the same fees, lesson rates, and refund table with the same shortcodes, so a change in the handbook's front matter updates all three pages.

## Contact details

The address, phone number, and email in the footer, on the Contact page, and in the handbook come from `[params.contact]` in `hugo.toml`. The map link is built from the address.

## Registration and payment links

Every registration form (Wufoo) and payment form (Breeze ChMS) the site links to is kept in one file, `data/destinations.yaml`. Change a link there, and every page that shows it updates.

| Name                   | Form                                | Shown on              |
| ---------------------- | ----------------------------------- | --------------------- |
| `semesterRegistration` | Semester lesson registration        | Registration          |
| `summerCamp`           | Summer Music Camp registration      | Summer Academy        |
| `summerAcademy`        | Summer Music Academy registration   | Summer Academy        |
| `fullPayment`          | Full semester tuition payment       | Payment               |
| `installmentPayment`   | Installment payment (not in summer) | Payment               |
| `donation`             | Scholarship fund donation           | Registration, Payment |

Each entry looks like this:

```yaml
summerCamp:
  open: false # true shows the button; false hides it
  label: "Register for Summer Music Camp" # button text
  url: "https://sachapel.wufoo.com/forms/…" # the form's address
  closedText: "Registration opens in March." # optional; shown while closed
```

- To open a form, paste its address into `url` and change `open` to `true`. When it closes, change `open` back to `false`.
- While a form is closed, its `closedText` is shown in place of the button. Leave `closedText` out to show nothing.
- A page shows a button with `{{< destination_button "summerCamp" >}}`, using the entry's name. Give several names, as in `{{< destination_button "fullPayment" "installmentPayment" >}}`, to show their buttons side by side.
- The build fails, and nothing is published, if a page names an entry that doesn't exist, if an entry has no `label`, or if an open entry's `url` is empty or doesn't start with `https://`.

### Who looks after these links

| Links                                        | Owner                                                       |
| -------------------------------------------- | ----------------------------------------------------------- |
| Semester and summer registration (Wufoo)     | Conservatory Administrative Assistant (Conservatory Office) |
| Tuition payment and donation (Breeze ChMS)   | Director of Accounting                                      |
| The website itself: builds, failed publishes | Site maintainer                                             |

The owner makes or approves each change. Anyone with access to the GitHub repository can make the edit itself.

### Replacing the semester registration form

Each semester has its own Wufoo form with its own address, so this is done every semester. In `data/destinations.yaml`, under `semesterRegistration`:

1. Paste the new form's public link into `url`.
2. Change `label` to name the new semester, such as `"Register for Spring 2027"`.
3. When registration opens, change `open` to `true`.
4. When registration closes, change `open` back to `false`, and change `closedText` to name the next semester, such as `"Summer 2027 registration opens soon."`.

The registration dates themselves are in the semester calendar (see "Updating the semester schedule").

### Reopening Summer Camp and Academy registration

Once a year, follow the same steps for `summerCamp` and `summerAcademy`. Also replace "Dates for 2027 coming soon" in the text of `content/summer-academy/index.md` with that year's dates.

### Payment and donation links

The Breeze forms usually keep the same address from year to year, so most semesters need no change here.

- Change `fullPayment`, `installmentPayment`, or `donation` only when accounting replaces that form in Breeze.
- Installments are not available for the summer semester. To hide that button over the summer, change `installmentPayment` to `open: false`, and back to `true` for fall.
- The Payment page does not give the online card fee amounts; the Breeze forms show them. A fee change in Breeze needs no website edit.

### Retiring old forms

- Paste the new address over the old one. Don't keep old addresses in the file: Git keeps every earlier version, under **History** on the file's GitHub page.
- In Wufoo or Breeze, set the old form to stop accepting entries. Don't delete it, because its submissions and payments are stored there.
- If a form is retired with no replacement, change its entry to `open: false` instead of deleting the entry. Pages still use it, and the build fails if it is missing.

### Checklist for each registration period

Before opening:

- [ ] The new form exists, and its title names the right semester or summer.
- [ ] The fees and dates on the form match the student handbook and the Schedule page on the website.
- [ ] The Schedule has the new semester's calendar.
- [ ] Submit a test entry through the form, then delete the test entry in Wufoo.
- [ ] The site maintainer runs `make check-destinations` after the new address is in `data/destinations.yaml`. Every line should start with `OK`, or `NOTE` for a form that isn't open on the site yet.

Opening:

- [ ] Change `url`, `label`, and `open` in `data/destinations.yaml`, and commit.
- [ ] In the **Actions** tab, the run shows a green tick (see "Publishing changes").
- [ ] On the live site, click the button on Registration (or Summer Academy) and check that the right form opens.
- [ ] Check the page on a phone as well as a computer.

Each semester, check the payment links:

- [ ] On the live Payment page, open both payment buttons and the Donate button.
- [ ] Each opens the right Breeze form: "Conservatory Full Semester Lesson Payment", "Conservatory Installment Lesson Payment", and "Saint Andrew's Conservatory Scholarship Fund Donation". Don't make a test payment.

Closing:

- [ ] Change `open` to `false` and update `closedText` in `data/destinations.yaml`, and commit.
- [ ] Set the Wufoo form to stop accepting entries.
- [ ] On the live site, the page shows the closed text in place of the button.
- [ ] The site maintainer runs `make check-destinations` to confirm that the site and the forms agree.

If any step fails, set the entry to `open: false` (or leave it there), and contact the site maintainer.

## Publishing changes

Every change committed to the `main` branch is checked and published automatically.

1. On GitHub, open the file you want to change, and click the pencil icon (**Edit this file**).
2. Make your edit, then click **Commit changes…**. Write a short description, such as "Update fall schedule", and commit directly to `main`.
3. Open the **Actions** tab. Within a couple of minutes, the newest "Build and deploy" run shows either:
   - **a green tick**: the change is live. Check the page on the website.
   - **a red X**: the change was **not** published, because the automatic checks found a problem, such as a broken link. The website still shows the previous version. Fix the problem, or ask the site maintainer for help.
4. If a published change turns out to be wrong, edit it again, or ask the maintainer to revert it. See "Rollback and recovery" in [DEPLOYMENT.md](DEPLOYMENT.md).
