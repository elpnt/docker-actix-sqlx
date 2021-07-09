-- Add migration script here
CREATE TYPE STATUS AS ENUM ('todo', 'doing', 'done');

CREATE TABLE IF NOT EXISTS todo (
    id         SERIAL PRIMARY KEY,
    title      VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status     STATUS NOT NULL DEFAULT 'todo'
);

INSERT INTO todo (title, status)
VALUES
    ('Wake up at 6 AM', 'todo'),
    ('Walk a dog', 'todo'),
    ('Buy milk', 'doing'),
    ('Code review', 'done');
