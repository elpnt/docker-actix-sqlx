## Create development environment in Docker

```sh
# Run local database
docker-compose up -d db

# Database migration
sqlx migrate add create_todo_table
editor migrations/<ADDED_DATE>_create_todo_table.sql
sqlx migrate run

# Generate `sqlx-data.json` to compile `sqlx::query!()` macro
cargo sqlx prepare -- --bin server

# Run API server
docker-compose up --build
```

## How sqlx works

**On Host**

Read `DATABASE_URL` in `.env`

**On Docker API server**

Read `DATABSE_URL` defined as `app: environment` in `docker-compose.yml`,
pointing to bridged postgres server
