# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Jekyll-based website for **HKUST-Got-Skills**, a cross-campus hackathon at HKUST(GZ) and HKUST(CWB) where teams build AI coding skills for scientific workflows. Hosted via GitHub Pages at https://giggleliu.github.io/HKUST-Got-Skills/.

## Makefile Commands

```bash
make install   # Install Jekyll and dependencies (bundle install)
make serve     # Serve site locally with live reload (bundle exec jekyll serve --livereload)
make clean     # Remove _site/ and .jekyll-cache/
make help      # List available make targets
```

## Architecture

- **Theme**: `jekyll-theme-hacker` with a custom `_layouts/default.html` that overrides the theme layout (adds nav bar, `.btn` styling)
- **Navigation**: Defined in `_config.yml` under `nav:` — the layout iterates over `site.nav` to render links with active-page highlighting
- **Content pages**: All top-level `.md` files (index, program, resources, setup-guide, skills, step-by-step) use `layout: default` front matter
- **No collections, plugins, or data files** — purely static Markdown pages rendered through a single layout
