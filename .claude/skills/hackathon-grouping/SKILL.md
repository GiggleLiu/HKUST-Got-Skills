---
name: hackathon-grouping
description: Use when triaging, grouping, or organizing GitHub issues by topic similarity — e.g., "group the issues", "triage issues", "organize issues into topics", "what issues are related", or any request to classify and consolidate open issues for easier collaboration. Also use when the user wants to file a summary issue that categorizes existing issues into named groups.
---

# Hackathon Issue Grouping

Group open GitHub issues by topic similarity and file a summary issue with the named groups. This helps teams see which issues cluster together, making collaboration and prioritization easier.

## Workflow

This is a **conversational** skill with three phases. Each phase requires user input before moving on — never skip ahead.

### Phase 1: Fetch and present issues

Fetch all open issues from the current repo:

```bash
gh issue list --state open --limit 200 --json number,title,body,labels,assignees
```

Present them as a numbered table so the user can see what's there:

| # | Title | Labels |
|---|-------|--------|

If there are more than ~30 issues, also show a count and ask the user if they want to filter (e.g., by label or milestone) before proceeding.

### Phase 2: Classify into groups

Analyze the issues by title, body, and labels. Cluster them into **groups of 1-4 issues** based on topic similarity. Each group should have:

- A short, descriptive **group name** (2-5 words)
- The issue numbers and titles that belong to it

The goal is topical similarity — issues that a single person or small team could tackle together because they touch the same area. Prefer meaningful groupings over forcing every issue into a cluster; a group of 1 is fine for issues that don't fit anywhere else.

Present the groups clearly:

```
**Group: <name>**
- #12 — Title of issue 12
- #34 — Title of issue 34

**Group: <name>**
- #5 — Title of issue 5
```

Then **ask for feedback**:
- Are any issues miscategorized?
- Should any groups be merged or split?
- Are the group names clear?

Incorporate feedback and re-present. Repeat until the user is satisfied — typically 1-2 rounds.

### Phase 3: File the summary issue

Once the user confirms the grouping, create a single GitHub issue summarizing all groups. Use this structure:

```markdown
Title: Issue Grouping: <short context, e.g., "Sprint 4" or "Hackathon Topics">

Body:
# Issue Groups

Grouped by topic similarity for easier collaboration.

## <Group Name>
- #12 — Title
- #34 — Title

## <Group Name>
- #5 — Title

---
*Auto-generated grouping of <N> open issues into <M> groups.*
```

File with:
```bash
gh issue create --title "..." --body "..."
```

Show the user the created issue URL when done.

## Notes

- Use the current repo (detected from git remote). Do not ask the user which repo.
- If `gh` is not authenticated or the repo has no issues, say so and stop.
- The grouping is by semantic similarity of the issue content, not by labels alone — though labels are a useful signal.
- Keep group names concise and action-oriented when possible (e.g., "Auth & Session Handling" rather than "Issues Related to Authentication").
