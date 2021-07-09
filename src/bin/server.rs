use std::env;

use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use dotenv::dotenv;
use sqlx::{Connection, PgConnection};

#[derive(sqlx::Type)]
#[sqlx(rename = "status", rename_all = "lowercase")]
enum Status {
    Todo,
    Doing,
    Done,
}

#[get("/")]
async fn index() -> impl Responder {
    HttpResponse::Ok().body(r#"
<html>
  <title>Hello from docker!</title>
  <body>
    <h1>Hello World</h1>
    <p>Actix + SQLx in Docker</p>
  </body>
</html>"#)
}

#[actix_web::main]
async fn main() -> std::io::Result<()>{
    println!("Start server");
    dotenv().ok();

    let db_url = env::var("DATABASE_URL").expect("Cannot find 'DATABASE_URL' in .env");
    let mut conn = PgConnection::connect(&db_url)
        .await
        .expect("Failed to connect to the database");

    // Test to `query!` macro can be used at compilation time in Docker
    sqlx::query!(
        "INSERT INTO todo (title, status) VALUES ($1, $2)",
        "Read a book",
        Status::Todo as Status
    )
    .execute(&mut conn)
    .await
    .expect("Failed to query");

    HttpServer::new(|| {
        App::new().service(index)
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}
