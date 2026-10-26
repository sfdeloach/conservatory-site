# Saint Andrew's Conservatory Website — Roadmap

## Purpose

Complete, deploy, and maintain the conservatory's static website with a reliable, low-cost publishing workflow. The site should be accessible, responsive, easy to update, and maintainable by someone who is not necessarily a developer.

The production domain is `saintandrewsconservatory.org`. Do not change its DNS or replace the existing production site without explicit human approval.

## Status

| Phase | Title                                                 | Status      |
| ----- | ----------------------------------------------------- | ----------- |
| 0     | Repository discovery and documentation                | Done        |
| 1     | Production hosting and CI/CD                          | Not started |
| 2     | Complete the homepage                                 | Not started |
| 3     | Content migration, typography, and Markdown rendering | Not started |
| 4     | Registration and payment workflows                    | Not started |
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

### 1.2 Implement the deployment pipeline

- Pin the Hugo (extended) and Dart Sass versions, and any other required dependencies.
- Establish a reproducible production build.
- Configure GitHub Actions or the selected host's equivalent deployment workflow.
- Run validation checks before deployment.
- Build and preview proposed changes without affecting production.
- Deploy production only from the designated production branch.
- Use least-privilege workflow permissions and protect sensitive configuration.
- Prevent overlapping production deployments from causing inconsistent releases.

### 1.3 Test deployment and recovery

- Verify the initial deployment using the host-provided URL.
- Test internal navigation, assets, page rendering, and external destinations.
- Confirm that failed builds or checks do not publish a release.
- Document how to identify and recover from a bad deployment.
- Verify recovery in a safe environment where practical.

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

### Acceptance criteria

- All planned homepage sections are complete.
- Layouts work on mobile, tablet, and desktop.
- Components reuse existing patterns rather than introducing unnecessary duplication.
- Images have appropriate alternative text and dimensions.
- The page remains usable with long text and reduced-motion preferences enabled.

## 3. Content migration, typography, and Markdown rendering

### Tasks

- Migrate the remaining content from the existing live site, using the Phase 0 inventory.
- Review content accuracy with conservatory staff, including dates, faculty, programs, and contact details. For example, the current Summer Academy dates (July 2026) have already passed.
- Introduce a consistent .prose wrapper for Markdown content.
- Establish comfortable reading widths, generally around 65–75 characters per line.
- Style headings, paragraphs, lists, links, blockquotes, tables, code, images, and captions.
- Ensure links are distinguishable, keyboard-accessible, and visually consistent.
- Handle long URLs, wide tables, and embedded content on narrow screens.
- Implement or improve Markdown render hooks where appropriate.
- Add build-time checks for broken internal links and other important content errors.
- Ensure intentional full-width components remain possible outside the standard prose measure.

### Acceptance criteria

- All content from the old site that is still needed has been migrated, and staff have reviewed it.
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

### 4.2 Build the Registration and Payment pages

- Write the content for `content/registration/index.md` and `content/payment/index.md`, which currently contain front matter only.
- Present each active destination clearly, with the program, semester or year, and what the visitor should expect next.

### 4.3 Document the update process

- Explain how to replace the active semester's registration form.
- Explain how to update the annual Summer Academy form.
- Document payment-link maintenance and ownership.
- Document how outdated forms and links are retired or archived.
- Include a checklist for reviewing and publishing registration changes.

### 4.4 Validate the user journey

- Verify the active form and checkout destinations.
- Test links and any embedded forms on mobile and desktop.
- Confirm that program descriptions and semester labels match the active forms.
- Verify the expected return, confirmation, and failure behavior where supported.
- Confirm that sensitive registration and payment information is handled by the appropriate external provider, not by the static site.
- Require human end-to-end verification before each registration cycle.

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

| Decision                                                 | Phase | Status | Outcome                          |
| -------------------------------------------------------- | ----- | ------ | -------------------------------- |
| Experimental `Dockerfile`                                | 0     | Done   | Removed; not part of the project |
| Replacement for the old site's WordPress contact form    | 3     | Open   |                                  |
| Hosting the student handbook PDF                         | 3     | Open   |                                  |
| Faculty list order (first name or last name)             | 3     | Open   |                                  |
| Hosting platform (GitHub Pages or Cloudflare Pages)      | 1     | Open   |                                  |
| Internal link-check tool                                 | 1     | Open   |                                  |
| Owners of content, registration links, and maintenance   | 4, 7  | Open   |                                  |
| GitHub-based editing or a CMS                            | 7     | Open   |                                  |
| Analytics, webmaster verification, and uptime monitoring | 7     | Open   |                                  |

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
