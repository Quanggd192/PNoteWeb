begin;

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

create index if not exists daily_habit_checks_user_date_idx
on public.daily_habit_checks(user_id, check_date);

drop trigger if exists daily_habit_checks_set_updated_at on public.daily_habit_checks;
create trigger daily_habit_checks_set_updated_at
before update on public.daily_habit_checks
for each row execute function public.set_updated_at();

alter table public.daily_habit_checks enable row level security;

drop policy if exists "Users can read their own daily habit checks" on public.daily_habit_checks;
create policy "Users can read their own daily habit checks"
on public.daily_habit_checks for select
using (auth.uid() = user_id);

drop policy if exists "Users can create their own daily habit checks" on public.daily_habit_checks;
create policy "Users can create their own daily habit checks"
on public.daily_habit_checks for insert
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own daily habit checks" on public.daily_habit_checks;
create policy "Users can update their own daily habit checks"
on public.daily_habit_checks for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own daily habit checks" on public.daily_habit_checks;
create policy "Users can delete their own daily habit checks"
on public.daily_habit_checks for delete
using (auth.uid() = user_id);

grant select, insert, update, delete on public.daily_habit_checks to authenticated;

commit;
