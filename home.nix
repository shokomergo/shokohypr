{ pkgs, ... }:

{
  imports = [
    ./scripts.nix
    ./waybar.nix
  ];

  home.username = "shoko";
  home.homeDirectory = "/home/shoko";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [ 
    pavucontrol blueman networkmanagerapplet wlogout brightnessctl
    playerctl cava libnotify firefox-devedition-bin
    font-awesome nerdfonts papirus-icon-theme
    kdePackages.dolphin swww grim slurp grimblast
  ];

  home.file.".bashrc".text = ''
    export PS1="\[\e[38;5;255m\]\u\[\e[m\]@\[\e[38;5;250m\]\h\[\e[m\]:\[\e[38;5;240m\]\w\[\e[m\]\$ "
  '';
  
  gtk = {
    enable = true;
    theme = { name = "Adwaita-dark"; package = pkgs.gnome-themes-extra; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.90";
      background = "#000000";
      foreground = "#ffffff";
      cursor = "#ffffff";
      confirm_os_window_close = 0;
      remember_window_size = "no";
      initial_window_width = "600";
      initial_window_height = "400";
    };
    extraConfig = ''
      color0 #000000
      color8 #333333
      color1 #ffffff
      color9 #ffffff
      color2 #eeeeee
      color10 #eeeeee
      color3 #dddddd
      color11 #dddddd
      color4 #cccccc
      color12 #cccccc
      color5 #bbbbbb
      color13 #bbbbbb
      color6 #aaaaaa
      color14 #aaaaaa
      color7 #ffffff
      color15 #ffffff
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      xwayland.force_zero_scaling = true;
      input = { 
        kb_layout = "tr"; 
        follow_mouse = 1; 
      };
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(ffffffff) rgba(000000ff) 45deg";
        "col.inactive_border" = "rgba(1a1a1aff)";
        layout = "dwindle";
      };
      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 0.85;
        blur = { enabled = true; size = 8; passes = 3; ignore_opacity = true; };
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(000000ff)";
        };
      };
      windowrulev2 = [
        "float, class:(shokomusic-finder-rs)"
        "focusonactivate, class:(shokomusic-finder-rs)"
        "float, class:(wofi)"
        "stayfocused, class:(wofi)"
        "float, class:(pavucontrol|blueman-manager|nm-connection-editor)"
        "center, class:(pavucontrol|blueman-manager)"
        "fullscreen, class:^steam_app_"
      ];
      bind = [
        "SUPER, Return, exec, kitty"
        "SUPER, Q, killactive,"
        "SUPER, F10, fullscreen, 0"
        "SUPER, X, exec, pkill waybar || waybar"
        "SUPER, M, exec, pkill -KILL -u $USER" 
        "SUPER, F, exec, firefox-dev-custom"
        "SUPER, D, exec, dolphin"
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        "SUPER, A, exec, /etc/nixos/shokohypr/modules/shokomusic-finder-rs/target/release/shokomusic-finder-rs"
        ", F12, exec, grimblast --notify save screen ~/Pictures/$(date +%Y-%m-%d_%H-%M-%S).png"
        "SHIFT, F12, exec, grimblast --notify save area ~/Pictures/$(date +%Y-%m-%d_%H-%M-%S).png"
      ];
      exec-once = [ 
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "swww-daemon"
        "sleep 1 && swww /etc/nixos/shokohypr/shokowall/oshino_ougi.png"
        "waybar &" 
        "nm-applet --indicator"
      ];
    };
  };
}