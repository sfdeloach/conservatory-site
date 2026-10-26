# Existing site inventory

A snapshot of the current production site at `https://saintandrewsconservatory.org/`, taken on 2026-10-26. It records which pages, files, and external links this project must replace, migrate, or redirect.

- **Platform:** WordPress, served through Cloudflare.
- **Source:** the WordPress sitemap (`/wp-sitemap-posts-page-1.xml`, 20 pages) plus each page's main and footer navigation.
- **Uses:** content migration (roadmap Phase 3), registration and payment (Phase 4), and redirects (Phase 6).

Re-check this inventory before the Phase 6 cutover, because the old site may change in the meantime.

## Pages

Migration status values:

- **Migrated:** the content is in this project.
- **Not migrated:** the page exists here but has no body content.
- **None:** no equivalent page exists here.

| Old URL                  | Title                | New path                         | Status       | Redirect | Notes                                                                                |
| ------------------------ | -------------------- | -------------------------------- | ------------ | -------- | ------------------------------------------------------------------------------------ |
| `/`                      | Home                 | `/`                              | Migrated     | No       | Rewritten. See "Content only on the old site" below.                                 |
| `/registration/`         | Registration         | `/registration/`                 | Not migrated | No       | Fall 2026 registration, fees, tuition, scholarships. Wufoo and Breeze links.         |
| `/schedule/`             | Schedule             | `/schedule/`                     | Not migrated | No       | Summer 2026 and Fall 2026 semester calendars.                                        |
| `/payments/`             | Payments             | `/payment/`                      | Not migrated | Yes      | Check payment details and three Breeze links.                                        |
| `/summer-music/`         | Summer Music         | `/summer-academy/`               | Migrated     | Yes      | Both Wufoo forms are present. Dates are for July 2026.                               |
| `/contact/`              | Contact Us           | `/contact/`                      | Not migrated | No       | WordPress contact form, a Google Maps link, and directions text.                     |
| `/faculty/`              | Faculty              | `/faculty/`                      | Migrated     | No       | Same 12 faculty members.                                                             |
| `/news/`                 | News                 | none                             | None         | Yes      | Empty ("Sorry, no content matched"). Redirect to `/`.                                |
| `/angelyn-traylor-chen/` | Angelyn Traylor Chen | `/faculty/traylor_chen_angelyn/` | Migrated     | Yes      |                                                                                      |
| `/anne-jueng/`           | Anne Jueng           | `/faculty/jueng_anne/`           | Migrated     | Yes      |                                                                                      |
| `/brian-bak-2/`          | Brian Bak            | `/faculty/bak_brian/`            | Migrated     | Yes      |                                                                                      |
| `/cynthia-jimenez/`      | Cynthia Jimenez      | `/faculty/jimenez_cynthia/`      | Migrated     | Yes      |                                                                                      |
| `/dr-terry-yount/`       | Dr. Terry Yount      | `/faculty/yount_terry/`          | Migrated     | Yes      |                                                                                      |
| `/elise-jimenez/`        | Elise Jimenez        | `/faculty/jimenez_elise/`        | Migrated     | Yes      |                                                                                      |
| `/kristen-swed/`         | Kristen Swed         | `/faculty/swed_kirsten/`         | Migrated     | Yes      | The old site spells the name both "Kristen" and "Kirsten". Confirm which is correct. |
| `/laura-yount/`          | Laura Yount          | `/faculty/yount_laura/`          | Migrated     | Yes      |                                                                                      |
| `/nathan-petersen/`      | Nathan Petersen      | `/faculty/petersen_nathan/`      | Migrated     | Yes      |                                                                                      |
| `/olga-ferroni/`         | Olga Ferroni         | `/faculty/ferroni_olga/`         | Migrated     | Yes      |                                                                                      |
| `/sharon-chang/`         | Sharon Chang         | `/faculty/chang_sharon/`         | Migrated     | Yes      |                                                                                      |
| `/tammy-davis/`          | Tammy Davis          | `/faculty/davis_tammy/`          | Migrated     | Yes      |                                                                                      |

Pages that are new in this project and have no old equivalent: `/studios/` and its eight studio pages.

## Files hosted on the old site

These are served from WordPress (`/wp-content/uploads/`) and will stop working when the old site is retired.

| File                                                                               | Linked from                        | Action                                               |
| ---------------------------------------------------------------------------------- | ---------------------------------- | ---------------------------------------------------- |
| `/wp-content/uploads/2026/03/2026-Saint-Andrews-Conservatory-student-handbook.pdf` | Footer of every page; Registration | Migrate into this project, and redirect the old URL. |
| Faculty headshots and summer photos under `/wp-content/uploads/`                   | Faculty and Summer pages           | None. This project has its own images.               |

## External destinations

| Destination                                         | Purpose                                                                                | Old page(s)            | In this project           |
| --------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------- | ------------------------- |
| `https://sachapel.wufoo.com/forms/w1u72etr1adhdx6/` | Fall 2026 semester registration                                                        | Registration           | No                        |
| `https://sachapel.wufoo.com/forms/s1epcsxn1ahxr1d/` | Summer Music Camp registration (closed: "no longer accepting submissions", 2026-10-26) | Summer Music           | `content/summer-academy/` |
| `https://sachapel.wufoo.com/forms/s123tw3y1qmy8uq/` | Summer Music Academy registration (closed, 2026-10-26)                                 | Summer Music           | `content/summer-academy/` |
| `https://sachapel.breezechms.com/form/215b5b76`     | Full semester tuition payment                                                          | Payments               | No                        |
| `https://sachapel.breezechms.com/form/215b5b`       | Installment payment (not available for summer)                                         | Payments               | No                        |
| `https://sachapel.breezechms.com/form/215b5b161825` | Scholarship fund donation                                                              | Registration, Payments | No                        |
| `https://goo.gl/maps/YzhFXRDH8zGuP6rL9`             | Map to the campus                                                                      | Contact                | No                        |

## Content only on the old site

This is the work list for Phase 3 content migration and Phase 4 registration and payment. Confirm with conservatory staff whether each item is still current before migrating it.

- **Registration:**
  - Registration policy: the $25 registration fee, the $25 change fee, priority for returning students, and the fee waiver for students returning within one year.
  - Tuition rates: $33, $49.50, and $66 for 30-, 45-, and 60-minute lessons.
  - The 20% discount for Saint Andrew's Chapel members.
  - Payment terms: the pay-in-full discount and the $15 late fee.
  - Scholarship information.
- **Payment:**
  - Check payment instructions: payable to "Saint Andrew's Conservatory of Music", mailing address, note "Lesson Payment".
  - The online processing-fee notice.
  - The donation appeal.
- **Schedule:** the semester calendars (registration windows, invoice and payment dates, breaks, recitals). The ones on the old site cover Summer and Fall 2026.
- **Contact:**
  - Directions text ("near I-4 and SR 46 in Sanford").
  - A map link.
  - A contact form. This is a WordPress form, so a static site needs a replacement or a decision to drop it.
- **Homepage:**
  - The mission statement ("To train the next generation of musicians…"), which is used as the site tagline.
  - The full facilities paragraph. The new homepage keeps only the organ and piano counts, as stats; the old paragraph also mentions a harpsichord, studio and practice spaces, and the concert venue.
  - The "faculty are Christians, active in local churches" paragraph.
  - The note that some faculty require an audition and that there is no age restriction.
  - Already migrated: the Dean's letter and the story text, in `content/_index.md`.
- **Studios:** the old homepage lists bass and does not list viola or trombone. Confirm the current list of studios.
- **Footer:** links to "Registration, Tuition & Payment", "Semester Schedule", and the student handbook.
