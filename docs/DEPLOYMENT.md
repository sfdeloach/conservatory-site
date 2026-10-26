# Deployment

How the site is built, hosted, published, and recovered. Most of this guide is completed in later roadmap phases. The sections below mark which phase fills each one in.

## Known facts

- **Production domain:** `saintandrewsconservatory.org`.
- **Current production site:** WordPress, served through Cloudflare. It stays live until the replacement is verified (roadmap Phase 6).
- **Production build:** `make build`, which runs `hugo --minify` and writes the site to `public/`. It requires Hugo extended and Dart Sass (see [README.md](../README.md)).
- **Approval:** changes to DNS, hosting settings, payment configuration, or secrets require explicit human approval.

## Hosting

_To be completed in Phase 1.1._ Record the chosen host (GitHub Pages or Cloudflare Pages), the reasons for choosing it, and any plan limits.

## Build and validation

_To be completed in Phase 1.0 and 1.2._ Record the pinned tool versions, the validation command, and what each check covers.

## CI/CD and preview deployments

_To be completed in Phase 1.2._ Record the workflow file, triggers, the production branch, preview URLs, and required secrets (names only, never values).

## Publishing a change

_To be completed in Phase 1.3._ Give the step-by-step Git workflow for publishing an approved change.

## Rollback and recovery

_To be completed in Phase 1.3._ Explain how to recognize a bad deployment and how to restore the previous release.

## DNS cutover

_To be completed in Phase 6._ Record the current DNS records, including the non-web records that must be preserved (MX, SPF/DKIM/DMARC, and verification records), the planned changes, the redirect map (from [SITE-INVENTORY.md](SITE-INVENTORY.md)), the validation steps, and the rollback steps.
