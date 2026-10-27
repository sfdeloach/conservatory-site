.PHONY: build check clean help

# Extra hugo arguments, e.g. HUGO_ARGS="--baseURL https://example.org/sub/"
HUGO_ARGS ?=

build: ## production minified build; fails on any Hugo warning
	hugo --minify --cleanDestinationDir --panicOnWarning --printPathWarnings $(HUGO_ARGS)

check: build ## strict build plus internal link check (requires lychee)
	lychee --offline --include-fragments --index-files index.html --root-dir "$(CURDIR)/public" --no-progress 'public/**/*.html'

clean: ## delete 'public' and 'resources' folders
	rm -rf public
	rm -rf resources

help:  ## show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "};{printf "  %-15s %s\n", $$1, $$2}'
