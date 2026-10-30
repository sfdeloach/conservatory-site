.PHONY: build check check-a11y check-destinations clean help

# Extra hugo arguments, e.g. HUGO_ARGS="--baseURL https://example.org/sub/"
HUGO_ARGS ?=

build: ## production minified build; fails on any Hugo warning
	hugo --minify --cleanDestinationDir --panicOnWarning --printPathWarnings $(HUGO_ARGS)

check: build ## strict build, then formatting, links, HTML, and accessibility checks
	npx --no-install prettier --check .
	lychee --offline --include-fragments --index-files index.html --root-dir "$(CURDIR)/public" --no-progress 'public/**/*.html'
	npx --no-install html-validate 'public/**/*.html'
	./scripts/check-a11y.sh

check-a11y: ## axe accessibility check of the built site (run make build first)
	./scripts/check-a11y.sh

check-destinations: ## online check of the forms in data/destinations.yaml (requires curl); not run in CI
	./scripts/check-destinations.sh

clean: ## delete 'public' and 'resources' folders
	rm -rf public
	rm -rf resources

help:  ## show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "};{printf "  %-20s %s\n", $$1, $$2}'
