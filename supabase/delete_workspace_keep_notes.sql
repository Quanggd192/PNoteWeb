begin;

create or replace function public.delete_workspace_keep_notes(target_workspace_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if not exists (
    select 1
    from public.workspaces
    where id = target_workspace_id
      and user_id = auth.uid()
  ) then
    raise exception 'Workspace not found or access denied';
  end if;

  if (
    select count(*)
    from public.workspaces
    where user_id = auth.uid()
  ) <= 1 then
    raise exception 'PNote needs at least one workspace';
  end if;

  update public.notes
  set workspace_id = null,
      menu_id = null
  where workspace_id = target_workspace_id
    and user_id = auth.uid();

  delete from public.menus
  where workspace_id = target_workspace_id
    and user_id = auth.uid();

  delete from public.workspaces
  where id = target_workspace_id
    and user_id = auth.uid();
end;
$$;

revoke all on function public.delete_workspace_keep_notes(uuid) from public;
grant execute on function public.delete_workspace_keep_notes(uuid) to authenticated;

commit;
