{ pkgs, ... }:

{
  home.packages = let
    waybar-toggle = pkgs.writeShellScriptBin "waybar-toggle" ''
      if pgrep -x "waybar" > /dev/null; then
        pkill -x waybar
        while pgrep -x "waybar" > /dev/null; do sleep 0.1; done
      else
        ${pkgs.waybar}/bin/waybar > /dev/null 2>&1 &
      fi
    '';

    wp-switch = pkgs.writeShellScriptBin "wp-switch" ''
      STATE_FILE="/tmp/wp_state"
      [ ! -f "$STATE_FILE" ] && echo "1" > "$STATE_FILE"
      STATE=$(cat "$STATE_FILE")
      TRANS_ARGS="--transition-type grow --transition-pos center --transition-duration 2.5 --transition-fps 144 --transition-step 10 --transition-bezier .13,.99,.24,1"

      if [ "$STATE" == "1" ]; then
          ${pkgs.swww}/bin/swww img "/home/shoko/Downloads/585179.png" $TRANS_ARGS
          echo "2" > "$STATE_FILE"
      else
          ${pkgs.swww}/bin/swww img "/home/shoko/Downloads/wallhaven-nr8m8j.jpg" $TRANS_ARGS
          echo "1" > "$STATE_FILE"
      fi
    '';
  in [ waybar-toggle wp-switch ];
}