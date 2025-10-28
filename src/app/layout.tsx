import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "TOM Skeleton",
  description: "Tomorrow Of Me - NCP Test Project",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ko">
      <body>{children}</body>
    </html>
  );
}