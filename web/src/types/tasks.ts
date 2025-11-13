export type TaskStatus = "open" | "done";

export interface Task {
  id: number;
  title: string;
  description?: string | null;
  status: TaskStatus;
  dueDateUtc?: string | null;
  createdAtUtc: string;
  updatedAtUtc: string;
}

export interface TaskPayload {
  title: string;
  description?: string;
  dueDateUtc?: string | null;
  status?: TaskStatus;
}

export interface TaskFilters {
  status: TaskStatus | "all";
  orderBy: "due_date" | "created_at";
  order: "asc" | "desc";
}
