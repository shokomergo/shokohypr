use::std::process::{Command, Stdio};
use::std::io::Read;
use::urlencoding::encode;
use::serde_json::Value;

//noinspection RsUnresolvedMethod
fn main() {
    let _ = Command::new("pkill").arg("wofi").status().unwrap();
    let child = Command::new("wofi")
        .args(&[
            "--show", "dmenu",
            "--prompt", "",
            "--width", "450",
            "--height", "150",
            "--style", "/etc/nixos/shokohypr/wofi/style.css",
            "--clear-cache"
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

    let _ = child.wait_with_output();

    let query = query.trim();
    if query.is_empty() { return; }

    if query.contains("spotify") {
        let search = query.replace("spotify", "").trim().to_string();
        let url = format!("https://open.spotify.com/search/{}", encode(&search));
        let _ = Command::new("xdg-open").arg(url).spawn();
    }

    else if query.contains("youtube music") || query.contains("music.youtube") {

            let search = query
                .replace("youtube music", "")
                .replace("music.youtube", "")
                .trim()
                .to_string();
            let url = format!("https://music.youtube.com/search?q={}", encode(&search));
            let _ = Command::new("xdg-open").arg(url).spawn();
    }
    else {

    let url = format!("https://itunes.apple.com/search?term={}&limit=1&entity=song", encode(query));

        let response = reqwest::blocking::get(url);
        if let Ok(res) = response {
            if let Ok(json) = res.json::<Value>() {
                if let Some(track_url) = json["results"][0]["trackViewUrl"].as_str() {
                    let _ = Command::new("xdg-open").arg(track_url).spawn();
                }
            } else {
                let fallback = format!("https://music.apple.com/search?term={}", encode(query));
                let _ = Command::new("xdg-open").arg(fallback).spawn();
            }
        }
    }
}
