{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
  };

  home.packages = with pkgs; [
    kitty swww rofi-wayland waybar mako
    hyprlock hypridle hyprshot wl-clipboard
    networkmanagerapplet pavucontrol blueman playerctl cava
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };
}