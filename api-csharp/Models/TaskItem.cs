using System;
using System.ComponentModel.DataAnnotations;

namespace TasksApi.Models
{
    public class TaskItem
    {
        public long Id { get; set; }

        [Required, MaxLength(200)]
        public string Title { get; set; } = string.Empty;

        public string? Description { get; set; }

        public DateTime? DueDateUtc { get; set; }

        [Required]
        public string Status { get; set; } = "open";

        public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;

        public DateTime UpdatedAtUtc { get; set; } = DateTime.UtcNow;
    }
}
