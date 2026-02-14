{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "bottom";
      height = 30;
      margin-bottom = 10;
      margin-left = 20;
      margin-right = 20;
      spacing = 0;
      
      modules-left = [ ]; 
      modules-center = [ "clock" ];
      modules-right = [ "backlight" "network" "bluetooth" "pulseaudio" ];

      "clock" = { 
        format = " {:%H:%M}"; 
      };

      "backlight" = {
        "device" = "nvidia_0";
        "format" = "{icon} {percent}%";
        "format-icons" = ["󰃞" "󰃟" "󰃠"];
        "on-scroll-up" = "brightnessctl set 5%+";
        "on-scroll-down" = "brightnessctl set 5%-";
      };

      "pulseaudio" = { 
        format = "{icon} {volume}%"; 
        format-icons = { default = [ "" "" "" ]; }; 
        on-click = "pavucontrol";
      };

      "network" = { 
        format-wifi = ""; 
        format-ethernet = "󰈀";
        on-click = "kitty --title 'Network Manager' nmtui";
      };

      "bluetooth" = { 
        format = ""; 
        on-click = "blueman-manager";
      };
    }];

    style = ''
      * { 
        border: none; 
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free"; 
        font-size: 13px;
      }

      window#waybar {
        background: transparent;
      }

      .modules-center,
      .modules-right {
        background: rgba(0, 0, 0, 0.95);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 10px;
        color: #ffffff;
        padding: 0 5px;
      }

      #backlight, #network, #bluetooth, #pulseaudio, #clock {
        padding: 0 8px;
        color: #ffffff;
      }
    '';
  };
}