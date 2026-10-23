.PHONY: build clean help

build: ## production minified build
	hugo --minify

clean: ## delete 'public' and 'resources' folders
	rm -rf public
	rm -rf resources

help:  ## show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "};{printf "  %-15s %s\n", $$1, $$2}'
