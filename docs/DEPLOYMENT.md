# Deployment

How the site is built, hosted, published, and recovered. Most of this guide is completed in later roadmap phases. The sections below mark which phase fills each one in.

## Known facts

- **Production domain:** `saintandrewsconservatory.org`.
- **Current production site:** WordPress, served through Cloudflare. It stays live until the replacement is verified (roadmap Phase 6).
- **Production build:** `make build`, which runs `hugo --minify` and writes the site to `public/`. It requires Hugo extended and Dart Sass (see [README.md](../README.md)).
- **Approval:** changes to DNS, hosting settings, payment configuration, or secrets require explicit human approval.

## Hosting

The site is hosted on **GitHub Pages** and deployed by GitHub Actions. The decision was made in Phase 1.1, choosing between GitHub Pages and Cloudflare Pages.

### Why GitHub Pages

- **No new account.** The code is already on GitHub. Cloudflare Pages would have added a Cloudflare account to own and secure.
- **DNS stays where it is.** The church manages the domain's DNS at GoDaddy, and a staff member can make changes. GitHub Pages needs only a few records added there. Cloudflare Pages would have required moving the domain's DNS to Cloudflare.
- **Free.** GitHub Pages is free for public repositories. The repository can be public because everything in it is published on the site anyway.
- **Previews aren't needed.** Built-in pull-request previews were Cloudflare's main advantage. Instead, every pull request is still validated with `make check`, but not deployed.

### Accounts and ownership

| Item                                              | Owner                   | Notes                                                                       |
| ------------------------------------------------- | ----------------------- | --------------------------------------------------------------------------- |
| Domain and DNS (GoDaddy)                          | The church              | A church staff member makes DNS changes.                                    |
| Email for the domain                              | The church              | The MX records point to GoDaddy (`secureserver.net`). They must not change. |
| GitHub repository (`sfdeloach/conservatory-site`) | Steven DeLoach, for now | To be transferred to a church-owned GitHub account (see below).             |

### Plan limits

GitHub Pages allows a published site of up to 1 GB and has a soft limit of 100 GB of traffic a month. The built site is about 11 MB, so it is well within both.

### DNS records (applied in Phase 6)

At cutover, the church's staff add these records at GoDaddy. Check them against [GitHub's custom domain documentation](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site) first, because the addresses could change.

- `A` records for `saintandrewsconservatory.org`: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`.
- A `CNAME` record for `www` pointing to the GitHub Pages hostname of the account that owns the repository at the time.
- A `TXT` record to verify the domain with GitHub. This prevents another GitHub user from claiming the domain for their own site.
- Leave the existing MX and TXT records unchanged.

Until cutover, the site is served at `https://sfdeloach.github.io/conservatory-site/`. That address has a subpath, so the CI build must override `baseURL` for it (Phase 1.2).

### Moving the repository to the church's account

- Create the church's GitHub account (or organization) before the Phase 6 cutover. That way, the domain is verified and the DNS records are set up only once, under the final owner.
- After the transfer, enable Pages in the new repository, enter the custom domain again, and update the `www` CNAME if the Pages hostname changed.
- GitHub redirects the old repository URL, but update local Git remotes and any documentation links anyway.

## Build and validation

Run `make check`. It must pass before a change is published, and CI will run the same command (Phase 1.2).

| Step                        | Command                                                                                               | Fails when                                                                                                                                            |
| --------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Strict build (`make build`) | `hugo --minify --cleanDestinationDir --panicOnWarning --printPathWarnings`                            | Hugo reports any error or warning. For example, a homepage button that points to a page that doesn't exist, or two pages that write to the same path. |
| Internal link check         | `lychee --offline --include-fragments --root-dir "$(CURDIR)/public" --no-progress 'public/**/*.html'` | A link in the built site points to a page, file, or `#anchor` that doesn't exist.                                                                     |

The build empties `public/` first, so files left over from an earlier build can't hide a broken link.

What the checks don't cover yet:

- **External links** (Wufoo, Breeze, maps). These are skipped in offline mode. Checking them is slow and fails whenever another site is briefly down, so they are verified by hand (Phase 4) and may get a scheduled check later.
- Formatting (Prettier), HTML validity, and accessibility (Phase 5).

_Pinned tool versions are recorded here in Phase 1.2._

## CI/CD and preview deployments

_To be completed in Phase 1.2._ Record the workflow file, triggers, the production branch, preview URLs, and required secrets (names only, never values).

## Publishing a change

_To be completed in Phase 1.3._ Give the step-by-step Git workflow for publishing an approved change.

## Rollback and recovery

_To be completed in Phase 1.3._ Explain how to recognize a bad deployment and how to restore the previous release.

## DNS cutover

_To be completed in Phase 6._ Record the current DNS records, including the non-web records that must be preserved (MX, SPF/DKIM/DMARC, and verification records), the planned changes, the redirect map (from [SITE-INVENTORY.md](SITE-INVENTORY.md)), the validation steps, and the rollback steps.
