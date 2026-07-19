import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "PNote — Private Thinking Space",
  description: "A calm private space for journaling, reflection, study, business, and investment thinking."
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
