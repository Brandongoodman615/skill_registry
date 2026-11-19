# Skill Registry

A Rails app for tracking and managing AI skills (slash commands) across a repo or organization. As skill files multiply, it gets hard to know what exists, what's redundant, and what's stepping on something else. This app gives you a central view.

## Goals

- **Visibility** — see all skills in one place, filterable by category and status
- **Conflict detection** — surface skills that share trigger keywords and may cause unpredictable behavior
- **AI analysis** — eventually, run scheduled jobs that use Claude to detect *semantic* conflicts beyond keyword overlap (stubbed and ready to wire up)

## What it does today

- Full CRUD for skills (name, description, trigger keywords, category, status, file path)
- Keyword-based conflict detection — computed live, no background jobs needed
- Dashboard with a conflict banner (red if conflicts exist, green if all clear)
- Filter bar by category (git, pr, deploy, test, infra) and status (active, draft, deprecated)
- Skill cards with warning badges when conflicts are detected
- Dedicated `/conflicts` page listing all conflicting pairs with shared keywords highlighted
- Skill detail page showing which other skills it conflicts with and what keywords they share
- 10 seed skills with intentional overlaps to demonstrate conflict detection on first load
- `SkillAnalysisJob` stubbed for future AI-powered semantic analysis (adds `ai_notes` and `last_analyzed_at` to each skill)
- 26 model + request specs

## Stack

- Ruby on Rails 8
- SQLite
- Bootstrap 5 (CDN)
- RSpec

## Getting started

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Then open `http://localhost:3000`.

## Running tests

```bash
bundle exec rspec spec/models spec/requests
```
