.PHONY: serve clean help install

serve: ## Serve the site locally with live reload
	bundle exec jekyll serve --livereload

install: ## Install Jekyll and dependencies
	bundle install

clean: ## Clean generated site
	rm -rf _site .jekyll-cache

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
