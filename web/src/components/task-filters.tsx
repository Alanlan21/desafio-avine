import type { TaskFilters } from "@/types/tasks";

interface TaskFiltersProps {
  filters: TaskFilters;
  onChange: (filters: TaskFilters) => void;
}

const statusOptions: Array<{ label: string; value: TaskFilters["status"] }> = [
  { label: "Todas", value: "all" },
  { label: "Abertas", value: "open" },
  { label: "Concluidas", value: "done" },
];

export function TaskFilters({ filters, onChange }: TaskFiltersProps) {
  return (
    <section className="rounded-lg border border-gray-200 bg-white shadow-sm">
      <div className="p-5">
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div className="flex flex-wrap gap-2">
            {statusOptions.map((option) => {
              const isActive = filters.status === option.value;
              return (
                <button
                  key={option.value}
                  type="button"
                  className={`rounded-lg px-4 py-2 text-sm font-medium transition-all duration-200 ${
                    isActive
                      ? "bg-gradient-to-r from-avine-green to-avine-lime text-white shadow-md shadow-avine-green/20"
                      : "bg-gray-50 text-gray-700 hover:bg-gray-100"
                  }`}
                  onClick={() => onChange({ ...filters, status: option.value })}
                >
                  {option.label}
                </button>
              );
            })}
          </div>

          <div className="flex flex-col gap-2 sm:flex-row">
            <div className="flex flex-col gap-1.5">
              <label
                htmlFor="orderBy"
                className="text-xs font-medium text-gray-600"
              >
                Ordenar por
              </label>
              <select
                id="orderBy"
                className="appearance-none rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-sm text-gray-900 transition-all focus:border-avine-green focus:bg-white focus:outline-none focus:ring-2 focus:ring-avine-green/20"
                value={filters.orderBy}
                onChange={(event) =>
                  onChange({
                    ...filters,
                    orderBy: event.target.value as TaskFilters["orderBy"],
                  })
                }
              >
                <option value="due_date">Vencimento</option>
                <option value="created_at">Criação</option>
              </select>
            </div>
            <div className="flex flex-col gap-1.5">
              <label
                htmlFor="order"
                className="text-xs font-medium text-gray-600"
              >
                Direção
              </label>
              <select
                id="order"
                className="appearance-none rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-sm text-gray-900 transition-all focus:border-avine-green focus:bg-white focus:outline-none focus:ring-2 focus:ring-avine-green/20"
                value={filters.order}
                onChange={(event) =>
                  onChange({
                    ...filters,
                    order: event.target.value as TaskFilters["order"],
                  })
                }
              >
                <option value="asc">Crescente</option>
                <option value="desc">Decrescente</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
