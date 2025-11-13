const dateFormatter = new Intl.DateTimeFormat("pt-BR", {
  dateStyle: "short",
  timeStyle: "short",
  timeZone: "UTC",
});

export function formatUtcDate(iso?: string | null) {
  if (!iso) return "Sem data";
  return dateFormatter.format(new Date(iso));
}

export function toUtcInputValue(iso?: string | null) {
  if (!iso) return "";
  return new Date(iso).toISOString().slice(0, 16);
}

export function fromUtcInputValue(value: string) {
  if (!value) return null;
  const withSeconds = value.length === 16 ? `${value}:00` : value;
  const isoValue = withSeconds.endsWith("Z") ? withSeconds : `${withSeconds}Z`;
  const date = new Date(isoValue);
  return Number.isNaN(date.getTime()) ? null : date.toISOString();
}
