import type { Metadata } from "next";
import { Open_Sans } from "next/font/google";
import "./globals.css";

const openSans = Open_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
});

export const metadata: Metadata = {
  title: "Desafio Avine | Painel de Tarefas",
  description:
    "Interface Next.js para gerenciar tarefas usando a API em .NET 8.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-BR">
      <body
        className={`${openSans.className} min-h-screen bg-avine-mist text-avine-charcoal antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
