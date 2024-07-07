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

    match messages.last() {
        Some(last) => {
            /*
            status {
                0: en ruta
                1: fuera de servicio
                2: en descanso
                3: accidente
                4: apagado
            }
            */
            let is_off = last.sts == 1 || last.sts == 2 || last.sts == 3;

            // If the burrito didn't report itself as 1,2 or 3 and it hasn't reported in the last 30 seconds,
            // then we consider it as off
            if !is_off && last.timestamp.unwrap().elapsed().unwrap() > std::time::Duration::from_secs(30) {
                // We create an 'off' message on the fly
                let off_message = Message {
                    lt: 0.0,
                    lg: 0.0,
                    tmp: 0.0,
                    hum: 0.0,
                    sts: 4, // 4 means OFF
                    timestamp: Some(SystemTime::now()),
                    velocity: 0.0,
                };
                let mut messages_cpy = messages.clone();
                messages_cpy.push(off_message);
                return Ok(json!({
                    "positions": messages_cpy.iter().rev().take(n).cloned().collect::<Vec<Message>>(),
                }));
            }
        },
        None => {},
    }

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
