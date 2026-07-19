begin;

alter table public.notes
add column if not exists note_font text not null default 'sans';

alter table public.notes
drop constraint if exists notes_note_font_check;

alter table public.notes
add constraint notes_note_font_check check (note_font in ('sans', 'mono'));

commit;
