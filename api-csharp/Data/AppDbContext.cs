using Microsoft.EntityFrameworkCore;
using TasksApi.Models;

namespace TasksApi.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> opts) : base(opts) {}
        public DbSet<TaskItem> Tasks => Set<TaskItem>();

        public override int SaveChanges()
        {
            foreach (var e in ChangeTracker.Entries<TaskItem>())
            {
                if (e.State == EntityState.Modified) e.Entity.UpdatedAtUtc = DateTime.UtcNow;
            }
            return base.SaveChanges();
        }
        public override async Task<int> SaveChangesAsync(CancellationToken ct = default)
        {
            foreach (var e in ChangeTracker.Entries<TaskItem>())
            {
                if (e.State == EntityState.Modified) e.Entity.UpdatedAtUtc = DateTime.UtcNow;
            }
            return await base.SaveChangesAsync(ct);
        }
    }
}
