CREATE TABLE IF NOT EXISTS tasks (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    done INTEGER NOT NULL DEFAULT 0,
    list_task TEXT NOT NULL CHECK (list_task IN ('today', 'earlier', 'custom')),
    list_name TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_task_list ON task(list_task);
CREATE INDEX IF NOT EXISTS idx_task_done ON task(done);
