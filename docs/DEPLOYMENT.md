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

Until cutover, the site is served at `https://sfdeloach.github.io/conservatory-site/`. That address has a subpath, so CI overrides `baseURL` for it (see [CI/CD](#cicd)).

### Moving the repository to the church's account

- Create the church's GitHub account (or organization) before the Phase 6 cutover. That way, the domain is verified and the DNS records are set up only once, under the final owner.
- After the transfer, enable Pages in the new repository, enter the custom domain again, and update the `www` CNAME if the Pages hostname changed.
- GitHub redirects the old repository URL, but update local Git remotes and any documentation links anyway.

## Build and validation

Run `make check`. It must pass before a change is published, and CI runs the same command.

| Step                        | Command                                                                                               | Fails when                                                                                                                                            |
| --------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Strict build (`make build`) | `hugo --minify --cleanDestinationDir --panicOnWarning --printPathWarnings`                            | Hugo reports any error or warning. For example, a homepage button that points to a page that doesn't exist, or two pages that write to the same path. |
| Internal link check         | `lychee --offline --include-fragments --root-dir "$(CURDIR)/public" --no-progress 'public/**/*.html'` | A link in the built site points to a page, file, or `#anchor` that doesn't exist.                                                                     |

The build empties `public/` first, so files left over from an earlier build can't hide a broken link.

What the checks don't cover yet:

- **External links** (Wufoo, Breeze, maps). These are skipped in offline mode. Checking them is slow and fails whenever another site is briefly down, so they are verified by hand (Phase 4) and may get a scheduled check later.
- Formatting (Prettier), HTML validity, and accessibility (Phase 5).

### Pinned tool versions

| Tool          | Version | Pinned in                                                                                         |
| ------------- | ------- | ------------------------------------------------------------------------------------------------- |
| Hugo extended | 0.168.0 | `HUGO_VERSION` in `.github/workflows/deploy.yml`; minimum in `hugo.toml` (`[module.hugoVersion]`) |
| Dart Sass     | 1.106.1 | `DART_SASS_VERSION` in `.github/workflows/deploy.yml`                                             |
| lychee        | 0.24.2  | `LYCHEE_VERSION` in `.github/workflows/deploy.yml`                                                |

To upgrade a tool:

1. Change its version in the workflow's `env` block. For Hugo, also raise `min` in `hugo.toml` if the site now depends on a new feature.
2. Update the README prerequisites table.
3. Install the same version locally and run `make check`.
4. Open a pull request, and merge it once CI passes.

## CI/CD

The workflow is `.github/workflows/deploy.yml`.

| Event                                      | `build` job                                                       | `deploy` job                        |
| ------------------------------------------ | ----------------------------------------------------------------- | ----------------------------------- |
| Pull request                               | Installs the pinned tools and runs `make check`                   | Skipped; pull requests never deploy |
| Push to `main`                             | `make check`, then builds for Pages and uploads the site artifact | Deploys to GitHub Pages             |
| Manual run (`workflow_dispatch`) on `main` | Same as a push to `main`                                          | Deploys                             |
| Manual run on another branch               | `make check` only                                                 | Skipped                             |

- **Production branch:** `main`. The `deploy` job only runs for `main`, and GitHub's `github-pages` environment only accepts deployments from the default branch.
- **Failed checks block deployment.** If `make check` fails, the `build` job stops, and `deploy` (which `needs: build`) never runs. The live site stays as it was.
- **Permissions:** the workflow defaults to `contents: read`. Only the `deploy` job gets `pages: write` and `id-token: write`, which deploy needs to sign in with GitHub's built-in OIDC token.
- **Secrets:** none. Nothing needs to be stored in the repository's secrets.
- **No overlapping deployments:** `deploy` uses `concurrency: pages` with `cancel-in-progress: false`. A second deployment waits for the first to finish, and one already running is never cancelled midway.
- **Temporary address:** CI validates with the production `baseURL` from `hugo.toml`, then rebuilds with the URL GitHub Pages reports (`actions/configure-pages`), passed as `make build HUGO_ARGS="--baseURL …"`. Before the Phase 6 cutover, that URL is `https://sfdeloach.github.io/conservatory-site/`. Afterwards, it is the custom domain, and both builds are identical.
- **Action updates:** Dependabot (`.github/dependabot.yml`) opens a pull request each month when a GitHub Action used by the workflow has a new version.

### One-time setup

In the GitHub repository, go to **Settings → Pages → Build and deployment**, and set **Source** to **GitHub Actions**. Until this is done, the "Configure Pages" step fails on pushes to `main`.

## Publishing a change

_To be completed in Phase 1.3._ Give the step-by-step Git workflow for publishing an approved change.

## Rollback and recovery

_To be completed in Phase 1.3._ Explain how to recognize a bad deployment and how to restore the previous release.

## DNS cutover

_To be completed in Phase 6._ Record the current DNS records, including the non-web records that must be preserved (MX, SPF/DKIM/DMARC, and verification records), the planned changes, the redirect map (from [SITE-INVENTORY.md](SITE-INVENTORY.md)), the validation steps, and the rollback steps.
