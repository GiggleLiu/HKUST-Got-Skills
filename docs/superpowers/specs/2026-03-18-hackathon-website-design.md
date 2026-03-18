# HKUST-Got-Skills Hackathon Website — Design Spec

## Overview

A multi-page Jekyll website hosted on GitHub Pages for an invite-only cross-campus hackathon at HKUST(GZ) and HKUST-CWB. Participants build AI coding skills (for Claude Code, Cursor, Codex CLI, OpenCode, etc.) to automate and accelerate scientific discovery.

**Repo**: `GiggleLiu/HKUST-Got-Skills` on GitHub
**Organizers**: Jin-Guo Liu and Xi Dai
**Audience**: Invited graduate students and postdocs at HKUST(GZ) and HKUST-CWB
**Contact**: jinguoliu@hkust-gz.edu.cn

## Tech Stack

- **Static site generator**: Jekyll
- **Hosting**: GitHub Pages (auto-builds on push)
- **Theme**: Hacker (`pages-themes/hacker`)
- **Idea collection**: GitHub Issues with a structured issue template
- **Language**: English

## Site Structure

```
HKUST-Got-Skills/
├── _config.yml              # Jekyll config: title, theme, navigation
├── index.md                 # Home page
├── program.md               # Schedule and format
├── resources.md             # Tools, guides, links
├── organizers.md            # Organizer bios
├── ideas.md                 # How to submit project ideas
└── .github/
    └── ISSUE_TEMPLATE/
        └── project-idea.md  # Structured template for idea submissions
```

Navigation: **Home | Program | Resources | Organizers | Ideas**

**Note**: The Hacker theme does not include built-in multi-page navigation. A custom `_layouts/default.html` will override the theme's default layout to add a navigation bar. Jekyll site files live at the repo root (GitHub Pages default source).

## Page Specifications

### 1. Home (index.md)

- **Hero**: "HKUST-Got-Skills" — Design a skill to automate/accelerate scientific discovery
- **What**: Cross-campus hackathon (HKUST-GZ x HKUST-CWB). Teams build AI coding skills for scientific workflows.
- **When / Where**: TBD (placeholders)
- **Format summary**: Tutorials → Hacking → Peer showcase with informal voting
- **Invite-only note**: This is an invite-only event. Interested in joining? Contact jinguoliu@hkust-gz.edu.cn
- **Quick nav links** to other pages

### 2. Program (program.md)

**Part 1 — Tutorials**
- Intro to AI coding tools (Claude Code, Cursor, Codex CLI, OpenCode)
- What are "skills" and how to write one
- Live demo: building a skill for a scientific workflow
- Speakers: TBD

**Part 2 — Hackathon**
- Team formation
- Hacking time
- Peer showcase and informal voting

Schedule: table with time slots, all TBD.

### 3. Resources (resources.md)

- **Setup Guide**: Link to existing AI coding tool installation guide
- **Hands-on Examples**: Link to existing examples (brainstorming, report generation, library building, benchmarking, paper writing)
- **Blog Posts**: Links to Vibe Coding Done Right, Git Workflow, Sustainable Automation
- **Tool Links**: Official sites for Claude Code, Cursor, Codex CLI, OpenCode
- Hackathon-specific content (e.g., "How to write your first skill") to be added later

### 4. Organizers (organizers.md)

- **Jin-Guo Liu** — Assistant Professor, HKUST(GZ). Research in scientific computing and neutral atom quantum computing. Developer of open-source frameworks including Yao (quantum simulator). GitHub: GiggleLiu
- **Xi Dai** — Bio TBD

### 5. Ideas (ideas.md)

- Explanation: participants submit project ideas as GitHub Issues before the hackathon
- Link to the issue tracker (filtered by "project-idea" label)
- Instructions on how to submit
- Example ideas to inspire participants

### GitHub Issue Template (.github/ISSUE_TEMPLATE/project-idea.md)

Fields:
- **Project title**
- **Description**: What does this skill do?
- **Target tool**: Which AI coding tool? (Claude Code / Cursor / Codex CLI / OpenCode / Any)
- **Scientific domain**: What area of science does this accelerate?
- **Team**: Looking for teammates? What skills are needed?

## Design Decisions

1. **Invite-only**: No public registration form. Invitations via email/WeChat. Contact email on home page for interested parties.
2. **GitHub Issues for ideas**: Zero-maintenance, supports discussion, fits the developer-oriented audience. Structured via issue template.
3. **Hacker theme**: Dark terminal aesthetic matches the hackathon spirit.
4. **Multi-page layout**: Separate pages for each section; scales well as content is added (announcements, speaker bios, etc.).
5. **Existing resources**: Link to existing setup guide and blog posts rather than duplicating content. New hackathon-specific materials added later.
6. **TBD placeholders**: Time, location, speakers, and schedule are TBD — site structure accommodates easy updates.
