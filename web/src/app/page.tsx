import Image from "next/image";
import { TaskBoard } from "@/components/task-board";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-gray-50 to-gray-100">
      <header className="border-b border-gray-200 bg-gradient-to-r from-avine-yellow to-amber-400 shadow-sm">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-3.5">
          <div className="flex items-center gap-3">
            <div className="flex h-20 w-20 items-center justify-center rounded-lg ring-white/40 transition-all duration-200 hover:scale-105 hover:shadow-lg">
              <Image
                src="/avine-logo.png"
                alt="Avine"
                width={100}
                height={70}
                priority
              />
            </div>
            <div>
              <p className="text-[9px] font-semibold uppercase tracking-wider text-avine-green/80">
                Desafio Avine
              </p>
              <h1 className="text-base font-bold text-avine-green">
                Painel de Tarefas
              </h1>
            </div>
          </div>

          <a
            href="http://localhost:8081/list.asp"
            target="_blank"
            rel="noopener noreferrer"
            className="group inline-flex items-center gap-2 rounded-lg border border-white/60 bg-white/90 px-4 py-2 text-sm font-medium text-avine-green shadow-sm backdrop-blur-sm transition-all duration-200 hover:border-avine-green hover:bg-avine-green hover:text-white hover:shadow-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white/60"
          >
            <span className="h-1.5 w-1.5 rounded-full bg-avine-orange transition-colors group-hover:bg-white" />
            <span className="hidden sm:inline">Versão ASP Clássico</span>
            <span className="sm:hidden">ASP</span>
          </a>
        </div>
      </header>

      <main className="mx-auto w-full max-w-6xl px-6 py-6">
        <TaskBoard />
      </main>
    </div>
  );
}
