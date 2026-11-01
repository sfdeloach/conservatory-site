# Existing site inventory

A snapshot of the current production site at `https://saintandrewsconservatory.org/`, taken on 2026-10-26. It records which pages, files, and external links this project must replace, migrate, or redirect.

- **Platform:** WordPress, served through Cloudflare.
- **Source:** the WordPress sitemap (`/wp-sitemap-posts-page-1.xml`, 20 pages) plus each page's main and footer navigation.
- **Uses:** content migration (roadmap Phase 3), registration and payment (Phase 4), and redirects (built in Phase 5.4, verified on the live domain in Phase 6).

Re-check this inventory before the Phase 6 cutover, because the old site may change in the meantime.

## Pages

Migration status values:

- **Migrated:** the content is in this project.
- **Not migrated:** the page exists here but has no body content.
- **None:** no equivalent page exists here.

| Old URL                  | Title                | New path                         | Status   | Redirect | Notes                                                                                                                            |
| ------------------------ | -------------------- | -------------------------------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `/`                      | Home                 | `/`                              | Migrated | No       | Rewritten. See "Content only on the old site" below.                                                                             |
| `/registration/`         | Registration         | `/registration/`                 | Migrated | No       | Fees, tuition, refunds, scholarships from the handbook. Buttons from `data/destinations.yaml`.                                   |
| `/schedule/`             | Schedule             | `/schedule/`                     | Migrated | No       | Summer and Fall 2026 calendars, in `params.semesters`. May 25 corrected from \"Labor Day\" to Memorial Day (confirm with staff). |
| `/payments/`             | Payments             | `/payment/`                      | Migrated | Yes      | Check payment details and three Breeze buttons from `data/destinations.yaml`.                                                    |
| `/summer-music/`         | Summer Music         | `/summer-academy/`               | Migrated | Yes      | Dates replaced with "Dates for 2027 coming soon". Both Wufoo forms are in `data/destinations.yaml`, closed.                      |
| `/contact/`              | Contact Us           | `/contact/`                      | Migrated | No       | Directions text and contact details. No contact form, as staff decided. The map link is built from `params.contact`.             |
| `/faculty/`              | Faculty              | `/faculty/`                      | Migrated | No       | Same 12 faculty members.                                                                                                         |
| `/news/`                 | News                 | none                             | None     | Yes      | Empty ("Sorry, no content matched"). Redirect to `/`.                                                                            |
| `/angelyn-traylor-chen/` | Angelyn Traylor Chen | `/faculty/traylor_chen_angelyn/` | Migrated | Yes      |                                                                                                                                  |
| `/anne-jueng/`           | Anne Jueng           | `/faculty/jueng_anne/`           | Migrated | Yes      |                                                                                                                                  |
| `/brian-bak-2/`          | Brian Bak            | `/faculty/bak_brian/`            | Migrated | Yes      |                                                                                                                                  |
| `/cynthia-jimenez/`      | Cynthia Jimenez      | `/faculty/jimenez_cynthia/`      | Migrated | Yes      |                                                                                                                                  |
| `/dr-terry-yount/`       | Dr. Terry Yount      | `/faculty/yount_terry/`          | Migrated | Yes      |                                                                                                                                  |
| `/elise-jimenez/`        | Elise Jimenez        | `/faculty/jimenez_elise/`        | Migrated | Yes      |                                                                                                                                  |
| `/kristen-swed/`         | Kristen Swed         | `/faculty/swed_kirsten/`         | Migrated | Yes      | The old site spells the name both "Kristen" and "Kirsten". Staff confirmed "Kirsten".                                            |
| `/laura-yount/`          | Laura Yount          | `/faculty/yount_laura/`          | Migrated | Yes      |                                                                                                                                  |
| `/nathan-petersen/`      | Nathan Petersen      | `/faculty/petersen_nathan/`      | Migrated | Yes      |                                                                                                                                  |
| `/olga-ferroni/`         | Olga Ferroni         | `/faculty/ferroni_olga/`         | Migrated | Yes      |                                                                                                                                  |
| `/sharon-chang/`         | Sharon Chang         | `/faculty/chang_sharon/`         | Migrated | Yes      |                                                                                                                                  |
| `/tammy-davis/`          | Tammy Davis          | `/faculty/davis_tammy/`          | Migrated | Yes      |                                                                                                                                  |

Pages that are new in this project and have no old equivalent: `/studios/` and its eight studio pages.

## Redirect map

Each old URL is kept working by an `aliases` entry in the new page's front matter (Phase 5.4). Hugo writes a redirect page at the old path (`layouts/alias.html`). `make check-redirects BASE=<url>` checks them all on a deployed copy (see [DEPLOYMENT.md](DEPLOYMENT.md#old-urls-and-the-404-page)).

| Old URL                                                                            | New page                         | Alias in                                        |
| ---------------------------------------------------------------------------------- | -------------------------------- | ----------------------------------------------- |
| `/payments/`                                                                       | `/payment/`                      | `content/payment/index.md`                      |
| `/summer-music/`                                                                   | `/summer-academy/`               | `content/summer-academy/index.md`               |
| `/news/`                                                                           | `/`                              | `content/_index.md`                             |
| `/angelyn-traylor-chen/`                                                           | `/faculty/traylor_chen_angelyn/` | `content/faculty/traylor_chen_angelyn/index.md` |
| `/anne-jueng/`                                                                     | `/faculty/jueng_anne/`           | `content/faculty/jueng_anne/index.md`           |
| `/brian-bak-2/`                                                                    | `/faculty/bak_brian/`            | `content/faculty/bak_brian/index.md`            |
| `/cynthia-jimenez/`                                                                | `/faculty/jimenez_cynthia/`      | `content/faculty/jimenez_cynthia/index.md`      |
| `/dr-terry-yount/`                                                                 | `/faculty/yount_terry/`          | `content/faculty/yount_terry/index.md`          |
| `/elise-jimenez/`                                                                  | `/faculty/jimenez_elise/`        | `content/faculty/jimenez_elise/index.md`        |
| `/kristen-swed/`                                                                   | `/faculty/swed_kirsten/`         | `content/faculty/swed_kirsten/index.md`         |
| `/laura-yount/`                                                                    | `/faculty/yount_laura/`          | `content/faculty/yount_laura/index.md`          |
| `/nathan-petersen/`                                                                | `/faculty/petersen_nathan/`      | `content/faculty/petersen_nathan/index.md`      |
| `/olga-ferroni/`                                                                   | `/faculty/ferroni_olga/`         | `content/faculty/ferroni_olga/index.md`         |
| `/sharon-chang/`                                                                   | `/faculty/chang_sharon/`         | `content/faculty/chang_sharon/index.md`         |
| `/tammy-davis/`                                                                    | `/faculty/davis_tammy/`          | `content/faculty/davis_tammy/index.md`          |
| `/wp-content/uploads/2026/03/2026-Saint-Andrews-Conservatory-student-handbook.pdf` | `/handbook/`                     | `content/handbook/index.md`                     |

- **The handbook PDF:** Hugo writes this alias as a folder named `…handbook.pdf/` holding an `index.html`. A request for the PDF's address, which has no trailing slash, works only if GitHub Pages redirects it to that folder, as it does for other folders. Not yet verified: run `make check-redirects` on staging after the deploy. If it fails, the old PDF link gets the "Page not found" page, which links to the handbook.
- **Not redirected:** WordPress's own addresses, such as `/feed/`, `/wp-login.php`, and `/?page_id=…` links (a query string loads the homepage). Any other missing path gets the "Page not found" page.
- **Re-check before cutover:** the old site couldn't be reached from the Phase 5.4 work environment, so this map is from the 2026-10-26 snapshot. Compare it with the old site's sitemap again in Phase 6.

## Files hosted on the old site

These are served from WordPress (`/wp-content/uploads/`) and will stop working when the old site is retired.

| File                                                                               | Linked from                        | Action                                                                               |
| ---------------------------------------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------ |
| `/wp-content/uploads/2026/03/2026-Saint-Andrews-Conservatory-student-handbook.pdf` | Footer of every page; Registration | Replaced by the web page `/handbook/` (Phase 3). Redirected by an alias (Phase 5.4). |
| Faculty headshots and summer photos under `/wp-content/uploads/`                   | Faculty and Summer pages           | None. This project has its own images.                                               |

## External destinations

| Destination                                         | Purpose                                                                                    | Old page(s)            | In this project                                                             |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------ | ---------------------- | --------------------------------------------------------------------------- |
| `https://sachapel.wufoo.com/forms/w1u72etr1adhdx6/` | Fall 2026 semester registration (closed, 2026-10-28)                                       | Registration           | `semesterRegistration` in `data/destinations.yaml` (closed)                 |
| `https://sachapel.wufoo.com/forms/s1epcsxn1ahxr1d/` | Summer Music Camp registration (closed: "no longer accepting submissions", 2026-10-26)     | Summer Music           | `summerCamp` in `data/destinations.yaml` (closed)                           |
| `https://sachapel.wufoo.com/forms/s123tw3y1qmy8uq/` | Summer Music Academy registration (closed, 2026-10-26)                                     | Summer Music           | `summerAcademy` in `data/destinations.yaml` (closed)                        |
| `https://sachapel.breezechms.com/form/215b5b76`     | Full semester tuition payment (form loads, 2026-10-28; $15 online card fee)                | Payments               | `fullPayment` in `data/destinations.yaml`                                   |
| `https://sachapel.breezechms.com/form/215b5b`       | Installment payment, not available for summer (form loads, 2026-10-28; $4 online card fee) | Payments               | `installmentPayment` in `data/destinations.yaml`                            |
| `https://sachapel.breezechms.com/form/215b5b161825` | Scholarship fund donation (form loads, 2026-10-28)                                         | Registration, Payments | `donation` in `data/destinations.yaml`                                      |
| `https://goo.gl/maps/YzhFXRDH8zGuP6rL9`             | Map to the campus                                                                          | Contact                | Replaced by a Google Maps search for the address (`_partials/map_url.html`) |

## Content only on the old site

This is the work list for Phase 3 content migration and Phase 4 registration and payment. Confirm with conservatory staff whether each item is still current before migrating it.

- **Registration** (migrated in Phase 4.2, following the handbook where it differs; see the roadmap):
  - Registration policy: the $25 registration fee, the $25 change fee, priority for returning students, and the fee waiver for students returning within one year.
  - Tuition rates: $33, $49.50, and $66 for 30-, 45-, and 60-minute lessons.
  - The 20% discount for Saint Andrew's Chapel members.
  - Payment terms: the pay-in-full discount and the $15 late fee.
  - Scholarship information.
- **Payment** (migrated in Phase 4.2):
  - Check payment instructions: payable to "Saint Andrew's Conservatory of Music", mailing address, note "Lesson Payment".
  - The online processing-fee notice.
  - The donation appeal.
- **Schedule:** the semester calendars (registration windows, invoice and payment dates, breaks, recitals). The ones on the old site cover Summer and Fall 2026. Staff are fine with migrating those until the Spring 2027 calendar is ready.
- **Contact:**
  - Directions text ("near I-4 and SR 46 in Sanford"). Staff confirmed it.
  - A map link. Staff confirmed it.
  - A contact form. Staff decided to drop it: an email link and phone number are enough.
- **Student handbook (2026 PDF):** becomes a web page at `/handbook/`. See "Student handbook" in [ROADMAP.md](ROADMAP.md#student-handbook) for how each section is sourced and the corrections made to the PDF.
- **Homepage:**
  - The mission statement ("To train the next generation of musicians…"), which is used as the site tagline.
  - The full facilities paragraph. The new homepage keeps only the organ and piano counts, as stats; the old paragraph also mentions a harpsichord, studio and practice spaces, and the concert venue.
  - The "faculty are Christians, active in local churches" paragraph.
  - The note that some faculty require an audition and that there is no age restriction.
  - Already migrated: the Dean's letter and the story text, in `content/_index.md`.
- **Studios:** the old homepage lists bass and does not list viola or trombone. Staff confirmed that this project's list is correct and bass is not taught.
- **Footer:** links to "Registration, Tuition & Payment", "Semester Schedule", and the student handbook. Staff decided the new footer does not link to the handbook.
