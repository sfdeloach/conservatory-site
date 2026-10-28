# Saint Andrew's Conservatory Website — Roadmap

## Purpose

Complete, deploy, and maintain the conservatory's static website with a reliable, low-cost publishing workflow. The site should be accessible, responsive, easy to update, and maintainable by someone who is not necessarily a developer.

The production domain is `saintandrewsconservatory.org`. Do not change its DNS or replace the existing production site without explicit human approval.

## Status

| Phase | Title                                                 | Status      |
| ----- | ----------------------------------------------------- | ----------- |
| 0     | Repository discovery and documentation                | Done        |
| 1     | Production hosting and CI/CD                          | Done        |
| 2     | Complete the homepage                                 | Done        |
| 3     | Content migration, typography, and Markdown rendering | Done        |
| 4     | Registration and payment workflows                    | Done        |
| 5     | Accessibility, quality assurance, and SEO             | Not started |
| 6     | Launch readiness and domain cutover                   | Not started |
| 7     | Ongoing maintenance and handoff                       | Not started |

Status values: Not started, In progress, Done. Update this table when a phase changes state.

## Working principles

- Inspect the existing repository and understand its architecture before making changes.
- Preserve existing working functionality and established design conventions.
- Prefer small, focused, reviewable changes over unnecessary rewrites.
- Reuse existing components, templates, and dependencies where practical.
- Avoid adding dependencies unless their benefits justify their long-term maintenance cost.
- Run the relevant validation checks after each meaningful change.
- Never claim that a build, test, deployment, or external integration was verified unless it was actually tested.
- Never change production DNS, hosting settings, payment configuration, or secrets without explicit approval.
- Update this roadmap and the relevant documentation as work is completed.
- Record unresolved decisions and blockers rather than making consequential assumptions.

## 0. Repository discovery and documentation

### Tasks

- Inspect the repository structure, Hugo version, configuration, theme, templates, content files, assets, dependencies, and existing build commands.
- Identify existing tests, CI workflows, deployment configuration, and any unfinished implementation.
- Document the toolchain: Hugo (extended) version, Dart Sass (required by the `dartsass` transpiler in `layouts/baseof.html`), Node and Prettier with the Go-template plugin, and the Makefile targets.
- Inventory the existing live site at `saintandrewsconservatory.org`: its pages, URLs, content, forms, and external links. Record which content has not yet been migrated to this project. This inventory feeds content migration (Phase 3), registration and payment (Phase 4), and redirects (Phase 6).
- Remove the experimental `Dockerfile` in a small, separate change and record the decision.
- Create a root `CLAUDE.md` containing project architecture, coding conventions, commands, constraints, and links to relevant documentation.
- Write a conventional root `README.md` for developers and maintainers.
- Create a skeleton `docs/DEPLOYMENT.md` for hosting, CI/CD, DNS cutover, and rollback procedures. It is completed in Phases 1, 6, and 7, after the hosting decision.
- Create a skeleton `docs/CONTENT-GUIDE.md` for recurring content updates, including registration and payment links. It is completed in Phases 4 and 7.
- Document known limitations, outstanding decisions, and any existing technical debt.

### Acceptance criteria

- A new Claude Code session can understand the project without relying on previous conversation history.
- A new maintainer can run the site locally using the documented instructions.
- Build and validation commands are documented and verified.
- Existing project behavior and user changes are preserved.
- The live-site inventory exists, and unmigrated content is listed.

## 1. Production hosting and CI/CD

### 1.0 Establish baseline validation

- Make the production build fail on Hugo warnings and errors.
- Add an internal link check against the built site, and record the tool chosen and why.
- Expose both checks through a single documented command (for example, a Makefile target) so local runs and CI behave the same way.

Later phases extend these checks rather than create new, separate ones.

**Done:** `make check` runs the strict build and then lychee (see [DEPLOYMENT.md](DEPLOYMENT.md#build-and-validation)).

### 1.1 Evaluate hosting options

Compare GitHub Pages and Cloudflare Pages against:

- Hosting cost and plan limitations.
- Custom domain and HTTPS support.
- Pull-request previews.
- Automated builds and deployments.
- Rollback and recovery.
- Configuration complexity and long-term maintenance.
- Portability and vendor dependence.

Record the decision and rationale before implementing the production workflow.

**Done:** GitHub Pages. See [DEPLOYMENT.md](DEPLOYMENT.md#hosting).

### 1.2 Implement the deployment pipeline

- Pin the Hugo (extended) and Dart Sass versions, and any other required dependencies.
- Establish a reproducible production build.
- Configure GitHub Actions or the selected host's equivalent deployment workflow.
- Run validation checks before deployment.
- Run `make check` on every pull request without deploying, so broken changes never reach production. Preview deployments are not required.
- Deploy production only from the designated production branch.
- Use least-privilege workflow permissions and protect sensitive configuration.
- Prevent overlapping production deployments from causing inconsistent releases.

**Done:** the GitHub Actions workflow `.github/workflows/deploy.yml`. See [DEPLOYMENT.md](DEPLOYMENT.md#cicd).

### 1.3 Test deployment and recovery

- Verify the initial deployment using the host-provided URL.
- Test internal navigation, assets, page rendering, and external destinations.
- Confirm that failed builds or checks do not publish a release.
- Document how to identify and recover from a bad deployment.
- Verify recovery in a safe environment where practical.

**Done:** rehearsed on 2026-10-26. See "Recovery test results" in [DEPLOYMENT.md](DEPLOYMENT.md#recovery-test-results).

### Acceptance criteria

- A normal approved change can be published through the documented Git workflow.
- Production deployment is automated and repeatable.
- Validation failures prevent deployment.
- A maintainer can follow the documented recovery procedure.

## 2. Complete the homepage

### Tasks

- Style the story statistics as responsive large numbers with smaller labels.
- Complete the areas-of-study section by looping through the studios (see the TODO in `layouts/home.html`).
- Complete the faculty preview using existing faculty card markup and responsive_image.html.
- Select featured faculty explicitly using front matter where practical.
- Complete the Summer Academy and "Ready" full-width bands using the existing layout system.
- Resolve remaining homepage TODOs.
- Check responsive behavior, spacing, image loading, and content overflow.

**Done:** reviewed on 2026-10-26.

- Stats, studio cards, and featured faculty (`faculty.featured` in `content/_index.md`) are built.
- The Summer Academy and "Ready" sections are full-width bands.
- Eyebrows are styled, and section text and buttons are centred.
- No TODOs remain in the templates or styles.
- Checked at widths from 320 to 1920px:
  - no horizontal overflow, including with long test content;
  - only the hero image loads eagerly;
  - all motion respects `prefers-reduced-motion`.
- Checked by hand on 2026-10-27: keyboard focus inside the bands, and reduced motion with the OS setting. Both pass.

### Acceptance criteria

- All planned homepage sections are complete.
- Layouts work on mobile, tablet, and desktop.
- Components reuse existing patterns rather than introducing unnecessary duplication.
- Images have appropriate alternative text and dimensions.
- The page remains usable with long text and reduced-motion preferences enabled.

## 3. Content migration, typography, and Markdown rendering

Conservatory staff answered the content questions on 2026-10-27 and approved the migrated content on 2026-10-28. Their decisions are recorded in the tasks below and in the open decisions table.

**Principle:** content that changes from semester to semester (calendars, faculty, studios) has a single source of truth in `content/`. Other pages, including the student handbook, draw on that source at build time instead of keeping their own copy.

### Tasks

Work through the groups in this order. Each group is one or more small commits.

1. **Quick content fixes** (done on 2026-10-27)
   - Sort faculty lists by last name. A compound last name sorts by its first word, so Angelyn Traylor Chen sorts under T. **Done:** lists sort by folder name through `_partials/faculty_sort.html`.
   - Summer Academy page:
     - Replace the July 2026 dates with "Dates for 2027 coming soon".
     - Keep the general program descriptions. Remove the price, the audition deadlines, and the number of orchestras. The instrument list is now general too ("strings, winds, and keyboard instruments").
     - Replace the two closed "Register Here" links with a front matter switch and the form URL, so registration can be reopened without editing templates. Phase 4.1 may move the URL to a shared location. **Done:** `params.registration.camp` and `.academy` (`open`, `label`, `url`), rendered by the `registration_button` shortcode. Both are off.
2. **Prose typography** (done on 2026-10-27)
   - Introduce a consistent `.prose` wrapper for Markdown content.
   - Establish comfortable reading widths, generally around 65–75 characters per line.
   - Style headings, paragraphs, lists, links, blockquotes, tables, code, images, and captions.
   - Ensure intentional full-width components remain possible outside the standard prose measure.
   - Test against existing pages and against the handbook text, added early as a draft page.
   - **Done:** `_partials/prose.html` and `_prose.scss`. The column is 55ch, about 70–75 characters of Nunito; text is 16px, 18px from the `md` breakpoint. Headings in prose are left-aligned. `{.full-bleed}` spans the window. Drafts `content/style-test/` and `content/handbook/` are the test pages. Image and caption styles are in place, but are checked in group 3, once the image render hook makes Markdown images load. Wide tables, long URLs, and long code lines still overflow on narrow screens until groups 3 and 4.
3. **Render hooks and content checks** (done on 2026-10-27)
   - Implement Markdown render hooks:
     - heading anchors, which the handbook's contents menu needs;
     - links, failing the build on a broken internal link;
     - images, through `responsive_image.html`;
     - tables, in a wrapper that scrolls on narrow screens.
   - Add build-time checks for broken internal links and other important content errors. lychee already checks the links in the built site.
   - **Done:**
     - Link, image, and table hooks are in `layouts/_markup/`.
     - No heading hook was needed: Goldmark gives every heading an id, and staff don't want visible "#" links.
     - Internal links are now checked twice: by the link hook at build time, naming the source line, and by lychee on the built site, including fragments.
     - The build also fails on a missing image file, a missing alt text, a bundle with no matching image (such as a faculty folder without a headshot), and a `studios:` entry with no studio page.
4. **Links and narrow screens** (done on 2026-10-27)
   - Ensure links are distinguishable, keyboard-accessible, and visually consistent.
   - Handle long URLs, wide tables, and embedded content on narrow screens.
   - **Done:**
     - Every link colour meets WCAG AA contrast. Prose links are also underlined.
     - The footer focus ring was 1.8:1 against the dark background; it is now light.
     - A "Skip to content" link is the first focus stop on every page.
     - `scroll-padding-top` keeps section links clear of the sticky header.
     - Footer links no longer open a new tab, so every link opens in the same tab.
     - Long URLs and words break in prose, embeds fit the column, and code blocks and wide tables scroll inside their own box.
     - Checked at 320px: no page scrolls sideways. Full keyboard and contrast testing stays in Phase 5.
5. **Content migration** (done on 2026-10-27), using the Phase 0 inventory. This covers Schedule, Contact, the studio requirements, and the student handbook. The Registration and Payment pages are written in Phase 4.2, after their external links are centralized, so they are not written twice.
   - **Contact:**
     - The address, phone, and email come from `params.contact`.
     - Include the directions text ("near I-4 and SR 46 in Sanford") and the map link. Check that the `goo.gl` map link still works, and replace it with a full Google Maps URL if it doesn't.
     - There is no contact form.
   - **Schedule:**
     - Store the semester calendars once, in the Schedule page's front matter. The Schedule page and the handbook both display them.
     - Start with the old site's Summer and Fall 2026 calendars. Staff expect the Spring 2027 calendar in November 2026.
   - **Studio requirements:**
     - Add `params.requirements` to each studio, as a list of zero or more requirements. They are shown on the studio's page and in the handbook.
     - A studio with no requirements shows nothing on its page, and "No additional requirements." in the handbook (decided 2026-10-27).
     - Fill them from the 2026 handbook (organ, piano, violin, viola, cello, and voice). Staff supplied the harpsichord and trombone requirements on 2026-10-27.
   - **Student handbook:** see [Student handbook](#student-handbook) below.
   - **Done:**
     - Contact and Schedule are migrated. The `goo.gl` map link still worked, but it is replaced by a Maps search built from `params.contact`, shared with the footer.
     - All eight studio pages list requirements. The handbook's "No additional requirements." text stays in place for any studio added later without them.
     - The handbook is published at `/handbook/`, with every source in the table below.
     - `make check` now runs lychee with `--index-files index.html`, so fragments on directory links (such as `/handbook/#academic-calendar`) are checked.
     - The fee amounts in the handbook are now written consistently (`$15`, not `$15.00`).
6. **Staff review** (done on 2026-10-28)
   - Review content accuracy with conservatory staff, including dates, faculty, programs, and contact details.
   - Include the list of handbook corrections below.
   - Also confirm:
     - **Schedule:** the old site listed May 25, 2026 as "Labor Day". The new site says Memorial Day, as the handbook does.
     - **Schedule:** the Summer summary adds the handbook's "30-minute lesson minimum per student".
     - **Piano:** the handbook's wait-list note is carried over as a piano requirement. Is it still current?
     - **Requirements:** the wording of each studio's requirements, reworded slightly from the handbook (for example "an appropriately sized violin").
     - **Handbook:** the Summer study section is now a one-paragraph summary linking to the Summer Academy page.
   - **Done:** staff approved the content, the handbook corrections, and every item above with no changes. The piano wait-list note stays as a requirement.

### Student handbook

The handbook replaces the 2026 PDF that is hosted on the old site. It is designed for the web first.

- **Page:**
  - The whole handbook is one page, at `/handbook/`.
  - It is not in the main navigation or the footer. The Registration page links to it (Phase 4.2). Until then it is reachable only by its URL.
- **Contents menu:**
  - Generated from the headings, with fragment links (such as `/handbook/#withdrawal`) that scroll to each section.
  - On wide screens it is a sidebar that stays in view. On narrow screens it is a collapsible block at the top, using `<details>`, with no JavaScript.
  - Highlighting the current section while scrolling is optional and can be added later.
- **Print:** basic print styles hide the site header, navigation, and contents menu. A PDF-like layout and page numbers are not required.
- **Title and date:**
  - The title is "Student Handbook", with no year.
  - It shows a "Last updated" date taken from Git. This needs `enableGitInfo` and the full Git history in CI (`fetch-depth: 0` on `actions/checkout`).
  - The date should also reflect changes to the content the handbook draws on, not only to the handbook's own file.
- **Sources for each section:**

  | Section                                            | Source                                                                                                                                          |
  | -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
  | Academic calendar                                  | The Schedule page's front matter.                                                                                                               |
  | Faculty                                            | The faculty pages: name, `postNominal`, and studios, each linked to the bio, in last-name order.                                                |
  | Instruments offered and their requirements         | The studio pages and their `params.requirements`.                                                                                               |
  | Tuition, fees, and refund schedule                 | The handbook's own front matter, as structured data. The Registration page reuses it in Phase 4.2.                                              |
  | Contact details                                    | `params.contact` in `hugo.toml`. Use the general address `mconservatory@sachapel.com` everywhere. The closing line may still name Sharon Chang. |
  | Staff (Dean, administrative assistant, accounting) | The handbook only. These rarely change.                                                                                                         |
  | Summer study                                       | A one-paragraph summary in the handbook, linking to the Summer Academy page for details.                                                        |
  | Mission, registration, policies                    | The handbook's Markdown body.                                                                                                                   |

- **Corrections to the 2026 PDF**, approved by staff on 2026-10-28:
  - Bass is removed, because it is not taught.
  - The faculty list comes from the site. It adds Tammy Davis, replaces Olga Kolpakova (no longer on faculty) with Olga Ferroni, and uses full names: Angelyn Traylor Chen and Nathan Petersen.
  - The contact email is the general address instead of `schang@sachapel.com`.
  - Page references such as "see page 10" become links to sections.
  - The broken "Error! Bookmark not defined" entry in the table of contents is gone.

### Acceptance criteria

- All content from the old site that is still needed has been migrated, and staff have reviewed it.
- The student handbook is a web page whose calendar, faculty, and studio content comes from the single sources above.
- All content pages have consistent, readable typography.
- Internal links resolve correctly.
- Broken-link checks run as part of the validation workflow.
- Content remains readable and usable on small screens.
- Existing content and link behavior are preserved unless an intentional change is documented.

## 4. Registration and payment workflows

### 4.1 Centralize external destinations

- Inspect the existing Wufoo registration forms and Breeze ChMS checkout integration.
- Establish a single, clearly documented source of truth for each active destination.
- Keep semester registration, Summer Academy registration, and payment destinations distinct.
- Make routine URL updates possible without modifying templates or application logic wherever practical.
- Avoid duplicating the same destination across multiple files.
- Fit the Summer Academy registration switch built in Phase 3 (`params.registration` and the `registration_button` shortcode) into this approach.

**Done** (2026-10-28):

- All six destinations are in `data/destinations.yaml`, each with `open`, `label`, `url`, and an optional `closedText` shown while the form is closed (decided 2026-10-28).
- The `destination_button` shortcode and partial render them, replacing `registration_button` and `params.registration`. The Summer Academy page is unchanged in the built output.
- The build fails on an unknown entry, a missing label, or an open entry without an `https://` URL.
- Checked on 2026-10-28: the Fall 2026 semester form is closed and stored closed. Staff replace it when the Spring 2027 form is ready. All three Breeze forms load.
- The button labels for the semester and payment entries were placeholders, replaced in Phase 4.2.
- The online card fee is $15 on the full-payment form and $4 on the installment form. Phase 4.2 left the amounts to the forms (see below).

### 4.2 Build the Registration and Payment pages

- Write the content for `content/registration/index.md` and `content/payment/index.md`, which currently contain front matter only. This includes migrating their content from the old site (see [SITE-INVENTORY.md](SITE-INVENTORY.md#content-only-on-the-old-site)); Phase 3 leaves these two pages alone.
- Link the Registration page to the student handbook (`/handbook/`).
- Show tuition, fees, and the refund schedule from the handbook's front matter instead of repeating them.
- Present each active destination clearly, with the program, semester or year, and what the visitor should expect next.

**Done** (2026-10-28):

- Both pages are written. Every fee, rate, discount, and the refund schedule come from the handbook's front matter through `handbook_value`, `lesson_rates`, and `refund_schedule`. Every form button comes from `data/destinations.yaml`.
- Registration links to the handbook, the Schedule, Summer Academy, and Payment. While the semester form is closed it shows "Spring 2027 registration opens soon." (`closedText`).
- Payment has the two Breeze payment buttons, check instructions with the mailing address from `params.contact` (the new `"mailing"` detail of the `contact` shortcode), and Donate, which is also on Registration.
- Where the old site and the handbook disagreed, the handbook was followed (decided 2026-10-28). Staff confirmed all five as written on 2026-10-28:
  - **Scholarships:** a 25% scholarship after one full year, on the teacher's recommendation. The old site said "consistently high quality in a semester", renewable.
  - **Check payee:** "Saint Andrew's Conservatory". The old site said "Saint Andrew's Conservatory of Music".
  - **Due date:** "the first day of the semester". The old site said "the first day of lessons".
  - **Returning-student priority:** "tell the office before the end of the current semester". This line is from the old site only; the handbook doesn't mention it.
  - **Card fee:** the Payment page gives no amounts (the Breeze forms show $15 and $4). It says the form shows the fee.
- Button layout, fixed after review on 2026-10-28:
  - Buttons were stretching to full width, because `main` and `.prose` are grids. This included the faculty "Back to Faculty" button, which predates Phase 4.
  - Prose also underlined button text.
  - Every button now sits in a `.cta-group`: centred on faculty pages, as on the homepage, and aligned with the text inside prose. Prose underlines only links that aren't buttons.
  - `destination_button` takes several entry names for one group.
  - The style-test page has a Buttons section.

### 4.3 Document the update process

- Explain how to replace the active semester's registration form.
- Explain how to update the annual Summer Academy form.
- Document payment-link maintenance and ownership.
- Document how outdated forms and links are retired or archived.
- Include a checklist for reviewing and publishing registration changes.

**Done** (2026-10-28): see "Registration and payment links" in [CONTENT-GUIDE.md](CONTENT-GUIDE.md#registration-and-payment-links). Decided 2026-10-28:

- **Ownership:** by role, not by name, from the handbook's staff list. The Conservatory Administrative Assistant owns the Wufoo registration forms, the Director of Accounting owns the Breeze payment and donation forms, and the site maintainer owns the site. Names can be added in Phase 7.
- **Retiring forms:** a new URL replaces the old one in `data/destinations.yaml`, and Git history is the archive. Old forms are closed in Wufoo or Breeze, never deleted, because their submissions are stored there.
- **Checklist:** one checklist, in the content guide, for opening, the payment check, and closing.

### 4.4 Validate the user journey

- Verify the active form and checkout destinations.
- Test links and any embedded forms on mobile and desktop.
- Confirm that program descriptions and semester labels match the active forms.
- Verify the expected return, confirmation, and failure behavior where supported.
- Confirm that sensitive registration and payment information is handled by the appropriate external provider, not by the static site.
- Require human end-to-end verification before each registration cycle. This is the checklist in [CONTENT-GUIDE.md](CONTENT-GUIDE.md#checklist-for-each-registration-period); don't write a second one.

**Done** (2026-10-28).

**Automated checks** (done on 2026-10-28, against the deployed site at `7f0958a`):

- **Destinations:** pass.
  - Registration shows "Spring 2027 registration opens soon." and Donate.
  - Payment shows the full-semester, installment, and Donate buttons.
  - Summer Academy shows no buttons, because both forms are closed.
  - Every button URL matches `data/destinations.yaml`, and all six forms return 200.
- **Labels against the forms:** pass.
  - The three Wufoo forms ("Conservatory Student Registration - Fall 2026", "Summer Music Camp 2026 - 1st-5th Grade", "Summer Music Academy 2026 - Upper School") are closed, as `open: false` says.
  - The three Breeze form titles match the buttons and the content guide.
- **Sensitive data:** pass.
  - The built site has no form, iframe, or input elements.
  - Its only script is the local navigation toggle, with no network calls.
  - Every external link is `https://` to Breeze, Wufoo, or Google Maps.
  - No credential files are tracked, and the workflow uses no secrets.
- **`make check-destinations`** (`scripts/check-destinations.sh`) repeats the destination and label checks on demand. It was added because Breeze returns 200 for a form that doesn't exist (with the page title "Form"), so a plain link checker would miss a mistyped Breeze URL. It is not in CI. See [DEPLOYMENT.md](DEPLOYMENT.md#registration-and-payment-forms).

**Checks by hand** (done on 2026-10-28):

- **Phone and computer:** the pages and forms work. The testing found three layout problems, now fixed:
  - **Header on wide screens:** the logo and nav sat almost at the screen edges. Now they get 2rem of side padding from `lg`, and 4rem from `xl`. From 84rem up, they line up with the footer's content edges (`_header.scss`).
  - **Cards below `sm`:** on `/faculty/` and `/studios/`, each card stretched to the full column width, and its image sat at the left of the arch. Below 40em the card now hugs its 320px image and is centred (`_cards.scss`). The homepage card grids are unchanged.
  - **Space above the footer:** `main` now has 4rem of bottom padding on every page except the homepage, whose "Ready" band meets the footer (`_base.scss`).
- **Submission behaviour:** staff decided no test registration is needed for now. Never make a test payment.
- **Checklist:** staff approved the checklist in the content guide and will work through it before each registration period, starting with Spring 2027.

### Acceptance criteria

- Each active registration or payment destination is easy to identify and update.
- The update procedure is documented for a non-developer.
- All live destinations are manually verified before a registration period opens.
- No credentials or sensitive payment information are committed to the repository.

## 5. Accessibility, quality assurance, and SEO

These are ongoing requirements, not exclusively final polish.

### Accessibility and responsive quality

- Use semantic HTML and a logical heading hierarchy.
- Verify keyboard navigation and visible focus states.
- Check text contrast, link clarity, image alternatives, and form labels.
- Test common mobile and desktop layouts.
- Respect reduced-motion preferences.

### Automated validation

- Run a production Hugo build.
- Validate internal links.
- Add HTML validation and targeted automated accessibility checks where practical.
- Review build warnings and errors.
- Ensure required checks run in CI before production deployment.

### SEO and sharing

- Add appropriate page titles and meta descriptions.
- Add canonical URLs where appropriate.
- Configure Open Graph metadata and a production-accessible sharing image.
- Verify sitemap and robots directives.
- Add a custom 404 page and appropriate favicon/browser metadata.
- Preserve existing URLs where possible and document necessary redirects.

### Optional refinements

- Consider scroll-driven animations only where they improve the experience.
- Consider View Transitions after checking browser support, navigation behavior, and accessibility.
- Optimize images, fonts, and other assets without compromising visual quality.

### Acceptance criteria

- The site passes the agreed build and link checks.
- Core pages have appropriate metadata and social-sharing previews.
- Keyboard navigation and responsive behavior have been tested.
- Motion effects do not prevent users from accessing content.

## 6. Launch readiness and domain cutover

This phase begins only after hosting, content, and validation are ready.

### Tasks

- Finalize the redirect map from the Phase 0 inventory of the existing site's URLs.
- Verify all critical pages, forms, and payment destinations.
- Confirm the production build and deployment pipeline are working.
- Document the current DNS configuration before making changes.
- Preserve non-web DNS records (MX, SPF/DKIM/DMARC TXT, and domain-verification records) so email and third-party verifications keep working through the cutover.
- Prepare the DNS changes and verify HTTPS configuration.
- Obtain explicit approval before changing the production domain.
- Validate the live domain after cutover.
- Document the rollback procedure and recovery decision points.

### Acceptance criteria

- The production site is reachable over HTTPS at the intended domain.
- Critical pages, navigation, images, and external workflows function correctly.
- Necessary redirects are working.
- A maintainer knows how to identify problems and restore a working release.
- The old site is not retired until the replacement has been verified.

## 7. Ongoing maintenance and handoff

### Tasks

- Complete the `README`, deployment guide, and content-maintenance guide.
- Document how to make changes, preview them, publish them, and recover from mistakes.
- Identify the people responsible for content, registration links, and technical maintenance.
- Decide whether GitHub-based editing is sufficient or a CMS is needed.
- Decide whether analytics, webmaster verification, and uptime monitoring are worthwhile.
- Document how to update Hugo and dependencies safely.
- Review outdated content, external destinations, and redirects periodically.

### Acceptance criteria

- Routine content updates do not require unnecessary code changes.
- A maintainer can follow the documented publishing workflow independently.
- Ownership of recurring updates is clear.
- The project has a documented process for dependencies, troubleshooting, and recovery.

## Open decisions

Record each decision here, with its rationale, once it is made.

| Decision                                                 | Phase | Status | Outcome                                                                                                                                                          |
| -------------------------------------------------------- | ----- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Experimental `Dockerfile`                                | 0     | Done   | Removed; not part of the project                                                                                                                                 |
| Replacement for the old site's WordPress contact form    | 3     | Done   | None: an email link and phone number are enough (staff, 2026-10-27)                                                                                              |
| Hosting the student handbook PDF                         | 3     | Done   | Replaced by a web page at `/handbook/`, not a PDF (staff, 2026-10-27)                                                                                            |
| Faculty list order (first name or last name)             | 3     | Done   | Last name; a compound last name sorts by its first word (staff, 2026-10-27)                                                                                      |
| Hosting platform (GitHub Pages or Cloudflare Pages)      | 1     | Done   | GitHub Pages: no new account, free for a public repo, DNS stays at GoDaddy; previews not needed                                                                  |     |
| Internal link-check tool                                 | 1     | Done   | lychee, offline mode: maintained, packaged for Arch, official GitHub Action for CI                                                                               |
| Owners of content, registration links, and maintenance   | 4, 7  | Open   | By role in CONTENT-GUIDE (Phase 4.3): Conservatory Office (registration forms), Director of Accounting (payment forms), site maintainer (site). Names in Phase 7 |
| GitHub-based editing or a CMS                            | 7     | Open   |                                                                                                                                                                  |
| Analytics, webmaster verification, and uptime monitoring | 7     | Open   |                                                                                                                                                                  |

## Execution protocol

For each task:

1. Inspect the relevant files and current implementation.
2. State the proposed change and identify important assumptions.
3. Make the smallest reasonable change that meets the objective.
4. Run the relevant build, tests, and validation checks.
5. Review the diff for regressions, unrelated changes, and accidental configuration changes.
6. Summarize what changed, what was verified, what remains unresolved, and any manual steps required.
7. Update this roadmap and other documentation when the task is complete.
8. At the end of each phase, stop for human review before starting the next phase.

Do not mark a task complete merely because code has been written. Completion requires the applicable acceptance criteria to be satisfied or any remaining limitations to be explicitly documented.
