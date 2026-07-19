# AGENTS.md

## Purpose

This directory contains the web version of PNote, built with Next.js,
React, TypeScript, and Supabase.

PNote is a calm private thinking space for:

- journaling
- self-reflection
- study notes
- brainstorming
- business ideas
- investment ideas
- weekly and monthly focus

## Product Direction

1. Preserve the calm, writing-first experience of the desktop app.
2. Keep the editor as the primary surface.
3. Optimize for fast note creation and reliable autosave.
4. Avoid productivity noise, gamification, and team-oriented features.
5. Treat Journal, Reflection, Business, Investment, and The One Thing as
   first-class workflows.
6. Keep the web and desktop information architecture aligned where practical.

## Technical Stack

- Next.js App Router
- React
- TypeScript
- Supabase Auth
- Supabase Postgres
- Supabase Row Level Security
- Plain CSS unless a different styling system is explicitly requested

Do not replace the stack without explicit user approval.

## Supabase Rules

1. All user-owned tables must include a `user_id` linked to `auth.users`.
2. Enable Row Level Security on every table containing private user data.
3. Add explicit select, insert, update, and delete policies using `auth.uid()`.
4. Never trust a client-provided user ID for authorization.
5. Never expose the Supabase service-role key to browser code.
6. Browser code may only use `NEXT_PUBLIC_SUPABASE_URL` and
   `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
7. Store schema changes as SQL migrations or documented schema files under
   `supabase/`.
8. Keep `.env.example` synchronized with required environment variables.

## Authentication Rules

1. Use Supabase Auth for the production web app.
2. Keep authentication flows minimal and calm.
3. Magic-link email authentication is the default unless another method is
   explicitly requested.
4. Do not render or query private notes before authentication is established.
5. Sign-out must clear user-specific UI state from memory.

## Data and Autosave Rules

1. Supabase is the source of truth for authenticated user notes.
2. Local storage may be used for themes, workspace presentation preferences,
   and explicitly labeled preview mode only.
3. Debounce text autosave to avoid a database write for every keystroke.
4. Show clear `saving`, `saved`, and `error` states.
5. Do not silently discard pending edits during navigation.
6. Preserve `created_at`; update `updated_at` after meaningful changes.
7. Deleting a workspace or menu must not delete its notes unless the user
   explicitly confirms that separate destructive action.

## Workspace and Menu Rules

1. Workspaces and menus must remain user-configurable.
2. Users may add, rename, and remove workspace/menu entries.
3. Keep at least one usable workspace and one menu in each workspace.
4. Renaming a menu changes its display label, not the underlying note type.
5. Removing a menu hides that view without deleting notes.
6. New workspace/menu functionality must remain compatible with existing notes.

## The One Thing Rules

1. The One Thing is a first-class note type.
2. Create no more than one automatic entry for a given Sunday.
3. Use a stable week key to prevent duplicates.
4. Group entries by month in the list view.
5. New entries must include the weekly/monthly focus question template.
6. Manual entry creation remains available.

## UX Rules

1. Preserve the three-area desktop structure when space allows:
   sidebar, note list, and editor.
2. Responsive layouts must remain usable on tablet and mobile.
3. New note creation should be one click away.
4. Search must cover title, content, and tags.
5. Destructive actions require clear confirmation.
6. Use descriptive labels or recognizable icons with accessible titles.
7. Do not use ambiguous single-letter controls.
8. Maintain comfortable typography, whitespace, and contrast across themes.

## Code Quality Rules

1. Prefer small, focused components and utilities.
2. Keep domain types explicit; avoid `any`.
3. Use ASCII in source files by default.
4. Keep dependencies minimal and justified.
5. Do not duplicate Supabase client construction across components.
6. Handle database and authentication errors explicitly.
7. Do not commit credentials, generated secrets, or `.env.local`.

## Validation

Before handing off a meaningful change:

1. Run `npm run build`.
2. Fix TypeScript and Next.js build errors.
3. Verify the affected flow in the running web app when practical.
4. Test both configured Supabase mode and local preview behavior when the
   change affects data access.
5. Confirm that RLS or schema changes are included under `supabase/`.

## Important Files

- `src/components/PNoteApp.tsx`: primary web application UI and interactions
- `src/lib/types.ts`: note, workspace, menu, label, and template definitions
- `src/lib/supabase/client.ts`: browser Supabase client setup
- `src/app/globals.css`: shared visual system and responsive layout
- `supabase/schema.sql`: database schema and Row Level Security policies
- `.env.example`: required public Supabase environment variables
- `README.md`: local setup and Supabase connection instructions

