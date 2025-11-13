"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { Plus, RotateCcw, X } from "lucide-react";
import { TaskFilters } from "@/components/task-filters";
import { TaskForm } from "@/components/task-form";
import { TaskList } from "@/components/task-list";
import {
  createTask,
  deleteTask,
  fetchTasks,
  updateTask,
} from "@/lib/tasks-api";
import type { Task, TaskFilters as Filters, TaskPayload } from "@/types/tasks";

const defaultFilters: Filters = {
  status: "all",
  order: "asc",
  orderBy: "due_date",
};

export function TaskBoard() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [filters, setFilters] = useState<Filters>(defaultFilters);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [createSubmitting, setCreateSubmitting] = useState(false);
  const [editSubmitting, setEditSubmitting] = useState(false);
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const [busyTaskId, setBusyTaskId] = useState<number | null>(null);
  const [busyAction, setBusyAction] = useState<"delete" | "status" | null>(
    null
  );
  const [modalMode, setModalMode] = useState<"create" | "edit">("create");
  const [showModal, setShowModal] = useState(false);
  const [closingModal, setClosingModal] = useState(false);
  const modalTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const handleError = (error: unknown) => {
    const message =
      error instanceof Error
        ? error.message
        : "Algo inesperado aconteceu. Tente novamente.";
    setError(message);
  };

  const loadTasks = useCallback(
    async (withSpinner = true) => {
      try {
        setError(null);
        if (withSpinner) {
          setLoading(true);
        } else {
          setRefreshing(true);
        }
        const data = await fetchTasks(filters);
        setTasks(data);
      } catch (err) {
        handleError(err);
      } finally {
        if (withSpinner) {
          setLoading(false);
        } else {
          setRefreshing(false);
        }
      }
    },
    [filters]
  );

  useEffect(() => {
    loadTasks(true);
  }, [loadTasks]);

  useEffect(
    () => () => {
      if (modalTimer.current) clearTimeout(modalTimer.current);
    },
    []
  );

  const openCreateModal = () => {
    if (modalTimer.current) clearTimeout(modalTimer.current);
    setModalMode("create");
    setEditingTask(null);
    setClosingModal(false);
    setShowModal(true);
  };

  const openEditModal = (task: Task) => {
    if (modalTimer.current) clearTimeout(modalTimer.current);
    setModalMode("edit");
    setEditingTask(task);
    setClosingModal(false);
    setShowModal(true);
  };

  const closeModal = () => {
    setClosingModal(true);
    if (modalTimer.current) clearTimeout(modalTimer.current);
    modalTimer.current = setTimeout(() => {
      setShowModal(false);
      setClosingModal(false);
      setEditingTask(null);
    }, 200);
  };

  const submitCreate = async (payload: TaskPayload) => {
    setCreateSubmitting(true);
    try {
      await createTask(payload);
      await loadTasks(false);
      closeModal();
    } catch (err) {
      handleError(err);
    } finally {
      setCreateSubmitting(false);
    }
  };

  const submitEdit = async (payload: TaskPayload) => {
    if (!editingTask) return;
    setEditSubmitting(true);
    try {
      await updateTask(editingTask.id, payload);
      await loadTasks(false);
      closeModal();
    } catch (err) {
      handleError(err);
    } finally {
      setEditSubmitting(false);
    }
  };

  const handleDelete = async (task: Task) => {
    const confirmed = window.confirm(
      `Tem certeza que deseja excluir "${task.title}"?`
    );
    if (!confirmed) return;
    setBusyTaskId(task.id);
    setBusyAction("delete");
    try {
      await deleteTask(task.id);
      if (editingTask?.id === task.id) {
        setEditingTask(null);
      }
      await loadTasks(false);
    } catch (err) {
      handleError(err);
    } finally {
      setBusyTaskId(null);
      setBusyAction(null);
    }
  };

  const handleToggleStatus = async (task: Task) => {
    setBusyTaskId(task.id);
    setBusyAction("status");
    try {
      await updateTask(task.id, {
        title: task.title,
        description: task.description ?? undefined,
        dueDateUtc: task.dueDateUtc ?? null,
        status: task.status === "done" ? "open" : "done",
      });
      await loadTasks(false);
    } catch (err) {
      handleError(err);
    } finally {
      setBusyTaskId(null);
      setBusyAction(null);
    }
  };

  const tasksLabel =
    tasks.length === 1 ? "1 tarefa" : `${tasks.length} tarefas`;

  return (
    <div className="flex flex-col gap-4">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-semibold text-gray-900">Tarefas</h2>
          <p className="text-sm text-gray-600">
            {loading ? "Carregando..." : tasksLabel}
          </p>
        </div>
        <div className="flex gap-2">
          <button
            type="button"
            className="inline-flex items-center gap-2 rounded-md bg-avine-green px-4 py-2 text-sm font-medium text-white transition-colors duration-200 hover:bg-avine-lime focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-avine-green/40"
            onClick={openCreateModal}
          >
            <Plus className="h-4 w-4" />
            Nova Tarefa
          </button>
          <button
            type="button"
            className="inline-flex items-center gap-2 rounded-md border border-gray-200 bg-white px-3 py-2 text-sm font-medium text-gray-700 transition-colors duration-200 hover:bg-gray-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-300 disabled:cursor-not-allowed disabled:opacity-50"
            onClick={() => loadTasks(false)}
            disabled={loading || refreshing}
          >
            <RotateCcw
              className={`h-4 w-4 ${
                refreshing ? "animate-spin text-avine-orange" : ""
              }`}
            />
            Atualizar
          </button>
        </div>
      </div>

      <TaskFilters filters={filters} onChange={setFilters} />

      {error && (
        <div className="rounded-md border border-red-200 bg-red-50 px-3 py-2">
          <p className="text-sm text-red-800">{error}</p>
        </div>
      )}

      {refreshing && !loading && (
        <div className="flex items-center gap-2 text-sm text-gray-600">
          <RotateCcw className="h-3.5 w-3.5 animate-spin" />
          Atualizando...
        </div>
      )}

      <TaskList
        tasks={tasks}
        loading={loading}
        onEdit={openEditModal}
        onDelete={handleDelete}
        onToggleStatus={handleToggleStatus}
        busyTaskId={busyTaskId}
        busyAction={busyAction}
      />

      {showModal && (
        <div
          className={`fixed inset-0 z-50 flex items-center justify-center bg-gray-900/60 p-4 backdrop-blur-md transition-opacity duration-200 ${
            closingModal ? "opacity-0" : "opacity-100"
          }`}
          onClick={closeModal}
        >
          <div
            className={`w-full max-w-2xl overflow-hidden rounded-xl border border-gray-200 bg-white shadow-2xl transition-all duration-200 ${
              closingModal ? "scale-95 opacity-0" : "scale-100 opacity-100"
            }`}
            onClick={(event) => event.stopPropagation()}
          >
            <div className="flex items-center justify-between border-b border-gray-200 bg-gradient-to-r from-gray-50 to-white px-6 py-5">
              <div>
                <h2 className="text-lg font-semibold text-gray-900">
                  {modalMode === "create" ? "Nova Tarefa" : "Editar Tarefa"}
                </h2>
                <p className="mt-0.5 text-xs text-gray-500">
                  {modalMode === "create"
                    ? "Preencha os campos abaixo para criar uma nova tarefa"
                    : "Atualize as informações da tarefa"}
                </p>
              </div>
              <button
                type="button"
                className="rounded-lg p-2 text-gray-400 transition-colors duration-200 hover:bg-gray-100 hover:text-gray-600 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-300"
                onClick={closeModal}
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="bg-white p-6">
              <TaskForm
                mode={modalMode}
                initialTask={modalMode === "edit" ? editingTask : null}
                submitting={
                  modalMode === "create" ? createSubmitting : editSubmitting
                }
                onSubmit={modalMode === "create" ? submitCreate : submitEdit}
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
