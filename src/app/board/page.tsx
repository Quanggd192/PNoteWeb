import type { Metadata } from "next";
import { DailyBoard } from "@/components/DailyBoard";

export const metadata: Metadata = {
  title: "Daily Board - PNote",
  description: "Track daily commitments in a calm, private habit board."
};

export default function BoardPage() {
  return <DailyBoard />;
}
