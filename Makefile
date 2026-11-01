.PHONY: build check check-a11y check-destinations check-redirects clean help

# Extra hugo arguments, e.g. HUGO_ARGS="--baseURL https://example.org/sub/"
HUGO_ARGS ?=

build: ## production minified build; fails on any Hugo warning
	hugo --minify --cleanDestinationDir --panicOnWarning --printPathWarnings $(HUGO_ARGS)

check: build ## strict build, then formatting, links, HTML, metadata, and accessibility checks
	npx --no-install prettier --check .
	lychee --offline --include-fragments --index-files index.html --root-dir "$(CURDIR)/public" --no-progress 'public/**/*.html'
	npx --no-install html-validate 'public/**/*.html'
	python3 scripts/check-meta.py
	./scripts/check-a11y.sh

check-a11y: ## axe accessibility check of the built site (run make build first)
	./scripts/check-a11y.sh

check-destinations: ## online check of the forms in data/destinations.yaml (requires curl); not run in CI
	./scripts/check-destinations.sh

check-redirects: ## online check of the old URLs and the 404 page at BASE=<url> (run make build first); not run in CI
	@test -n "$(BASE)" || { echo "usage: make check-redirects BASE=https://saintandrewsconservatory.org/" >&2; exit 2; }
	./scripts/check-redirects.sh "$(BASE)"

clean: ## delete 'public' and 'resources' folders
	rm -rf public
	rm -rf resources

help:  ## show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "};{printf "  %-20s %s\n", $$1, $$2}'
