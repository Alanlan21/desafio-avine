"use client";

import { useEffect, useState } from "react";
import { Plus, Save } from "lucide-react";
import { fromUtcInputValue, toUtcInputValue } from "@/lib/dates";
import type { Task, TaskPayload, TaskStatus } from "@/types/tasks";

interface TaskFormProps {
  mode: "create" | "edit";
  initialTask?: Task | null;
  submitting: boolean;
  onSubmit: (payload: TaskPayload) => Promise<void>;
}

export function TaskForm({
  mode,
  initialTask,
  submitting,
  onSubmit,
}: TaskFormProps) {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [dueDateUTC, setDueDateUTC] = useState("");
  const [status, setStatus] = useState<TaskStatus>("open");
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (initialTask) {
      setTitle(initialTask.title);
      setDescription(initialTask.description ?? "");
      setDueDateUTC(toUtcInputValue(initialTask.dueDateUtc));
      setStatus(initialTask.status);
    } else {
      resetForm();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [initialTask?.id]);

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError(null);

    if (!title.trim()) {
      setError("Informe um titulo para a tarefa.");
      return;
    }

    const payload: TaskPayload = {
      title: title.trim(),
      description: description.trim() || undefined,
      dueDateUtc: fromUtcInputValue(dueDateUTC),
    };

    if (mode === "edit") {
      payload.status = status;
    }

    await onSubmit(payload);
    if (mode === "create") {
      resetForm();
    }
  };

  const resetForm = () => {
    setTitle("");
    setDescription("");
    setDueDateUTC("");
    setStatus("open");
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      {error && (
        <div className="rounded-lg border border-red-200 bg-red-50 px-4 py-3">
          <p className="text-sm font-medium text-red-800">{error}</p>
        </div>
      )}

      <div className="space-y-4">
        <div>
          <label className="mb-2 block text-sm font-medium text-gray-700">
            Título da tarefa
          </label>
          <input
            type="text"
            value={title}
            onChange={(event) => setTitle(event.target.value)}
            className="w-full rounded-lg border border-gray-200 bg-gray-50 px-4 py-2.5 text-sm text-gray-900 transition-all placeholder:text-gray-400 focus:border-avine-green focus:bg-white focus:outline-none focus:ring-2 focus:ring-avine-green/20"
            placeholder="Ex: Atualizar SSO Avine"
          />
        </div>

        <div>
          <label className="mb-2 block text-sm font-medium text-gray-700">
            Descrição
          </label>
          <textarea
            value={description}
            onChange={(event) => setDescription(event.target.value)}
            className="w-full rounded-lg border border-gray-200 bg-gray-50 px-4 py-2.5 text-sm text-gray-900 transition-all placeholder:text-gray-400 focus:border-avine-green focus:bg-white focus:outline-none focus:ring-2 focus:ring-avine-green/20"
            rows={3}
            placeholder="Detalhe o que precisa ser feito..."
          />
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              Data de vencimento
            </label>
            <input
              type="datetime-local"
              value={dueDateUTC}
              onChange={(event) => setDueDateUTC(event.target.value)}
              className="w-full rounded-lg border border-gray-200 bg-gray-50 px-4 py-2.5 text-sm text-gray-900 transition-all focus:border-avine-green focus:bg-white focus:outline-none focus:ring-2 focus:ring-avine-green/20"
            />
          </div>

          {mode === "edit" && (
            <div>
              <label className="mb-2 block text-sm font-medium text-gray-700">
                Status
              </label>
              <select
                value={status}
                onChange={(event) =>
                  setStatus(event.target.value as TaskStatus)
                }
                className="w-full appearance-none rounded-lg border border-gray-200 bg-gray-50 px-4 py-2.5 text-sm text-gray-900 transition-all focus:border-avine-green focus:bg-white focus:outline-none focus:ring-2 focus:ring-avine-green/20"
              >
                <option value="open">Aberta</option>
                <option value="done">Concluída</option>
              </select>
            </div>
          )}
        </div>
      </div>

      <div className="flex justify-end gap-3 border-t border-gray-200 pt-5">
        <button
          type="submit"
          disabled={submitting}
          className="inline-flex items-center justify-center gap-2 rounded-lg bg-gradient-to-r from-avine-green to-avine-lime px-5 py-2.5 text-sm font-semibold text-white shadow-md shadow-avine-green/20 transition-all duration-200 hover:shadow-lg hover:shadow-avine-green/30 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-avine-lime/60 disabled:cursor-not-allowed disabled:opacity-50"
        >
          {submitting ? (
            "Salvando..."
          ) : mode === "create" ? (
            <>
              <Plus className="h-4 w-4" />
              Adicionar Tarefa
            </>
          ) : (
            <>
              <Save className="h-4 w-4" />
              Atualizar Tarefa
            </>
          )}
        </button>
      </div>
    </form>
  );
}
