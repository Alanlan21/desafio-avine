import type { Task, TaskFilters, TaskPayload } from "@/types/tasks";

const apiBase =
  (process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8080").replace(
    /\/$/,
    "",
  );
const TASKS_URL = `${apiBase}/api/tasks`;

async function handleResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    let message = "Não foi possível comunicar com a API.";
    try {
      const payload = await response.json();
      if (typeof payload?.message === "string") {
        message = payload.message;
      }
    } catch {
      
    }
    throw new Error(message);
  }

  if (response.status === 204) {
    return null as T;
  }

  return (await response.json()) as T;
}

export async function fetchTasks(filters: TaskFilters): Promise<Task[]> {
  const url = new URL(TASKS_URL);
  if (filters.status !== "all") {
    url.searchParams.set("status", filters.status);
  }
  url.searchParams.set("orderBy", filters.orderBy);
  url.searchParams.set("order", filters.order);

  const response = await fetch(url.toString(), {
    cache: "no-store",
  });
  return handleResponse<Task[]>(response);
}

export async function createTask(payload: TaskPayload): Promise<Task> {
  const response = await fetch(TASKS_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  });
  return handleResponse<Task>(response);
}

export async function updateTask(
  id: number,
  payload: TaskPayload,
): Promise<Task> {
  const response = await fetch(`${TASKS_URL}/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  });
  return handleResponse<Task>(response);
}

export async function deleteTask(id: number): Promise<void> {
  const response = await fetch(`${TASKS_URL}/${id}`, {
    method: "DELETE",
  });
  await handleResponse(response);
}
