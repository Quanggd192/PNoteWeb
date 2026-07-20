# PNote Web

Next.js + Supabase version of PNote.

## Run locally

```bash
cp .env.example .env.local
npm install
npm run dev
```

Without Supabase environment variables, the app runs in local preview mode and stores preview notes in the browser.

## Connect Supabase Cloud

1. Create a Supabase project.
2. Open the SQL editor and run `supabase/schema.sql`.
3. Copy `.env.example` to `.env.local` and set the project URL and anon key.
4. In Supabase Authentication, enable Email and add the local/production URLs to Redirect URLs.
5. Restart `npm run dev`.

The SQL schema enables row-level security. Every read and write is restricted to the signed-in user.

## Data model

- `profiles`: one profile for each Supabase Auth user.
- `workspaces`: a user owns many workspaces.
- `menus`: a user owns many menus, and each menu belongs to one workspace.
- `notes`: a user owns many notes; each note can reference one workspace and one menu.

Deleting a menu or workspace keeps its notes. The corresponding relationship on
the note is set to `null`. Deleting an Auth user cascades through their profile,
workspaces, menus, and notes.

The first authenticated app session automatically creates the default PNote
workspaces and menus when that user has none.

## Generate the desktop migration query

Create the target user in Supabase Auth first. The migration targets
`quanggd192@gmail.com` and never stores or handles that user's password.

From the `web` directory, run:

```bash
npm run generate:migration
```

Enter the desktop vault passcode in the local Terminal prompt. The passcode is
used only in memory to decrypt the local vault. The command then replaces
`supabase/migrate_desktop_data.sql` with an idempotent query containing the
desktop notes. Run that generated SQL in Supabase SQL Editor.

Supabase Auth stores password verifiers as one-way hashes. Never add a password
column to `public.profiles` or another application table. Administrative
password resets must be performed through Supabase Auth, never through a public
application table or browser code.

## Validate

```bash
npm run build
```
