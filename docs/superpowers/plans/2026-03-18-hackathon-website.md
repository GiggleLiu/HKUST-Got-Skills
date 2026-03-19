# HKUST-Got-Skills Website Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a multi-page Jekyll website for the HKUST-Got-Skills hackathon, hosted on GitHub Pages with the Hacker theme.

**Architecture:** Jekyll static site at the repo root. Custom `_layouts/default.html` overrides the Hacker theme to add a navigation bar. GitHub Issues with a structured template for idea collection. All content in markdown files.

**Tech Stack:** Jekyll, GitHub Pages, Hacker theme (`pages-themes/hacker`), GitHub Issue Templates (YAML format)

**Spec:** `docs/superpowers/specs/2026-03-18-hackathon-website-design.md`

---

## File Structure

```
HKUST-Got-Skills/
├── _config.yml                          # Jekyll config: title, description, theme, nav links
├── _layouts/
│   └── default.html                     # Custom layout: Hacker theme + navigation bar
├── index.md                             # Home page
├── program.md                           # Program / schedule
├── resources.md                         # Tools, guides, blog links
├── organizers.md                        # Organizer bios
├── ideas.md                             # How to submit project ideas
└── .github/
    └── ISSUE_TEMPLATE/
        └── project-idea.yml             # Structured issue template for idea submissions
```

Note: existing `learn-skill/` and `docs/` directories are preserved and unmodified.

---

### Task 1: Jekyll Configuration

**Files:**
- Create: `_config.yml`

- [ ] **Step 1: Create `_config.yml`**

```yaml
title: HKUST-Got-Skills
description: "Design a skill to automate and accelerate scientific discovery"
theme: jekyll-theme-hacker
show_downloads: false

nav:
  - title: Home
    url: /
  - title: Program
    url: /program
  - title: Resources
    url: /resources
  - title: Organizers
    url: /organizers
  - title: Ideas
    url: /ideas
```

- [ ] **Step 2: Commit**

```bash
git add _config.yml
git commit -m "feat: add Jekyll config with Hacker theme and navigation"
```

---

### Task 2: Custom Layout with Navigation

**Files:**
- Create: `_layouts/default.html`

The Hacker theme has no multi-page navigation. Override its default layout to inject a nav bar in the header.

- [ ] **Step 1: Create `_layouts/default.html`**

Based on the Hacker theme's default layout, add a `<nav>` element after the header's `<h2>`. The nav reads links from `site.nav` defined in `_config.yml`.

```html
<!DOCTYPE html>
<html lang="en-US">
  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="{{ '/assets/css/style.css?v=' | append: site.github.build_revision | relative_url }}">
    {% include head-custom.html %}
    {% seo %}
    <style>
      nav.site-nav {
        margin-top: 10px;
      }
      nav.site-nav a {
        color: #b5e853;
        margin-right: 15px;
        text-decoration: none;
        font-size: 14px;
      }
      nav.site-nav a:hover {
        text-decoration: underline;
      }
      nav.site-nav a.active {
        text-decoration: underline;
      }
    </style>
  </head>

  <body>

    <header>
      <div class="container">
        <a id="a-title" href="{{ '/' | relative_url }}">
          <h1>{{ site.title }}</h1>
        </a>
        <h2>{{ site.description }}</h2>

        <nav class="site-nav">
          {% for link in site.nav %}
            <a href="{{ link.url | relative_url }}"
               {% if page.url == link.url %}class="active"{% endif %}>
              {{ link.title }}
            </a>
          {% endfor %}
        </nav>

        <section id="downloads">
          <a href="{{ site.github.repository_url }}" class="btn btn-github"><span class="icon"></span>View on GitHub</a>
        </section>
      </div>
    </header>

    <div class="container">
      <section id="main_content">
        {{ content }}
      </section>
    </div>
  </body>
</html>
```

- [ ] **Step 2: Commit**

```bash
git add _layouts/default.html
git commit -m "feat: add custom layout with navigation bar"
```

---

### Task 3: Home Page

**Files:**
- Create: `index.md`

- [ ] **Step 1: Create `index.md`**

```markdown
---
layout: default
title: Home
---

# HKUST-Got-Skills

**Design a skill to automate and accelerate scientific discovery.**

A cross-campus hackathon bringing together HKUST(GZ) and HKUST(CWB) to build AI coding skills that transform scientific research workflows.

## What

Teams design and build **skills** — reusable automation modules for AI coding tools (Claude Code, Cursor, Codex CLI, OpenCode, and more) — that help scientists work faster and smarter.

Whether it's automating literature reviews, generating benchmark scripts, writing papers, or building computational libraries, your skill should make a real scientific workflow better.

## When

TBD

## Where

TBD — HKUST(GZ) campus, with remote participation from HKUST(CWB)

## Format

1. **Tutorials** — Learn AI coding tools and how to write skills
2. **Hacking** — Form teams and build your skill
3. **Showcase** — Demo your creation, peer voting for favorites

## Explore

- [Program](program) — Schedule and format
- [Resources](resources) — Tools, guides, and reading
- [Organizers](organizers) — Who's behind this
- [Ideas](ideas) — Submit and browse project ideas

## Want to Join?

This is an invite-only event. If you are interested in participating, please contact [jinguoliu@hkust-gz.edu.cn](mailto:jinguoliu@hkust-gz.edu.cn).
```

- [ ] **Step 2: Commit**

```bash
git add index.md
git commit -m "feat: add home page"
```

---

### Task 4: Program Page

**Files:**
- Create: `program.md`

- [ ] **Step 1: Create `program.md`**

```markdown
---
layout: default
title: Program
---

# Program

## Part 1 — Tutorials

Hands-on sessions to get everyone up to speed with AI coding tools and skill development.

| Session | Topic | Speaker |
|---------|-------|---------|
| 1 | Introduction to AI coding tools (Claude Code, Cursor, Codex CLI, OpenCode) | TBD |
| 2 | What are "skills" and how to write one | TBD |
| 3 | Live demo: building a skill for a scientific workflow | TBD |

## Part 2 — Hackathon

| Time | Activity |
|------|----------|
| TBD | Team formation and idea pitching |
| TBD | Hacking |
| TBD | Hacking (continued) |
| TBD | Peer showcase and voting |

## Deliverables

Each team presents:
- A working skill prototype (for any AI coding tool)
- A short demo showing the skill in action on a scientific workflow
```

- [ ] **Step 2: Commit**

```bash
git add program.md
git commit -m "feat: add program page"
```

---

### Task 5: Resources Page

**Files:**
- Create: `resources.md`

- [ ] **Step 1: Create `resources.md`**

```markdown
---
layout: default
title: Resources
---

# Resources

## Setup Guide

Get your AI coding tools ready before the hackathon:

- [AI Coding Tool Setup Guide](https://github.com/GiggleLiu/HKUST-Got-Skills/blob/main/learn-skill/docs/setup-guide.md) — Installation instructions for Claude Code, Cursor, Codex CLI, and OpenCode

## AI Coding Tools

| Tool | Type | Link |
|------|------|------|
| Claude Code | Terminal CLI | [code.claude.com](https://code.claude.com) |
| Cursor | IDE | [cursor.com](https://www.cursor.com) |
| Codex CLI | Terminal CLI | [github.com/openai/codex](https://github.com/openai/codex) |
| OpenCode | Terminal CLI | [opencode.ai](https://opencode.ai) |

## Blog Posts

Background reading on AI-assisted scientific workflows:

- [Vibe Coding Done Right](https://github.com/GiggleLiu/HKUST-Got-Skills/blob/main/learn-skill/docs/blog-vibe.md) — Test-driven approach to AI-generated code
- [Git Workflow for AI Coding](https://github.com/GiggleLiu/HKUST-Got-Skills/blob/main/learn-skill/docs/blog-git-workflow.md) — Using Git to manage human-AI collaboration
- [Sustainable Automation](https://github.com/GiggleLiu/HKUST-Got-Skills/blob/main/learn-skill/docs/blog-sustainable-automation.md) — CLAUDE.md and Skills for persistent AI workflows

## Hands-on Examples

Real examples of AI-accelerated scientific workflows:

- Brainstorming a scientific idea (7 prompts)
- Generating a research report (2 prompts)
- Building a scientific computing library (9 prompts)
- Generating benchmark data (4 prompts)
- Writing a paper draft (8 prompts)

See the [full hands-on document](https://github.com/GiggleLiu/HKUST-Got-Skills/blob/main/learn-skill/docs/hands-on.md) for details.
```

- [ ] **Step 2: Commit**

```bash
git add resources.md
git commit -m "feat: add resources page"
```

---

### Task 6: Organizers Page

**Files:**
- Create: `organizers.md`

- [ ] **Step 1: Create `organizers.md`**

```markdown
---
layout: default
title: Organizers
---

# Organizers

## Jin-Guo Liu

Assistant Professor, Hong Kong University of Science and Technology (Guangzhou).

Research in scientific computing and neutral atom quantum computing. Developer of open-source scientific computing frameworks including [Yao](https://github.com/QuantumBFS/Yao.jl) (quantum simulator supported by Unitary Fund) and generic tensor network algorithm libraries.

- GitHub: [GiggleLiu](https://github.com/GiggleLiu)
- Email: [jinguoliu@hkust-gz.edu.cn](mailto:jinguoliu@hkust-gz.edu.cn)

## Xi Dai

TBD
```

- [ ] **Step 2: Commit**

```bash
git add organizers.md
git commit -m "feat: add organizers page"
```

---

### Task 7: Ideas Page

**Files:**
- Create: `ideas.md`

- [ ] **Step 1: Create `ideas.md`**

```markdown
---
layout: default
title: Ideas
---

# Project Ideas

Have an idea for a skill that could accelerate scientific discovery? Share it here!

## How to Submit

1. Go to [the Issues page](https://github.com/GiggleLiu/HKUST-Got-Skills/issues/new?template=project-idea.yml)
2. Fill in the project idea template
3. Submit — others can comment and discuss

## Browse Ideas

[View all submitted ideas](https://github.com/GiggleLiu/HKUST-Got-Skills/issues?q=is%3Aissue+label%3Aproject-idea)

## Need Inspiration?

Here are some directions to think about:

- **Literature Review Skill** — Automate searching, summarizing, and organizing papers on a research topic
- **Benchmark Automation Skill** — Generate and run benchmarks for computational experiments with configurable parameters
- **Paper Writing Skill** — Assist with drafting, checking notation consistency, and managing citations
- **Data Analysis Skill** — Automate common data processing and visualization pipelines for experimental results
- **Code Porting Skill** — Help translate scientific code between languages (e.g., Julia to Rust, Python to C++)
```

- [ ] **Step 2: Commit**

```bash
git add ideas.md
git commit -m "feat: add ideas page"
```

---

### Task 8: GitHub Issue Template

**Files:**
- Create: `.github/ISSUE_TEMPLATE/project-idea.yml`

- [ ] **Step 1: Create `.github/ISSUE_TEMPLATE/project-idea.yml`**

```yaml
name: Project Idea
description: Submit a hackathon project idea
labels: ["project-idea"]
body:
  - type: input
    id: title
    attributes:
      label: Project Title
      description: A short, descriptive name for your skill
      placeholder: "e.g., Automated Literature Review Skill"
    validations:
      required: true
  - type: textarea
    id: description
    attributes:
      label: Description
      description: What does this skill do? What problem does it solve?
      placeholder: "Describe the skill and the scientific workflow it improves..."
    validations:
      required: true
  - type: dropdown
    id: target-tool
    attributes:
      label: Target Tool
      description: Which AI coding tool will this skill be built for?
      options:
        - Claude Code
        - Cursor
        - Codex CLI
        - OpenCode
        - Any / Tool-agnostic
    validations:
      required: true
  - type: input
    id: domain
    attributes:
      label: Scientific Domain
      description: What area of science does this skill accelerate?
      placeholder: "e.g., Quantum Computing, Materials Science, Bioinformatics"
    validations:
      required: true
  - type: textarea
    id: team
    attributes:
      label: Team
      description: Are you looking for teammates? What skills would be helpful?
      placeholder: "e.g., Looking for 1-2 teammates with Python/ML experience"
    validations:
      required: false
```

- [ ] **Step 2: Commit**

```bash
git add .github/ISSUE_TEMPLATE/project-idea.yml
git commit -m "feat: add GitHub issue template for project ideas"
```

---

### Task 9: Push and Enable GitHub Pages

The repo already exists at `https://github.com/GiggleLiu/HKUST-Got-Skills` (private) with remote `origin` configured.

- [ ] **Step 1: Push all commits**

```bash
git push origin main
```

- [ ] **Step 2: Enable GitHub Pages**

Enable manually: repo Settings → Pages → Source: "Deploy from a branch" → Branch: `main`, folder: `/ (root)`.

Or via CLI:

```bash
gh api repos/GiggleLiu/HKUST-Got-Skills/pages -X POST -f source='{"branch":"main","path":"/"}' 2>/dev/null || echo "Pages may already be enabled"
```

- [ ] **Step 3: Verify site is live**

```bash
curl -s -o /dev/null -w "%{http_code}" https://GiggleLiu.github.io/HKUST-Got-Skills/
```

Expected: `200`

Also check manually:
- All 5 pages render
- Navigation bar works and highlights active page
- Links to GitHub Issues work

---

### Task 10: Makefile for Local Development

**Files:**
- Create: `Makefile`

- [ ] **Step 1: Create `Makefile`**

```makefile
.PHONY: serve clean

serve: ## Serve the site locally with live reload
	bundle exec jekyll serve --livereload

install: ## Install Jekyll and dependencies
	gem install bundler
	bundle init
	echo 'gem "jekyll"' >> Gemfile
	echo 'gem "jekyll-theme-hacker"' >> Gemfile
	bundle install

clean: ## Clean generated site
	rm -rf _site .jekyll-cache

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
```

- [ ] **Step 2: Create `Gemfile`**

```ruby
source "https://rubygems.org"

gem "jekyll", "~> 4.3"
gem "jekyll-theme-hacker"
```

- [ ] **Step 3: Commit**

```bash
git add Makefile Gemfile
git commit -m "feat: add Makefile with serve target for local development"
```
