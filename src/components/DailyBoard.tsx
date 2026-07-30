"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import type { User } from "@supabase/supabase-js";
import { ArrowLeft, Check, ChevronLeft, ChevronRight, Moon, NotebookPen, Sun, Table2 } from "lucide-react";
import { createSupabaseBrowserClient, hasSupabaseConfig } from "@/lib/supabase/client";
import type { DailyHabitKey } from "@/lib/types";

const themeKey = "pnote-web-theme";
const previewChecksKey = "pnote-web-board-checks-v1";
const visibleDayCount = 14;

const habits: Array<{ key: DailyHabitKey; label: string }> = [
  { key: "wake_before_6", label: "Get up before 6 a.m." },
  { key: "sleep_before_11", label: "Sleep before 11 p.m." },
  { key: "screen_time_under_3h", label: "Phone screen time less than 3 hours" },
  { key: "language_30m", label: "Learn 1 language for 30 mins" },
  { key: "tech_30m", label: "Learn tech for 30 mins" },
  { key: "personal_business_1h", label: "Spend at least 1 hour on a personal business project" },
  { key: "gym_session", label: "Gym session" }
];

const startOfDay = (date: Date) => new Date(date.getFullYear(), date.getMonth(), date.getDate());
const dateKey = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
const parseDateKey = (value: string) => {
  const [year, month, day] = value.split("-").map(Number);
  return new Date(year, month - 1, day);
};
const addDays = (date: Date, amount: number) => {
  const next = new Date(date);
  next.setDate(next.getDate() + amount);
  return next;
};
const checkKey = (taskKey: DailyHabitKey, dayKey: string) => `${dayKey}:${taskKey}`;

export function DailyBoard() {
  const router = useRouter();
  const supabase = useMemo(() => createSupabaseBrowserClient(), []);
  const [user, setUser] = useState<User | null>(null);
  const [authReady, setAuthReady] = useState(!hasSupabaseConfig);
  const [theme, setTheme] = useState("midnight");
  const [rangeStart, setRangeStart] = useState(() => dateKey(startOfDay(new Date())));
  const [checks, setChecks] = useState<Set<string>>(new Set());
  const [boardReady, setBoardReady] = useState(false);
  const [saveState, setSaveState] = useState<"saved" | "saving" | "error">("saved");
  const [boardError, setBoardError] = useState("");

  const dates = useMemo(() => {
    const firstDate = parseDateKey(rangeStart);
    return Array.from({ length: visibleDayCount }, (_, index) => addDays(firstDate, index));
  }, [rangeStart]);
  const today = dateKey(startOfDay(new Date()));
  const rangeEnd = dateKey(dates[dates.length - 1]);

  useEffect(() => {
    const storedTheme = localStorage.getItem(themeKey);
    if (storedTheme) queueMicrotask(() => setTheme(storedTheme));
    if (!supabase) return;

    void supabase.auth.getUser().then(({ data }) => {
      setUser(data.user);
      setAuthReady(true);
    });
    const { data } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
      setAuthReady(true);
    });
    return () => data.subscription.unsubscribe();
  }, [supabase]);

  useEffect(() => {
    document.documentElement.dataset.theme = theme;
    localStorage.setItem(themeKey, theme);
  }, [theme]);

  useEffect(() => {
    if (authReady && supabase && !user) router.replace("/");
  }, [authReady, router, supabase, user]);

  const loadChecks = useCallback(async () => {
    await Promise.resolve();
    setBoardError("");
    if (!supabase) {
      const stored = localStorage.getItem(previewChecksKey);
      let allChecks: string[] = [];
      if (stored) {
        try {
          allChecks = JSON.parse(stored) as string[];
        } catch {
          allChecks = [];
        }
      }
      setChecks(new Set(allChecks.filter((value) => {
        const day = value.slice(0, 10);
        return day >= rangeStart && day <= rangeEnd;
      })));
      setBoardReady(true);
      return;
    }
    if (!user) return;

    setBoardReady(false);
    const { data, error } = await supabase
      .from("daily_habit_checks")
      .select("task_key,check_date")
      .eq("completed", true)
      .gte("check_date", rangeStart)
      .lte("check_date", rangeEnd);

    if (error) {
      setChecks(new Set());
      setBoardError("Board data could not be loaded. Please apply the latest Supabase schema.");
    } else {
      setChecks(new Set((data ?? []).map((item) => checkKey(item.task_key as DailyHabitKey, item.check_date))));
    }
    setBoardReady(true);
  }, [rangeEnd, rangeStart, supabase, user]);

  useEffect(() => {
    if (!authReady || (supabase && !user)) return;
    queueMicrotask(() => void loadChecks());
  }, [authReady, loadChecks, supabase, user]);

  const moveRange = (amount: number) => {
    setRangeStart(dateKey(addDays(parseDateKey(rangeStart), amount)));
    setSaveState("saved");
  };

  const toggleCheck = async (taskKey: DailyHabitKey, day: string) => {
    const key = checkKey(taskKey, day);
    const shouldComplete = !checks.has(key);
    setBoardError("");
    setSaveState("saving");
    setChecks((current) => {
      const next = new Set(current);
      if (shouldComplete) next.add(key);
      else next.delete(key);
      return next;
    });

    if (!supabase) {
      let storedChecks: string[] = [];
      try {
        storedChecks = JSON.parse(localStorage.getItem(previewChecksKey) ?? "[]") as string[];
      } catch {
        storedChecks = [];
      }
      const next = new Set(storedChecks);
      if (shouldComplete) next.add(key);
      else next.delete(key);
      localStorage.setItem(previewChecksKey, JSON.stringify([...next]));
      setSaveState("saved");
      return;
    }
    if (!user) return;

    const result = shouldComplete
      ? await supabase.from("daily_habit_checks").upsert(
          { user_id: user.id, task_key: taskKey, check_date: day, completed: true },
          { onConflict: "user_id,task_key,check_date" }
        )
      : await supabase
          .from("daily_habit_checks")
          .delete()
          .eq("user_id", user.id)
          .eq("task_key", taskKey)
          .eq("check_date", day);

    if (result.error) {
      setChecks((current) => {
        const reverted = new Set(current);
        if (shouldComplete) reverted.delete(key);
        else reverted.add(key);
        return reverted;
      });
      setBoardError("This change could not be saved. Please try again.");
      setSaveState("error");
    } else {
      setSaveState("saved");
    }
  };

  if (!authReady || (supabase && !user)) {
    return <div className="center-screen"><div className="logo">P</div><p>Opening your daily board...</p></div>;
  }

  return <div className="board-page">
    <aside className="board-rail">
      <Link className="brand board-brand" href="/">
        <div className="logo small">P</div>
        <div><p className="eyebrow">Private Thinking Space</p><h1>PNote</h1></div>
      </Link>
      <nav className="board-rail-nav" aria-label="PNote pages">
        <Link href="/"><NotebookPen size={18}/><span>Notes</span></Link>
        <Link href="/board" className="active" aria-current="page"><Table2 size={18}/><span>Daily Board</span></Link>
      </nav>
      <footer>
        <button onClick={() => setTheme(theme === "midnight" ? "paper" : "midnight")}>
          {theme === "midnight" ? <Sun size={17}/> : <Moon size={17}/>}
          {theme === "midnight" ? "Paper theme" : "Midnight theme"}
        </button>
        <span>{user?.email ?? "Local preview mode"}</span>
      </footer>
    </aside>

    <main className="board-main">
      <header className="board-header">
        <div className="board-heading">
          <Link href="/" className="board-back"><ArrowLeft size={16}/> Back to notes</Link>
          <p className="eyebrow">Daily rhythm</p>
          <h1>Daily Board</h1>
          <p>Small commitments, repeated with intention.</p>
        </div>
        <div className="board-controls" aria-label="Date range controls">
          <button className="icon" title="Previous 14 days" aria-label="Previous 14 days" onClick={() => moveRange(-visibleDayCount)}><ChevronLeft/></button>
          <button className="secondary" onClick={() => setRangeStart(today)}>Today</button>
          <button className="icon" title="Next 14 days" aria-label="Next 14 days" onClick={() => moveRange(visibleDayCount)}><ChevronRight/></button>
        </div>
      </header>

      <section className="board-card" aria-labelledby="board-range-label">
        <div className="board-card-header">
          <div>
            <p className="eyebrow">14-day view</p>
            <h2 id="board-range-label">
              {new Intl.DateTimeFormat("en", { month: "short", day: "numeric" }).format(dates[0])}
              {" - "}
              {new Intl.DateTimeFormat("en", { month: "short", day: "numeric", year: "numeric" }).format(dates[dates.length - 1])}
            </h2>
          </div>
          <p className={`board-save-state ${saveState}`} role="status">
            {saveState === "saving" ? "Saving..." : saveState === "error" ? "Save failed" : "All changes saved"}
          </p>
        </div>

        {boardError && <p className="board-error" role="alert">{boardError}</p>}
        <div className="board-scroll">
          <table className="habit-board">
            <thead>
              <tr>
                <th className="habit-name-column" scope="col">
                  <span>Daily commitments</span>
                  <small>{habits.length} habits</small>
                </th>
                {dates.map((date) => {
                  const day = dateKey(date);
                  return <th key={day} className={day === today ? "today" : ""} scope="col">
                    <span>{new Intl.DateTimeFormat("en", { weekday: "short" }).format(date)}</span>
                    <strong>{date.getDate()}</strong>
                    <small>{new Intl.DateTimeFormat("en", { month: "short" }).format(date)}</small>
                  </th>;
                })}
              </tr>
            </thead>
            <tbody>
              {habits.map((habit, index) => <tr key={habit.key}>
                <th className="habit-name-column" scope="row">
                  <span className="habit-number">{String(index + 1).padStart(2, "0")}</span>
                  <span>{habit.label}</span>
                </th>
                {dates.map((date) => {
                  const day = dateKey(date);
                  const checked = checks.has(checkKey(habit.key, day));
                  return <td key={day} className={day === today ? "today" : ""}>
                    <label className="board-checkbox">
                      <input
                        type="checkbox"
                        checked={checked}
                        disabled={!boardReady}
                        onChange={() => void toggleCheck(habit.key, day)}
                        aria-label={`${habit.label} on ${new Intl.DateTimeFormat("en", { dateStyle: "long" }).format(date)}`}
                      />
                      <span><Check size={16}/></span>
                    </label>
                  </td>;
                })}
              </tr>)}
            </tbody>
            <tfoot>
              <tr>
                <th className="habit-name-column" scope="row">Daily progress</th>
                {dates.map((date) => {
                  const day = dateKey(date);
                  const completed = habits.filter((habit) => checks.has(checkKey(habit.key, day))).length;
                  return <td key={day} className={day === today ? "today" : ""}><strong>{completed}/{habits.length}</strong></td>;
                })}
              </tr>
            </tfoot>
          </table>
        </div>
      </section>
    </main>
  </div>;
}
