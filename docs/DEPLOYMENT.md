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

Run `make check`. It must pass before a change is published, and CI runs the same command. It needs the npm packages (`nvm use`, then `npm install`), lychee, curl, and python3.

| Step                        | Command                                                                                                                        | Fails when                                                                                                                                                        |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Strict build (`make build`) | `hugo --minify --cleanDestinationDir --panicOnWarning --printPathWarnings`                                                     | Hugo reports any error or warning. For example, a homepage button that points to a page that doesn't exist, or two pages that write to the same path.             |
| Internal link check         | `lychee --offline --include-fragments --index-files index.html --root-dir "$(CURDIR)/public" --no-progress 'public/**/*.html'` | A link in the built site points to a page, file, or `#anchor` that doesn't exist.                                                                                 |
| Formatting                  | `npx --no-install prettier --check .`                                                                                          | A file isn't formatted the way Prettier would format it. Run `npx prettier --write` on it.                                                                        |
| HTML validation             | `npx --no-install html-validate 'public/**/*.html'` (rules: `.htmlvalidate.json`, the `standard` and `a11y` presets)           | The built HTML is invalid, or breaks an accessibility rule that can be checked without a browser, such as a button without a `type` or an image without alt text. |
| Accessibility (axe)         | `scripts/check-a11y.sh` (settings: `.pa11yci.json`), also run alone by `make check-a11y`                                       | axe, run by pa11y-ci in headless Chrome on every page in `public/sitemap.xml`, reports an issue, such as text whose colour contrast is too low.                   |

The build empties `public/` first, so files left over from an earlier build can't hide a broken link.

What the checks don't cover yet:

- **External links** (Wufoo, Breeze, maps). These are skipped in offline mode. Checking them is slow and fails whenever another site is briefly down, so they are not part of `make check` or CI. The six forms have their own on-demand check, below.
- **Contrast over images and gradients.** axe can't measure text over a photo or a gradient (the page-header titles and the homepage hero), so it reports them as "needs review". These are warnings, not failures, and are checked by hand (Phase 5.2).
- **Keyboard use and layout.** The checks can't tell whether a page is easy to use with a keyboard or on a phone. That is checked by hand.

The accessibility check serves `public/` on `127.0.0.1:8137` with python3 while it runs (set `CHECK_A11Y_PORT` to use another port), and stops the server when it ends. Its Chrome comes from Puppeteer, which downloads it during `npm install`. CI caches that download, keyed on `package-lock.json`.

### Registration and payment forms

`make check-destinations` runs `scripts/check-destinations.sh`, which fetches each form in `data/destinations.yaml` and prints its page title. It fails when:

- a form can't be reached, or doesn't return 200 (a missing Wufoo form returns 404);
- a Breeze page's title is "Form". Breeze returns 200 with that title for a form that doesn't exist, so a plain link checker such as lychee would pass a mistyped Breeze address;
- an entry is open on the site, but its Wufoo form says it is no longer accepting submissions.

A form that accepts entries while the site shows it closed is only noted, because that is normal while staff prepare a new form. The command needs only `curl`. It is run on demand, as part of the registration checklist in [CONTENT-GUIDE.md](CONTENT-GUIDE.md#checklist-for-each-registration-period), and not in CI, so an outage at Wufoo or Breeze never blocks a deploy.

### Pinned tool versions

| Tool          | Version | Pinned in                                                                                         |
| ------------- | ------- | ------------------------------------------------------------------------------------------------- |
| Hugo extended | 0.168.0 | `HUGO_VERSION` in `.github/workflows/deploy.yml`; minimum in `hugo.toml` (`[module.hugoVersion]`) |
| Dart Sass     | 1.106.1 | `DART_SASS_VERSION` in `.github/workflows/deploy.yml`                                             |
| lychee        | 0.24.2  | `LYCHEE_VERSION` in `.github/workflows/deploy.yml`                                                |
| Node          | 24.x    | `.nvmrc`, read by `actions/setup-node` in CI; minimum in `package.json` (`engines`)               |

To upgrade a tool:

1. Change its version in the workflow's `env` block. For Hugo, also raise `min` in `hugo.toml` if the site now depends on a new feature. For Node, change `.nvmrc` and `engines` in `package.json` instead.
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

1. Make the change on your computer, and preview it with `hugo server`.
2. Run `make check`, and fix anything it reports.
3. Commit the change. Then either:
   - push to `main` (`git push`), or
   - push a branch, open a pull request, wait for its check to pass, and merge it. Merging counts as a push to `main`.
4. Open the repository's **Actions** tab and watch the "Build and deploy" run. A green tick means the change is live, usually within two minutes.
5. Confirm that the live site is running your commit (see [Which commit is live?](#which-commit-is-live)), and look over the pages you changed.

Small text edits can also be made in GitHub's web editor and committed directly to `main`. The same checks run, and a failing change is not published.

### Which commit is live?

Every page built by CI carries the commit it was built from:

```sh
curl -s https://sfdeloach.github.io/conservatory-site/ | grep -o 'build-commit[^>]*'
```

In a browser, view the page source and search for `build-commit`. Compare the value with the latest commit on `main`. Local builds don't include this tag.

## Rollback and recovery

### Spotting a problem

- **A red X in the Actions tab**, or a failure email from GitHub. The checks or the build failed, so **nothing was published**, and the live site still shows the last good release.
- **The live site looks wrong** even though the run succeeded. For example, broken styling, missing text, or a wrong link that the checks can't detect.
- **`build-commit` doesn't match the latest commit on `main`.** A deployment failed, or is still in progress.

### When a run failed

Nothing needs to be rolled back. Read the failed step's log in the Actions tab, then fix the problem and push again, or revert the commit (below).

### When a bad release is live

Use one of these methods.

**1. Revert the commit (preferred).** This permanently undoes the change and keeps the history clear.

```sh
git revert <bad-commit-sha>   # creates a new commit that undoes it
git push
```

In GitHub's web interface, a merged pull request has a **Revert** button. It opens a new pull request; merge that. Either way, the normal workflow checks and deploys the revert.

**2. Redeploy an earlier release (fastest).** This doesn't change `main`.

1. In the **Actions** tab, open the last good "Build and deploy" run for `main`.
2. Click **Re-run all jobs**. The run rebuilds and deploys that run's commit.
3. Confirm that `build-commit` shows the older commit.
4. **Follow up with a revert or a fix.** The next push to `main` deploys the latest `main` again, including the bad change, unless it has been reverted.

### Recovery test results

Rehearsed on 2026-10-26 against the temporary address, before launch.

| Test                           | Commit                             | Run                                                                                               | Result                                                                                                                 |
| ------------------------------ | ---------------------------------- | ------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Normal publish                 | `0b93271`                          | [40378069892](https://github.com/sfdeloach/conservatory-site/actions/runs/40378069892)            | Checks passed and deployed. Live `build-commit` = `0b93271`.                                                           |
| Failed check blocks deployment | `638ae2a` (deliberate broken link) | [40378656339](https://github.com/sfdeloach/conservatory-site/actions/runs/40378656339)            | "Validate" failed. The Pages steps and the `deploy` job were skipped. The live site stayed at `0b93271`.               |
| Recover by revert              | `5131706` (revert of `638ae2a`)    | [40379082951](https://github.com/sfdeloach/conservatory-site/actions/runs/40379082951)            | Checks passed and deployed. Live `build-commit` = `5131706`.                                                           |
| Redeploy an earlier release    | `0b93271`                          | [40378069892](https://github.com/sfdeloach/conservatory-site/actions/runs/40378069892), attempt 2 | Re-running the old run deployed it again. Live `build-commit` went back to `0b93271` while `main` stayed at `5131706`. |
| Next push replaces a rollback  | the commit that added this table   | the run for that push                                                                             | The live `build-commit` returned to the latest `main`.                                                                 |

Other checks done in Phase 1.3:

- All 28 pages in the live sitemap returned 200, and had no broken internal links. CSS, JavaScript, images, fonts, and the favicon all loaded at the temporary subpath.
- External destinations, checked online on 2026-10-26:
  - Both Summer Wufoo forms load, but they show "no longer accepting submissions", because the Summer 2026 forms have closed. Phase 4 stores them as closed in `data/destinations.yaml`, and staff replace them each spring (see the content guide).
  - The Google Maps footer link works in a browser. It returns 403 to automated link checkers, which is why it is excluded from any automated external-link check.

## DNS cutover

_To be completed in Phase 6._ Record the current DNS records, including the non-web records that must be preserved (MX, SPF/DKIM/DMARC, and verification records), the planned changes, the redirect map (from [SITE-INVENTORY.md](SITE-INVENTORY.md)), the validation steps, and the rollback steps.
