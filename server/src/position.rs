use std::time::SystemTime;
use rocket::serde::json::{json, Value};
use rocket::http::Status;
use rocket::serde::json::Json;
use rocket::{Route, State};

use crate::PositionState;
use crate::Message;
use crate::velocity::calculate_velocity;

pub fn routes() -> Vec<Route> {
    routes![get_position, give_position, handle_options_request]
}

#[get("/get-position/<count>")]
fn get_position(count: usize, state: &State<PositionState>) -> Result<Value, Status> {
    let messages = state.messages.lock().unwrap();
    if messages.is_empty() {
        return Err(Status::InternalServerError);
    }
    
    let n = std::cmp::min(count, messages.len());

    let recent_messages: Vec<Message> = messages.iter().rev().take(n).cloned().collect();
    Ok(json!({
        "positions": recent_messages,
    }))
}

#[post("/give-position", format = "json", data = "<message_json>")]
fn give_position(message_json: Json<Message>, state: &State<PositionState>) -> Status {
    let mut messages = state.messages.lock().unwrap();
    let mut message = message_json.into_inner();
    message.timestamp = Some(SystemTime::now()); // Add the current timestamp
    message.velocity = calculate_velocity(&messages);

    messages.push(message);
    if messages.len() > 100 {
        messages.remove(0); // Keep only the latest 100 positions
    }
    Status::Ok
}

#[options("/give-position")]
fn handle_options_request() -> Status {
    Status::NoContent
}
