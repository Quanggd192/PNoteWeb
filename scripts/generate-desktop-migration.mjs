import { createDecipheriv, createHash, pbkdf2Sync, timingSafeEqual } from "node:crypto";
import { DatabaseSync } from "node:sqlite";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import os from "node:os";
import path from "node:path";

const targetEmail = "quanggd192@gmail.com";
const dataRoot = path.join(os.homedir(), "Library", "Application Support", "pnote-individual", "pnote");
const databasePath = path.join(dataRoot, "vault.db");
const metaPath = path.join(dataRoot, "vault-meta.json");
const outputPath = path.resolve("supabase", "migrate_desktop_data.sql");

const readSecret = async (prompt) => {
  if (!process.stdin.isTTY) throw new Error("Run this command in an interactive Terminal.");
  process.stdout.write(prompt);
  process.stdin.setRawMode(true);
  process.stdin.resume();
  process.stdin.setEncoding("utf8");
  let value = "";
  let done = false;
  for await (const chunk of process.stdin) {
    for (const char of chunk) {
      if (char === "\r" || char === "\n") { done = true; break; }
      if (char === "\u0003") process.exit(130);
      if (char === "\u007f") value = value.slice(0, -1);
      else value += char;
    }
    if (done) break;
  }
  process.stdin.setRawMode(false);
  process.stdin.pause();
  process.stdout.write("\n");
  return value;
};

const decode = (value) => Buffer.from(value, "base64");
const deriveKey = (passcode, salt) => pbkdf2Sync(passcode, salt, 210_000, 32, "sha256");

const decryptPayload = (payload, key) => {
  const encrypted = JSON.parse(payload);
  const decipher = createDecipheriv("aes-256-gcm", key, decode(encrypted.iv));
  decipher.setAuthTag(decode(encrypted.tag));
  return JSON.parse(Buffer.concat([
    decipher.update(decode(encrypted.ciphertext)),
    decipher.final()
  ]).toString("utf8"));
};

const sqlText = (value) => value == null ? "null" : `'${String(value).replaceAll("'", "''")}'`;
const sqlJson = (value) => `${sqlText(JSON.stringify(value))}::jsonb`;
const stableUuid = (value) => {
  const hex = createHash("md5").update(`pnote-desktop:${value}`).digest("hex");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-4${hex.slice(13, 16)}-a${hex.slice(17, 20)}-${hex.slice(20, 32)}`;
};

if (!existsSync(databasePath) || !existsSync(metaPath)) throw new Error("PNote desktop vault was not found.");
const passcode = await readSecret("Desktop vault passcode: ");
const meta = JSON.parse(readFileSync(metaPath, "utf8"));
const key = deriveKey(passcode, decode(meta.salt));
const verifier = decode(meta.verifier);
if (verifier.length !== key.length || !timingSafeEqual(verifier, key)) throw new Error("Incorrect vault passcode.");

const database = new DatabaseSync(databasePath, { readOnly: true });
const rows = database.prepare("select id, owner_user_id, created_at, updated_at, payload from notes order by created_at").all();
const notes = rows.map((row) => ({ ...decryptPayload(row.payload, key), id: row.id, createdAt: row.created_at, updatedAt: row.updated_at }));
database.close();

const workspaceForType = (type) => type === "capital" || type === "weeklySpend" ? "Cash Flow" : type === "business" || type === "investment" ? "Business & Investment" : "Reflect";
const validTypes = new Set(["note", "journal", "dreams", "reflection", "oneThing", "routine", "study", "brainstorm", "capital", "weeklySpend", "business", "investment"]);

const inserts = notes.map((note) => {
  const type = validTypes.has(note.type) ? note.type : "note";
  const workspaceTitle = workspaceForType(type);
  return `insert into public.notes (id, user_id, workspace_id, menu_id, title, content, note_font, type, tags, pinned, archived, created_at, updated_at)\nselect ${sqlText(stableUuid(note.id))}::uuid, target_user_id, w.id, m.id, ${sqlText(note.title || "Untitled")}, ${sqlText(note.content || "")}, ${sqlText(note.noteFont === "mono" ? "mono" : "sans")}, ${sqlText(type)}, array(select jsonb_array_elements_text(${sqlJson(note.tags || [])})), ${note.pinned ? "true" : "false"}, ${note.archived ? "true" : "false"}, ${sqlText(note.createdAt)}::timestamptz, ${sqlText(note.updatedAt)}::timestamptz\nfrom public.workspaces w\njoin public.menus m on m.workspace_id = w.id and m.type = ${sqlText(type)}\nwhere w.user_id = target_user_id and w.title = ${sqlText(workspaceTitle)}\non conflict (id) do nothing;`;
}).join("\n\n");

const sql = `-- Generated from the encrypted PNote desktop vault.\n-- Target Supabase Auth user: ${targetEmail}\n-- Notes: ${notes.length}\n\nbegin;\n\ndo $$\ndeclare\n  target_user_id uuid;\nbegin\n  select id into target_user_id from auth.users where lower(email) = lower(${sqlText(targetEmail)}) limit 1;\n  if target_user_id is null then\n    raise exception 'Create the Supabase Auth user ${targetEmail} before running this migration';\n  end if;\n\n  insert into public.profiles (id, email, display_name)\n  values (target_user_id, ${sqlText(targetEmail)}, 'Quanggd192')\n  on conflict (id) do update set email = excluded.email;\n\n  insert into public.workspaces (user_id, title, eyebrow, position) values\n    (target_user_id, 'Reflect', 'Reset inward', 0),\n    (target_user_id, 'Cash Flow', 'Track movement', 1),\n    (target_user_id, 'Business & Investment', 'Sharpen conviction', 2)\n  on conflict do nothing;\n\n  insert into public.menus (user_id, workspace_id, type, label, position)\n  select target_user_id, w.id, menu.type, menu.label, menu.position\n  from public.workspaces w\n  cross join lateral (values\n    ('journal', 'Journal', 0), ('dreams', 'Dreams', 1), ('reflection', 'Weekly Reflect', 2),\n    ('oneThing', 'The One Thing', 3), ('routine', 'Routine', 4), ('study', 'Study', 5), ('brainstorm', 'Brainstorm', 6)\n  ) as menu(type, label, position)\n  where w.user_id = target_user_id and w.title = 'Reflect'\n  on conflict (workspace_id, type) do nothing;\n\n  insert into public.menus (user_id, workspace_id, type, label, position)\n  select target_user_id, w.id, menu.type, menu.label, menu.position\n  from public.workspaces w\n  cross join lateral (values ('capital', 'Capital Tracker', 0), ('weeklySpend', 'Weekly Spend', 1)) as menu(type, label, position)\n  where w.user_id = target_user_id and w.title = 'Cash Flow'\n  on conflict (workspace_id, type) do nothing;\n\n  insert into public.menus (user_id, workspace_id, type, label, position)\n  select target_user_id, w.id, menu.type, menu.label, menu.position\n  from public.workspaces w\n  cross join lateral (values ('business', 'Business', 0), ('investment', 'Investment', 1)) as menu(type, label, position)\n  where w.user_id = target_user_id and w.title = 'Business & Investment'\n  on conflict (workspace_id, type) do nothing;\n\n${inserts.split("\n").map((line) => `  ${line}`).join("\n")}\nend $$;\n\ncommit;\n`;

const finalSql = sql
  .replace(
    "  insert into public.workspaces (user_id, title, eyebrow, position) values\n    (target_user_id, 'Reflect', 'Reset inward', 0),\n    (target_user_id, 'Cash Flow', 'Track movement', 1),\n    (target_user_id, 'Business & Investment', 'Sharpen conviction', 2)\n  on conflict do nothing;",
    "  insert into public.workspaces (user_id, title, eyebrow, position)\n  select target_user_id, seed.title, seed.eyebrow, seed.position\n  from (values\n    ('Reflect', 'Reset inward', 0),\n    ('Cash Flow', 'Track movement', 1),\n    ('Business & Investment', 'Sharpen conviction', 2)\n  ) as seed(title, eyebrow, position)\n  where not exists (\n    select 1 from public.workspaces existing\n    where existing.user_id = target_user_id and existing.title = seed.title\n  );"
  )
  .replace(
    "('oneThing', 'The One Thing', 3), ('routine', 'Routine', 4), ('study', 'Study', 5), ('brainstorm', 'Brainstorm', 6)",
    "('oneThing', 'The One Thing', 3), ('routine', 'Routine', 4), ('study', 'Study', 5), ('brainstorm', 'Brainstorm', 6),\n    ('note', 'Notes', 7)"
  );

writeFileSync(outputPath, finalSql, "utf8");
console.log(`Created ${outputPath} with ${notes.length} notes.`);
