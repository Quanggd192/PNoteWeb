export type NoteType = "note" | "journal" | "dreams" | "reflection" | "oneThing" | "routine" | "study" | "brainstorm" | "capital" | "weeklySpend" | "business" | "investment";

export interface UserProfile {
  id: string;
  email: string | null;
  display_name: string;
  avatar_url: string | null;
  role: "user" | "admin";
  status: "active" | "suspended";
  preferences: Record<string, unknown>;
  created_at: string;
  updated_at: string;
}

export interface Note {
  id: string;
  user_id: string;
  workspace_id: string | null;
  menu_id: string | null;
  title: string;
  content: string;
  note_font: "sans" | "mono";
  type: NoteType;
  tags: string[];
  pinned: boolean;
  archived: boolean;
  created_at: string;
  updated_at: string;
}

export interface WorkspaceConfig {
  id: string;
  user_id?: string;
  title: string;
  eyebrow: string;
  views: NoteType[];
  menuLabels?: Partial<Record<NoteType, string>>;
  menuIds?: Partial<Record<NoteType, string>>;
  position?: number;
}

export const labels: Record<NoteType, string> = {
  note: "Notes", journal: "Journal", dreams: "Dreams", reflection: "Weekly Reflect",
  oneThing: "The One Thing", routine: "Routine", study: "Study", brainstorm: "Brainstorm",
  capital: "Capital Tracker", weeklySpend: "Weekly Spend", business: "Business", investment: "Investment"
};

export const defaultWorkspaces: WorkspaceConfig[] = [
  { id: "reflect", title: "Reflect", eyebrow: "Reset inward", views: ["journal", "dreams", "reflection", "oneThing", "routine", "study", "brainstorm"] },
  { id: "cash-flow", title: "Cash Flow", eyebrow: "Track movement", views: ["capital", "weeklySpend"] },
  { id: "venture", title: "Business & Investment", eyebrow: "Sharpen conviction", views: ["business", "investment"] }
];

export const templates: Partial<Record<NoteType, string>> = {
  dreams: "## Dream narrative\n\n## Key symbols / archetypes\n- \n\n## Emotions\n\n## Jungian reflection\n",
  reflection: "## What happened this week?\n\n## What gave me energy?\n\n## What drained me?\n\n## What did I avoid?\n\n## What should change next week?\n",
  oneThing: "## Monthly direction\nWhat is the most important result I want this month?\n\nWhy does this matter now?\n\n## This week's one thing\nWhat is the ONE thing I can do this week such that by doing it everything else will be easier or unnecessary?\n\nWhat does a successful week look like in concrete terms?\n\n## Focus and tradeoffs\nWhat will I say no to so this gets my best attention?\n\nWhat is the biggest obstacle, and how will I handle it?\n\n## First move\nWhat is the smallest meaningful action I will take first?\n\nWhen will I do it?\n\n## End-of-week check\nDid I complete the one thing? What did I learn?\n",
  study: "## Topic\n\n## What did I learn?\n\n## Key ideas\n- \n\n## Questions\n- \n\n## Next action\n",
  brainstorm: "## Prompt\n\n## Ideas\n- \n- \n- \n\n## Interesting directions\n\n## What should I explore next?\n",
  capital: "## Snapshot\nTotal net worth:\n\nLiquid assets:\n\nInvested capital:\n\nDebt / liabilities:\n\n## Allocation\n- Cash:\n- Equities:\n- Crypto:\n- Business equity:\n- Real estate:\n\n## Growth velocity\nCurrent net worth:\n\nMonthly growth speed:\n\nNext milestone:\n",
  weeklySpend: "## Weekly budget\nTotal budget:\n\n## Categories\n- Food:\n- Transport:\n- Learning:\n- Other:\n\n## Actual spent\n\n## Remaining\n",
  business: "## Problem\n\n## Who has it?\n\n## Why now?\n\n## Possible solution\n\n## Moat or unfair advantage\n\n## Open questions\n",
  investment: "## Asset / Ticker\n\n## Thesis\n\n## Catalysts\n\n## What could go right?\n\n## What could break the thesis?\n\n## Risk management\n"
};
