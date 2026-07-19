"use client";

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { Archive, LogOut, Menu, Moon, Pencil, Pin, Plus, Search, Settings, Sun, Trash2, X } from "lucide-react";
import type { User } from "@supabase/supabase-js";
import { createSupabaseBrowserClient, hasSupabaseConfig } from "@/lib/supabase/client";
import { defaultWorkspaces, labels, templates, type Note, type NoteType, type UserProfile, type WorkspaceConfig } from "@/lib/types";

const workspaceKey = "pnote-web-workspaces-v1";
const themeKey = "pnote-web-theme";
const demoNotesKey = "pnote-web-demo-notes";

type DialogState = {
  kind: "input" | "confirm" | "select" | "message";
  title: string;
  message?: string;
  value?: string;
  options?: Array<{ value: string; label: string }>;
  confirmLabel?: string;
  danger?: boolean;
};

const id = () => crypto.randomUUID();
const now = () => new Date().toISOString();
const dateLabel = (value: string) => new Intl.DateTimeFormat("en", { month: "short", day: "numeric", hour: "2-digit", minute: "2-digit" }).format(new Date(value));
const weekKey = (date = new Date()) => `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;

const newNote = (type: NoteType, userId: string, workspaceId: string | null, menuId: string | null): Note => {
  const date = new Date();
  const label = new Intl.DateTimeFormat("en", { month: "short", day: "numeric", year: "numeric" }).format(date);
  const title = type === "oneThing" ? `The One Thing — Week of ${label}` : type === "journal" ? `Journal — ${label}` : `${labels[type]} — ${label}`;
  return { id: id(), user_id: userId, workspace_id: workspaceId, menu_id: menuId, title, content: templates[type] ?? "", note_font: "sans", type, tags: type === "oneThing" ? ["the-one-thing", `week:${weekKey(date)}`] : [], pinned: false, archived: false, created_at: now(), updated_at: now() };
};

export function PNoteApp() {
  const supabase = useMemo(() => createSupabaseBrowserClient(), []);
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [authReady, setAuthReady] = useState(false);
  const [email, setEmail] = useState("");
  const [authMessage, setAuthMessage] = useState("");
  const [workspaces, setWorkspaces] = useState<WorkspaceConfig[]>(defaultWorkspaces);
  const [workspaceId, setWorkspaceId] = useState("reflect");
  const [view, setView] = useState<NoteType>("journal");
  const [showArchived, setShowArchived] = useState(false);
  const [notes, setNotes] = useState<Note[]>([]);
  const [notesReady, setNotesReady] = useState(!hasSupabaseConfig);
  const [workspacesReady, setWorkspacesReady] = useState(!hasSupabaseConfig);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [query, setQuery] = useState("");
  const [theme, setTheme] = useState("midnight");
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [saveState, setSaveState] = useState<"saved" | "saving" | "error">("saved");
  const [dialog, setDialog] = useState<DialogState | null>(null);
  const saveTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const dialogResolver = useRef<((value: string | boolean | null) => void) | null>(null);

  const openDialog = (next: DialogState) => new Promise<string | boolean | null>((resolve) => {
    dialogResolver.current = resolve;
    setDialog(next);
  });
  const closeDialog = (value: string | boolean | null) => {
    dialogResolver.current?.(value);
    dialogResolver.current = null;
    setDialog(null);
  };

  useEffect(() => {
    const storedTheme = localStorage.getItem(themeKey);
    const storedWorkspaces = localStorage.getItem(workspaceKey);
    if (storedTheme) setTheme(storedTheme);
    if (storedWorkspaces) try { setWorkspaces(JSON.parse(storedWorkspaces)); } catch {}
    if (!supabase) { setAuthReady(true); return; }
    void supabase.auth.getUser().then(({ data }) => { setUser(data.user); setAuthReady(true); });
    const { data } = supabase.auth.onAuthStateChange((_event, session) => setUser(session?.user ?? null));
    return () => data.subscription.unsubscribe();
  }, [supabase]);

  useEffect(() => { document.documentElement.dataset.theme = theme; localStorage.setItem(themeKey, theme); }, [theme]);
  useEffect(() => { if (!supabase) localStorage.setItem(workspaceKey, JSON.stringify(workspaces)); }, [supabase, workspaces]);
  useEffect(() => {
    if (supabase) {
      setNotesReady(false);
      setWorkspacesReady(false);
    }
  }, [supabase, user?.id]);

  const loadWorkspaces = useCallback(async () => {
    if (!supabase || !user) return;
    const { data, error } = await supabase
      .from("workspaces")
      .select("id,user_id,title,eyebrow,position,menus(id,type,label,position)")
      .order("position", { ascending: true });
    if (error) { setWorkspacesReady(false); return; }

    let rows = data ?? [];
    if (rows.length === 0) {
      const seeded: typeof rows = [];
      for (const [workspacePosition, definition] of defaultWorkspaces.entries()) {
        const workspaceRow = {
          id: id(), user_id: user.id, title: definition.title,
          eyebrow: definition.eyebrow, position: workspacePosition
        };
        const { error: workspaceError } = await supabase.from("workspaces").insert(workspaceRow);
        if (workspaceError) continue;
        const menuRows = definition.views.map((type, position) => ({
          id: id(), user_id: user.id, workspace_id: workspaceRow.id,
          type, label: labels[type], position
        }));
        await supabase.from("menus").insert(menuRows);
        seeded.push({ ...workspaceRow, menus: menuRows });
      }
      rows = seeded;
    }

    const next = rows.map((row) => {
      const menus = [...(row.menus ?? [])].sort((a, b) => a.position - b.position);
      return {
        id: row.id,
        user_id: row.user_id,
        title: row.title,
        eyebrow: row.eyebrow,
        position: row.position,
        views: menus.map((menu) => menu.type as NoteType),
        menuLabels: Object.fromEntries(menus.map((menu) => [menu.type, menu.label])),
        menuIds: Object.fromEntries(menus.map((menu) => [menu.type, menu.id]))
      } satisfies WorkspaceConfig;
    });
    setWorkspaces(next);
    setWorkspacesReady(true);
    if (!next.some((item) => item.id === workspaceId)) {
      setWorkspaceId(next[0].id);
      setView(next[0].views[0]);
    }
  }, [supabase, user, workspaceId]);

  useEffect(() => { void loadWorkspaces(); }, [loadWorkspaces]);

  useEffect(() => {
    if (!supabase || !user) { setProfile(null); return; }
    void supabase.from("profiles").select("*").eq("id", user.id).single()
      .then(({ data }) => setProfile(data as UserProfile | null));
  }, [supabase, user]);

  const loadNotes = useCallback(async () => {
    if (!supabase) {
      const stored = localStorage.getItem(demoNotesKey);
      setNotes(stored ? JSON.parse(stored) : []);
      setNotesReady(true);
      return;
    }
    if (!user) { setNotes([]); setNotesReady(false); return; }
    const { data, error } = await supabase.from("notes").select("*").order("updated_at", { ascending: false });
    if (!error) {
      setNotes((data ?? []).map((note) => ({ ...note, note_font: note.note_font === "mono" ? "mono" : "sans" })) as Note[]);
      setNotesReady(true);
    }
  }, [supabase, user]);
  useEffect(() => { void loadNotes(); }, [loadNotes]);

  useEffect(() => {
    if (!authReady || !notesReady || !workspacesReady || (supabase && !user)) return;
    const date = new Date();
    if (date.getDay() !== 0 || notes.some((note) => note.type === "oneThing" && note.tags.includes(`week:${weekKey(date)}`))) return;
    const oneThingWorkspace = workspaces.find((item) => item.views.includes("oneThing"));
    const note = newNote("oneThing", user?.id ?? "demo", oneThingWorkspace?.id ?? null, oneThingWorkspace?.menuIds?.oneThing ?? null);
    setNotes((current) => [note, ...current]);
    if (supabase) void supabase.from("notes").insert(note);
    else localStorage.setItem(demoNotesKey, JSON.stringify([note, ...notes]));
  }, [authReady, notes, notesReady, supabase, user, workspaces, workspacesReady]);

  const workspace = workspaces.find((item) => item.id === workspaceId) ?? workspaces[0];
  const visible = useMemo(() => notes.filter((note) => {
    if (showArchived) {
      return note.archived && `${note.title} ${note.content} ${note.tags.join(" ")}`.toLowerCase().includes(query.toLowerCase());
    }
    const activeMenuId = workspace?.menuIds?.[view];
    const belongsToMenu = activeMenuId ? note.menu_id === activeMenuId : note.type === view;
    return !note.archived && belongsToMenu && `${note.title} ${note.content} ${note.tags.join(" ")}`.toLowerCase().includes(query.toLowerCase());
  }).sort((a, b) => b.updated_at.localeCompare(a.updated_at)), [notes, query, showArchived, view, workspace]);
  const selected = visible.find((note) => note.id === selectedId) ?? visible[0] ?? null;

  const persist = useCallback(async (note: Note) => {
    setSaveState("saving");
    if (!supabase) { localStorage.setItem(demoNotesKey, JSON.stringify(notes.map((item) => item.id === note.id ? note : item))); setSaveState("saved"); return; }
    const { error } = await supabase.from("notes").upsert(note);
    setSaveState(error ? "error" : "saved");
  }, [notes, supabase]);

  const updateSelected = <K extends keyof Note>(key: K, value: Note[K]) => {
    if (!selected) return;
    const next = { ...selected, [key]: value, updated_at: now() };
    setNotes((current) => current.map((note) => note.id === next.id ? next : note));
    if (saveTimer.current) clearTimeout(saveTimer.current);
    saveTimer.current = setTimeout(() => void persist(next), 450);
  };

  const create = async () => {
    const note = newNote(view, user?.id ?? "demo", workspace.id, workspace.menuIds?.[view] ?? null);
    setNotes((current) => [note, ...current]); setSelectedId(note.id);
    if (supabase) await supabase.from("notes").insert(note);
    else localStorage.setItem(demoNotesKey, JSON.stringify([note, ...notes]));
  };

  const restoreSelected = () => {
    if (!selected) return;
    updateSelected("archived", false);
    setSelectedId(null);
  };

  const remove = async () => {
    if (!selected || !(await openDialog({ kind: "confirm", title: "Delete note?", message: `“${selected.title}” will be permanently deleted.`, confirmLabel: "Delete", danger: true }))) return;
    setNotes((current) => current.filter((note) => note.id !== selected.id)); setSelectedId(null);
    if (supabase) await supabase.from("notes").delete().eq("id", selected.id);
    else localStorage.setItem(demoNotesKey, JSON.stringify(notes.filter((note) => note.id !== selected.id)));
  };

  const signIn = async () => {
    if (!supabase || !email.trim()) return;
    const { error } = await supabase.auth.signInWithOtp({ email, options: { emailRedirectTo: window.location.origin } });
    setAuthMessage(error ? error.message : "Check your email for the secure sign-in link.");
  };

  const editProfile = async () => {
    if (!user || !supabase) return;
    const result = await openDialog({ kind: "input", title: "Profile settings", message: "Display name", value: profile?.display_name ?? "", confirmLabel: "Save" });
    if (typeof result !== "string") return;
    const displayName = result.trim();
    const { data, error } = await supabase.from("profiles").update({ display_name: displayName }).eq("id", user.id).select("*").single();
    if (!error) setProfile(data as UserProfile);
  };

  const addWorkspace = async () => {
    const result = await openDialog({ kind: "input", title: "New workspace", message: "Workspace name", confirmLabel: "Create" });
    const title = typeof result === "string" ? result.trim() : ""; if (!title) return;
    const workspaceRow = { id: id(), user_id: user?.id, title, eyebrow: "Personal space", position: workspaces.length };
    const menuId = id();
    if (supabase && user) {
      const { error } = await supabase.from("workspaces").insert({ ...workspaceRow, user_id: user.id });
      if (error) return;
      await supabase.from("menus").insert({ id: menuId, user_id: user.id, workspace_id: workspaceRow.id, type: "note", label: labels.note, position: 0 });
    }
    const item: WorkspaceConfig = { ...workspaceRow, user_id: user?.id, views: ["note"], menuLabels: { note: labels.note }, menuIds: { note: menuId } };
    setWorkspaces([...workspaces, item]); setWorkspaceId(item.id); setView("note");
  };
  const renameWorkspace = async () => {
    const result = await openDialog({ kind: "input", title: "Rename workspace", message: "Workspace name", value: workspace.title, confirmLabel: "Save" });
    const title = typeof result === "string" ? result.trim() : ""; if (!title) return;
    if (supabase) { const { error } = await supabase.from("workspaces").update({ title }).eq("id", workspace.id); if (error) return; }
    setWorkspaces(workspaces.map((item) => item.id === workspace.id ? { ...item, title } : item));
  };
  const deleteWorkspace = async () => {
    if (workspaces.length < 2) {
      await openDialog({ kind: "message", title: "Workspace cannot be deleted", message: "PNote needs at least one workspace.", confirmLabel: "OK" });
      return;
    }
    const remainingWorkspaces = workspaces.filter((item) => item.id !== workspace.id);
    const fallbackWorkspace = remainingWorkspaces[0];
    const fallbackType = fallbackWorkspace.views[0];
    const fallbackMenuId = fallbackWorkspace.menuIds?.[fallbackType] ?? null;
    if (!(await openDialog({ kind: "confirm", title: "Delete workspace?", message: `“${workspace.title}” will be removed. Its notes will be moved to “${fallbackWorkspace.title}”.`, confirmLabel: "Delete", danger: true }))) return;
    if (supabase && user) {
      const { error: detachError } = await supabase
        .from("notes")
        .update({ workspace_id: fallbackWorkspace.id, menu_id: fallbackMenuId })
        .eq("workspace_id", workspace.id);
      if (detachError) {
        await openDialog({ kind: "message", title: "Could not delete workspace", message: `The notes could not be detached: ${detachError.message}`, confirmLabel: "OK", danger: true });
        return;
      }

      const { error: menuError } = await supabase.from("menus").delete().eq("workspace_id", workspace.id);
      if (menuError) {
        await openDialog({ kind: "message", title: "Could not delete workspace", message: `The workspace menus could not be removed: ${menuError.message}`, confirmLabel: "OK", danger: true });
        return;
      }

      const { data: deletedRows, error: workspaceError } = await supabase
        .from("workspaces")
        .delete()
        .eq("id", workspace.id)
        .select("id");
      if (workspaceError || !deletedRows?.length) {
        const detail = workspaceError?.message ?? "Supabase did not delete the workspace.";
        await openDialog({ kind: "message", title: "Could not delete workspace", message: detail, confirmLabel: "OK", danger: true });
        return;
      }
    }
    setNotes((current) => current.map((note) => note.workspace_id === workspace.id ? { ...note, workspace_id: fallbackWorkspace.id, menu_id: fallbackMenuId, updated_at: now() } : note));
    setWorkspaces(remainingWorkspaces); setWorkspaceId(fallbackWorkspace.id); setView(fallbackType); setShowArchived(false); setSelectedId(null);
  };
  const addMenu = async () => {
    const available = (Object.keys(labels) as NoteType[]).filter((type) => !workspace.views.includes(type));
    const result = await openDialog({ kind: "select", title: "Add menu", message: "Choose a note type", value: available[0], options: available.map((type) => ({ value: type, label: labels[type] })), confirmLabel: "Add" });
    const value = result as NoteType; if (!available.includes(value)) return;
    const menuId = id();
    if (supabase && user) { const { error } = await supabase.from("menus").insert({ id: menuId, user_id: user.id, workspace_id: workspace.id, type: value, label: labels[value], position: workspace.views.length }); if (error) return; }
    setWorkspaces(workspaces.map((item) => item.id === workspace.id ? { ...item, views: [...item.views, value], menuLabels: { ...item.menuLabels, [value]: labels[value] }, menuIds: { ...item.menuIds, [value]: menuId } } : item)); setView(value);
  };
  const renameMenu = async () => {
    const current = workspace.menuLabels?.[view] ?? labels[view];
    const result = await openDialog({ kind: "input", title: "Rename menu", message: "Menu title", value: current, confirmLabel: "Save" });
    const value = typeof result === "string" ? result.trim() : ""; if (!value) return;
    const menuId = workspace.menuIds?.[view];
    if (supabase && menuId) { const { error } = await supabase.from("menus").update({ label: value }).eq("id", menuId); if (error) return; }
    setWorkspaces(workspaces.map((item) => item.id === workspace.id ? { ...item, menuLabels: { ...item.menuLabels, [view]: value } } : item));
  };
  const deleteMenu = async (type: NoteType) => {
    if (workspace.views.length < 2 || !(await openDialog({ kind: "confirm", title: "Remove menu?", message: `${workspace.menuLabels?.[type] ?? labels[type]} will be hidden. Its notes will be kept.`, confirmLabel: "Remove", danger: true }))) return;
    const menuId = workspace.menuIds?.[type];
    if (supabase && menuId) { const { error } = await supabase.from("menus").delete().eq("id", menuId); if (error) return; }
    const views = workspace.views.filter((item) => item !== type);
    const menuLabels = { ...workspace.menuLabels }; delete menuLabels[type];
    const menuIds = { ...workspace.menuIds }; delete menuIds[type];
    setWorkspaces(workspaces.map((item) => item.id === workspace.id ? { ...item, views, menuLabels, menuIds } : item)); if (view === type) setView(views[0]);
  };

  if (!authReady) return <div className="center-screen"><div className="logo">P</div><p>Opening your private space…</p></div>;
  if (supabase && !user) return <main className="auth-page"><section className="auth-hero"><div className="logo">P</div><p className="eyebrow">Private Thinking Space</p><h1>A quiet place for the thoughts that matter.</h1><p>Journal, reflect, study, and sharpen ideas without the noise of a productivity dashboard.</p></section><section className="auth-card"><p className="eyebrow">Welcome to PNote</p><h2>Sign in with email</h2><p>We will send a private magic link. No password needed.</p><input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@example.com" type="email"/><button className="primary" onClick={() => void signIn()}>Send magic link</button>{authMessage && <p className="auth-message">{authMessage}</p>}</section></main>;

  return <div className={`app ${sidebarOpen ? "" : "sidebar-closed"}`}>
    <aside className="sidebar">
      <header className="brand"><div className="logo small">P</div><div><p className="eyebrow">Private Thinking Space</p><h1>PNote</h1></div></header>
      <section className="workspace-card"><div><p className="eyebrow">{workspace.eyebrow}</p><h3>{workspace.title}</h3></div><button className="icon" onClick={renameWorkspace}><Pencil size={15}/></button><button className="icon danger" onClick={deleteWorkspace}><Trash2 size={15}/></button></section>
      <div className="row"><select value={workspaceId} onChange={(e) => { const next = workspaces.find((w) => w.id === e.target.value)!; setWorkspaceId(next.id); setView(next.views[0]); setShowArchived(false); }}>{workspaces.map((item) => <option value={item.id} key={item.id}>{item.title}</option>)}</select><button className="icon" onClick={addWorkspace}><Plus size={17}/></button></div>
      <button className="primary new-note" onClick={() => void create()}><Plus size={18}/> New note</button>
      <nav><div className="nav-head"><p className="eyebrow">Workspace Menu</p><button className="icon" onClick={addMenu}><Plus size={16}/></button></div>{workspace.views.map((type) => <div className={`nav-row ${!showArchived && view === type ? "active" : ""}`} key={type}><button onClick={() => { setView(type); setShowArchived(false); setSelectedId(null); }}>{workspace.menuLabels?.[type] ?? labels[type]}<span>{notes.filter((n) => !n.archived && n.type === type).length}</span></button><button className="remove-menu" onClick={() => deleteMenu(type)}><X size={13}/></button></div>)}<div className={`nav-row archive-nav ${showArchived ? "active" : ""}`}><button onClick={() => { setShowArchived(true); setSelectedId(null); }}><span className="archive-nav-label"><Archive size={15}/> Archived Notes</span><span>{notes.filter((note) => note.archived).length}</span></button></div></nav>
      <footer><button onClick={() => setTheme(theme === "midnight" ? "paper" : "midnight")}>{theme === "midnight" ? <Sun size={17}/> : <Moon size={17}/>} {theme === "midnight" ? "Paper" : "Midnight"}</button>{supabase && <button onClick={() => void editProfile()}><Settings size={17}/> Profile settings</button>}{supabase && <button onClick={() => void supabase.auth.signOut()}><LogOut size={17}/> Sign out</button>}<strong>{profile?.display_name || "PNote user"}</strong><span>{user?.email ?? "Local preview mode"}</span></footer>
    </aside>
    <main className="workspace-main">
      <section className="note-list-pane"><header className="pane-header"><button className="icon mobile-menu" onClick={() => setSidebarOpen(!sidebarOpen)}><Menu/></button><div><p className="eyebrow">{showArchived ? "Library" : workspace.title}</p><div className="title-row"><h2>{showArchived ? "Archived Notes" : workspace.menuLabels?.[view] ?? labels[view]}</h2>{!showArchived && <button className="text-button" onClick={renameMenu}>Rename</button>}</div></div><label className="search"><Search size={16}/><input value={query} onChange={(e) => setQuery(e.target.value)} placeholder={showArchived ? "Search archived notes" : "Search notes"}/></label></header><div className="note-list">{!showArchived && view === "oneThing" ? Object.entries(Object.groupBy(visible, (n) => new Intl.DateTimeFormat("en", { month: "long", year: "numeric" }).format(new Date(n.created_at)))).map(([month, items]) => <section className="month" key={month}><h4>{month}<span>{items?.length} weeks</span></h4>{items?.map((note) => <NoteCard key={note.id} note={note} active={selected?.id === note.id} onClick={() => setSelectedId(note.id)}/>)}</section>) : visible.map((note) => <NoteCard key={note.id} note={note} active={selected?.id === note.id} onClick={() => setSelectedId(note.id)}/>)}{visible.length === 0 && <div className="empty"><p>{showArchived ? "No archived notes." : "No notes here yet."}</p>{!showArchived && <button className="primary" onClick={() => void create()}>Create the first one</button>}</div>}</div></section>
      <section className="editor-pane">{selected ? <><header className="editor-header"><div><p className="eyebrow">{showArchived ? "Archived note" : "Editor"}</p><span>Updated {dateLabel(selected.updated_at)} · <b className={saveState}>{saveState}</b></span></div><div className="row editor-actions"><label className="font-picker">Font<select value={selected.note_font ?? "sans"} onChange={(e) => updateSelected("note_font", e.target.value as Note["note_font"])}><option value="sans">Sans-serif</option><option value="mono">Monospace</option></select></label><button className="icon" title="Pin note" aria-label="Pin note" onClick={() => updateSelected("pinned", !selected.pinned)}><Pin size={17}/></button>{showArchived ? <button className="archive-button restore-button" title="Restore note" onClick={restoreSelected}><Archive size={17}/><span>Restore</span></button> : <button className="archive-button" title="Archive note" onClick={() => { updateSelected("archived", true); setSelectedId(null); }}><Archive size={17}/><span>Archive</span></button>}<button className="icon danger" title="Delete note permanently" aria-label="Delete note permanently" onClick={() => void remove()}><Trash2 size={17}/></button></div></header><div className={`editor font-${selected.note_font ?? "sans"}`}><input className="note-title" value={selected.title} onChange={(e) => updateSelected("title", e.target.value)}/><textarea value={selected.content} onChange={(e) => updateSelected("content", e.target.value)} placeholder="Start writing…"/><div className="tag-row">{selected.tags.map((tag) => <span key={tag}>#{tag}</span>)}</div></div></> : <div className="editor-empty"><div className="logo">P</div><h2>{showArchived ? "No archived notes." : "Choose a note or begin a new one."}</h2><p>{showArchived ? "Archived notes will appear here." : "Your writing space is ready."}</p></div>}</section>
    </main>
    {dialog && <AppDialog dialog={dialog} onClose={closeDialog}/>} 
  </div>;
}

function AppDialog({ dialog, onClose }: { dialog: DialogState; onClose: (value: string | boolean | null) => void }) {
  const [value, setValue] = useState(dialog.value ?? "");
  const submit = () => onClose(dialog.kind === "confirm" || dialog.kind === "message" ? true : value);
  return <div className="dialog-backdrop" role="presentation" onMouseDown={(event) => { if (event.target === event.currentTarget) onClose(null); }}>
    <section className="app-dialog" role="dialog" aria-modal="true" aria-labelledby="dialog-title">
      <button className="dialog-close" aria-label="Close" onClick={() => onClose(null)}><X size={17}/></button>
      <p className="eyebrow">PNote</p><h2 id="dialog-title">{dialog.title}</h2>{dialog.message && <p>{dialog.message}</p>}
      {dialog.kind === "input" && <input autoFocus value={value} onChange={(event) => setValue(event.target.value)} onKeyDown={(event) => { if (event.key === "Enter") submit(); }}/>} 
      {dialog.kind === "select" && <select autoFocus value={value} onChange={(event) => setValue(event.target.value)}>{dialog.options?.map((option) => <option key={option.value} value={option.value}>{option.label}</option>)}</select>}
      <div className="dialog-actions">{dialog.kind !== "message" && <button className="secondary" onClick={() => onClose(null)}>Cancel</button>}<button className={dialog.danger ? "primary destructive" : "primary"} onClick={submit}>{dialog.confirmLabel ?? "Confirm"}</button></div>
    </section>
  </div>;
}

function NoteCard({ note, active, onClick }: { note: Note; active: boolean; onClick: () => void }) {
  return <button className={`note-card ${active ? "active" : ""}`} onClick={onClick}><div className="note-card-top"><span>{labels[note.type]}</span>{note.pinned && <Pin size={13}/>}</div><h3>{note.title || "Untitled"}</h3><p>{note.content.replace(/[#*-]/g, " ").replace(/\s+/g, " ").trim() || "Empty note"}</p><small>{dateLabel(note.updated_at)}</small></button>;
}
