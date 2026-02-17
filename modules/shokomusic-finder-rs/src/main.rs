use::std::process::{Command, Stdio};
use::std::io::Read;
use::urlencoding::encode;
use::serde_json::Value;

//noinspection RsUnresolvedMethod
fn main() {
    let child = Command::new("wofi")
    .args(&[
        "--show", "dmenu",
        "--prompt", "",
        "--width", "450",
        "--height", "150",
        "--style", "/etc/nixos/shokohypr/wofi/style.css"
    ])
        .stdout(Stdio::piped())
        .spawn();

    let mut child = match child {
        Ok(c) => c,
        Err(_) => {
            return;
        }
    };

    let mut query = String::new();
    if let Some(mut stdout) = child.stdout.take() {
        let _ = stdout.read_to_string(&mut query);
    }
    let query = query.trim();
    if query.is_empty(){ return; }

    let url = format!("https://itunes.apple.com/search?term={}&limit=1&entity=song", encode(query));

    let response = reqwest::blocking::get(url);
    if let Ok(res) = response {
        if let Ok(json) = res.json::<Value>(){
            if let Some(track_url) = json["results"][0]["trackViewUrl"].as_str() {
                let _ = Command::new("xdg-open").arg(track_url).spawn();}
        }else {
            let fallback = format!("https://music.apple.com/search?term={}", encode(query));
            let _ = Command::new("xdg-open").arg(fallback).spawn();
        }
    }
}
