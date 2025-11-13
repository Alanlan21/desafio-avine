import {
  CheckCircle2,
  PencilLine,
  RotateCcw,
  Trash2,
  Undo2,
} from "lucide-react";
import { formatUtcDate } from "@/lib/dates";
import type { Task } from "@/types/tasks";

interface TaskListProps {
  tasks: Task[];
  loading: boolean;
  onEdit: (task: Task) => void;
  onDelete: (task: Task) => void;
  onToggleStatus: (task: Task) => void;
  busyTaskId: number | null;
  busyAction: "delete" | "status" | null;
}

export function TaskList({
  tasks,
  loading,
  onEdit,
  onDelete,
  onToggleStatus,
  busyTaskId,
  busyAction,
}: TaskListProps) {
  if (loading) {
    return (
      <div className="flex items-center justify-center gap-3 rounded-lg border border-gray-200 bg-white p-12 shadow-sm">
        <RotateCcw className="h-5 w-5 animate-spin text-avine-green" />
        <span className="text-sm font-medium text-gray-600">
          Carregando tarefas...
        </span>
      </div>
    );
  }

  if (!tasks.length) {
    return (
      <div className="rounded-lg border-2 border-dashed border-gray-300 bg-gray-50 p-12 text-center">
        <p className="text-sm text-gray-600">
          Nenhuma tarefa encontrada com os filtros selecionados
        </p>
      </div>
    );
  }

  return (
    <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {tasks.map((task) => {
        const isBusy = busyTaskId === task.id;
        const statusBusy = isBusy && busyAction === "status";
        const deleteBusy = isBusy && busyAction === "delete";

        return (
          <li
            key={task.id}
            className="group relative overflow-hidden rounded-lg border border-gray-200 bg-white shadow-sm transition-all duration-200 hover:-translate-y-0.5 hover:shadow-md"
          >
            <div className="absolute left-0 top-0 h-full w-1 bg-gradient-to-b from-avine-green to-avine-lime"></div>

            <div className="space-y-3 p-5 pl-6">
              <div className="flex items-start justify-between gap-3">
                <div className="flex-1 space-y-1.5">
                  <h3 className="line-clamp-2 text-sm font-semibold leading-snug text-gray-900">
                    {task.title}
                  </h3>
                  {task.description && (
                    <p className="line-clamp-2 text-xs leading-relaxed text-gray-600">
                      {task.description}
                    </p>
                  )}
                </div>
                <span
                  className={`shrink-0 rounded-full px-2.5 py-1 text-xs font-medium ${
                    task.status === "done"
                      ? "bg-gradient-to-r from-avine-green/10 to-avine-lime/10 text-avine-green ring-1 ring-avine-green/20"
                      : "bg-gradient-to-r from-amber-50 to-yellow-50 text-amber-700 ring-1 ring-amber-200"
                  }`}
                >
                  {task.status === "done" ? "Concluída" : "Aberta"}
                </span>
              </div>

              <div className="space-y-1 border-t border-gray-100 pt-3 text-xs text-gray-600">
                <div className="flex justify-between">
                  <span className="text-gray-500">Vencimento</span>
                  <span className="font-medium text-gray-900">
                    {formatUtcDate(task.dueDateUtc)}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Atualizada</span>
                  <span className="font-medium text-gray-900">
                    {formatUtcDate(task.updatedAtUtc)}
                  </span>
                </div>
              </div>

              <div className="flex flex-wrap gap-2 border-t border-gray-100 pt-3">
                <button
                  type="button"
                  className="inline-flex items-center gap-1.5 rounded-lg border border-gray-200 bg-white px-3 py-1.5 text-xs font-medium text-gray-700 transition-all duration-200 hover:bg-gray-50 hover:border-gray-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-300"
                  onClick={() => onEdit(task)}
                >
                  <PencilLine className="h-3.5 w-3.5" />
                  Editar
                </button>
                <button
                  type="button"
                  className={`inline-flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-medium text-white shadow-sm transition-all duration-200 focus-visible:outline-none focus-visible:ring-2 ${
                    task.status === "done"
                      ? "bg-gradient-to-r from-gray-600 to-gray-700 hover:from-gray-700 hover:to-gray-800 focus-visible:ring-gray-400"
                      : "bg-gradient-to-r from-avine-green to-avine-lime hover:shadow-md focus-visible:ring-avine-green"
                  } ${statusBusy ? "cursor-not-allowed opacity-50" : ""}`}
                  disabled={statusBusy}
                  onClick={() => onToggleStatus(task)}
                >
                  {statusBusy ? (
                    "..."
                  ) : task.status === "done" ? (
                    <>
                      <Undo2 className="h-3.5 w-3.5" />
                      Reabrir
                    </>
                  ) : (
                    <>
                      <CheckCircle2 className="h-3.5 w-3.5" />
                      Concluir
                    </>
                  )}
                </button>
                <button
                  type="button"
                  className="inline-flex items-center gap-1.5 rounded-lg border border-red-200 bg-red-50 px-3 py-1.5 text-xs font-medium text-red-700 transition-all duration-200 hover:bg-red-100 hover:border-red-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-red-300 disabled:cursor-not-allowed disabled:opacity-50"
                  disabled={deleteBusy}
                  onClick={() => onDelete(task)}
                >
                  {deleteBusy ? (
                    "..."
                  ) : (
                    <>
                      <Trash2 className="h-3.5 w-3.5" />
                      Excluir
                    </>
                  )}
                </button>
              </div>
            </div>
          </li>
        );
      })}
    </ul>
  );
}
