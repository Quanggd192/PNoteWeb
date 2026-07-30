begin;

create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  display_name text not null default '',
  avatar_url text,
  role text not null default 'user' check (role in ('user', 'admin')),
  status text not null default 'active' check (status in ('active', 'suspended')),
  preferences jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.workspaces (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  eyebrow text not null default 'Personal space',
  position integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.menus (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  type text not null check (type in (
    'note', 'journal', 'dreams', 'reflection', 'oneThing', 'routine',
    'study', 'brainstorm', 'capital', 'weeklySpend', 'business', 'investment'
  )),
  label text not null,
  position integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (workspace_id, type)
);

create table if not exists public.notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  workspace_id uuid references public.workspaces(id) on delete set null,
  menu_id uuid references public.menus(id) on delete set null,
  title text not null default 'Untitled',
  content text not null default '',
  note_font text not null default 'sans' check (note_font in ('sans', 'mono')),
  type text not null default 'note' check (type in (
    'note', 'journal', 'dreams', 'reflection', 'oneThing', 'routine',
    'study', 'brainstorm', 'capital', 'weeklySpend', 'business', 'investment'
  )),
  tags text[] not null default '{}',
  pinned boolean not null default false,
  archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.daily_habit_checks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  task_key text not null check (task_key in (
    'wake_before_6',
    'sleep_before_11',
    'screen_time_under_3h',
    'language_30m',
    'tech_30m',
    'personal_business_1h',
    'gym_session'
  )),
  check_date date not null,
  completed boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, task_key, check_date)
);


create or replace function public.validate_pnote_ownership()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if tg_table_name = 'menus' then
    if not exists (
      select 1 from public.workspaces
      where id = new.workspace_id and user_id = new.user_id
    ) then
      raise exception 'Menu workspace must belong to the same user';
    end if;
  elsif tg_table_name = 'notes' then
    if new.workspace_id is not null and not exists (
      select 1 from public.workspaces
      where id = new.workspace_id and user_id = new.user_id
    ) then
      raise exception 'Note workspace must belong to the same user';
    end if;
    if new.menu_id is not null and not exists (
      select 1 from public.menus
      where id = new.menu_id
        and user_id = new.user_id
        and (new.workspace_id is null or workspace_id = new.workspace_id)
    ) then
      raise exception 'Note menu must belong to the same user and workspace';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists menus_validate_ownership on public.menus;
create trigger menus_validate_ownership
before insert or update of user_id, workspace_id on public.menus
for each row execute function public.validate_pnote_ownership();

drop trigger if exists notes_validate_ownership on public.notes;
create trigger notes_validate_ownership
before insert or update of user_id, workspace_id, menu_id on public.notes
for each row execute function public.validate_pnote_ownership();

create index if not exists workspaces_user_position_idx on public.workspaces(user_id, position);
create index if not exists menus_user_workspace_position_idx on public.menus(user_id, workspace_id, position);
create index if not exists notes_user_updated_idx on public.notes(user_id, updated_at desc);
create index if not exists notes_user_type_idx on public.notes(user_id, type);
create index if not exists notes_workspace_idx on public.notes(workspace_id);
create index if not exists notes_menu_idx on public.notes(menu_id);
create index if not exists daily_habit_checks_user_date_idx on public.daily_habit_checks(user_id, check_date);

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at before update on public.profiles
for each row execute function public.set_updated_at();
drop trigger if exists workspaces_set_updated_at on public.workspaces;
create trigger workspaces_set_updated_at before update on public.workspaces
for each row execute function public.set_updated_at();
drop trigger if exists menus_set_updated_at on public.menus;
create trigger menus_set_updated_at before update on public.menus
for each row execute function public.set_updated_at();
drop trigger if exists notes_set_updated_at on public.notes;
create trigger notes_set_updated_at before update on public.notes
for each row execute function public.set_updated_at();
drop trigger if exists daily_habit_checks_set_updated_at on public.daily_habit_checks;
create trigger daily_habit_checks_set_updated_at before update on public.daily_habit_checks
for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'display_name', new.raw_user_meta_data ->> 'full_name', '')
  )
  on conflict (id) do update set email = excluded.email;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert or update of email on auth.users
for each row execute function public.handle_new_user();

insert into public.profiles (id, email, display_name)
select id, email, coalesce(raw_user_meta_data ->> 'display_name', raw_user_meta_data ->> 'full_name', '')
from auth.users
on conflict (id) do update set email = excluded.email;

alter table public.profiles enable row level security;
alter table public.workspaces enable row level security;
alter table public.menus enable row level security;
alter table public.notes enable row level security;
alter table public.daily_habit_checks enable row level security;

drop policy if exists "Users can read their own profile" on public.profiles;
create policy "Users can read their own profile" on public.profiles for select using (auth.uid() = id);
drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "Users can read their own workspaces" on public.workspaces;
create policy "Users can read their own workspaces" on public.workspaces for select using (auth.uid() = user_id);
drop policy if exists "Users can create their own workspaces" on public.workspaces;
create policy "Users can create their own workspaces" on public.workspaces for insert with check (auth.uid() = user_id);
drop policy if exists "Users can update their own workspaces" on public.workspaces;
create policy "Users can update their own workspaces" on public.workspaces for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete their own workspaces" on public.workspaces;
create policy "Users can delete their own workspaces" on public.workspaces for delete using (auth.uid() = user_id);

drop policy if exists "Users can read their own menus" on public.menus;
create policy "Users can read their own menus" on public.menus for select using (auth.uid() = user_id);
drop policy if exists "Users can create their own menus" on public.menus;
create policy "Users can create their own menus" on public.menus for insert with check (auth.uid() = user_id);
drop policy if exists "Users can update their own menus" on public.menus;
create policy "Users can update their own menus" on public.menus for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete their own menus" on public.menus;
create policy "Users can delete their own menus" on public.menus for delete using (auth.uid() = user_id);

drop policy if exists "Users can read their own notes" on public.notes;
create policy "Users can read their own notes" on public.notes for select using (auth.uid() = user_id);
drop policy if exists "Users can create their own notes" on public.notes;
create policy "Users can create their own notes" on public.notes for insert with check (auth.uid() = user_id);
drop policy if exists "Users can update their own notes" on public.notes;
create policy "Users can update their own notes" on public.notes for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete their own notes" on public.notes;
create policy "Users can delete their own notes" on public.notes for delete using (auth.uid() = user_id);

drop policy if exists "Users can read their own daily habit checks" on public.daily_habit_checks;
create policy "Users can read their own daily habit checks" on public.daily_habit_checks for select using (auth.uid() = user_id);
drop policy if exists "Users can create their own daily habit checks" on public.daily_habit_checks;
create policy "Users can create their own daily habit checks" on public.daily_habit_checks for insert with check (auth.uid() = user_id);
drop policy if exists "Users can update their own daily habit checks" on public.daily_habit_checks;
create policy "Users can update their own daily habit checks" on public.daily_habit_checks for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete their own daily habit checks" on public.daily_habit_checks;
create policy "Users can delete their own daily habit checks" on public.daily_habit_checks for delete using (auth.uid() = user_id);

grant usage on schema public to authenticated;
grant select on public.profiles to authenticated;
grant update (display_name, avatar_url, preferences) on public.profiles to authenticated;
grant select, insert, update, delete on public.workspaces to authenticated;
grant select, insert, update, delete on public.menus to authenticated;
grant select, insert, update, delete on public.notes to authenticated;
grant select, insert, update, delete on public.daily_habit_checks to authenticated;

create or replace function public.delete_workspace_keep_notes(target_workspace_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.workspaces
    where id = target_workspace_id and user_id = auth.uid()
  ) then
    raise exception 'Workspace not found or access denied';
  end if;

  if (select count(*) from public.workspaces where user_id = auth.uid()) <= 1 then
    raise exception 'PNote needs at least one workspace';
  end if;

  update public.notes
  set workspace_id = null, menu_id = null
  where workspace_id = target_workspace_id and user_id = auth.uid();

  delete from public.menus
  where workspace_id = target_workspace_id and user_id = auth.uid();

  delete from public.workspaces
  where id = target_workspace_id and user_id = auth.uid();
end;
$$;

revoke all on function public.delete_workspace_keep_notes(uuid) from public;
grant execute on function public.delete_workspace_keep_notes(uuid) to authenticated;

commit;
