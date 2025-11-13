using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TasksApi.Data;
using TasksApi.Dtos;
using TasksApi.Models;

namespace TasksApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TasksController : ControllerBase
    {
        private readonly AppDbContext _db;
        public TasksController(AppDbContext db) { _db = db; }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<TaskItem>>> GetAll(
            [FromQuery] string? status,
            [FromQuery] string? orderBy = "due_date",
            [FromQuery] string? order = "asc",
            [FromQuery] string? q = null)
        {
            IQueryable<TaskItem> query = _db.Tasks.AsNoTracking();

            if (!string.IsNullOrWhiteSpace(status))
                query = query.Where(t => t.Status == status);

            if (!string.IsNullOrWhiteSpace(q))
                query = query.Where(t => t.Title.Contains(q));

            query = orderBy switch
            {
                "created_at" => order == "desc" ? query.OrderByDescending(t => t.CreatedAtUtc) : query.OrderBy(t => t.CreatedAtUtc),
                _ => order == "desc" ? query.OrderByDescending(t => t.DueDateUtc) : query.OrderBy(t => t.DueDateUtc)
            };

            return Ok(await query.ToListAsync());
        }

        [HttpGet("{id:long}")]
        public async Task<ActionResult<TaskItem>> GetOne(long id)
        {
            var task = await _db.Tasks.FindAsync(id);
            return task is null ? NotFound(new { message = "Task not found" }) : Ok(task);
        }

        [HttpPost]
        public async Task<ActionResult<TaskItem>> Create(CreateTaskDto dto)
        {
            var task = new TaskItem
            {
                Title = dto.Title.Trim(),
                Description = dto.Description,
                DueDateUtc = dto.DueDateUtc,
                Status = "open"
            };
            _db.Tasks.Add(task);
            await _db.SaveChangesAsync();
            return CreatedAtAction(nameof(GetOne), new { id = task.Id }, task);
        }

        [HttpPut("{id:long}")]
        public async Task<ActionResult<TaskItem>> Update(long id, UpdateTaskDto dto)
        {
            var task = await _db.Tasks.FindAsync(id);
            if (task is null) return NotFound(new { message = "Task not found" });

            task.Title = dto.Title.Trim();
            task.Description = dto.Description;
            task.DueDateUtc = dto.DueDateUtc;
            if (!string.IsNullOrWhiteSpace(dto.Status))
            {
                if (dto.Status != "open" && dto.Status != "done")
                    return BadRequest(new { message = "Invalid status" });
                task.Status = dto.Status;
            }

            await _db.SaveChangesAsync();
            return Ok(task);
        }

        [HttpDelete("{id:long}")]
        public async Task<IActionResult> Delete(long id)
        {
            var task = await _db.Tasks.FindAsync(id);
            if (task is null) return NotFound(new { message = "Task not found" });

            _db.Tasks.Remove(task);
            await _db.SaveChangesAsync();
            return NoContent();
        }
    }
}
