use axum::{extract::Query, routing::get, Json, Router};
use serde_json::{json, Value};
use std::collections::HashMap;

async fn hello(Query(q): Query<HashMap<String, String>>) -> Json<Value> {
    let name = q
        .get("name")
        .map(|n| n.trim())
        .filter(|n| !n.is_empty())
        .unwrap_or("world");
    Json(json!({ "message": format!("Hello, {name}, from Rust 🦀") }))
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/api/hello", get(hello));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();
    println!("listening on :8080");
    axum::serve(listener, app).await.unwrap();
}
