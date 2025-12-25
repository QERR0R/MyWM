if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

function set_wallpaper
    set path $argv[1]
    wal -n -i $path
    feh --bg-scale $path
    python3 /home/quantum/.config/suckless/colors.py
    sh /home/quantum/.config/suckless/pywal.sh
end

alias screen-single='xrandr --output HDMI1 --off'
alias screen-duplicate='xrandr --output HDMI1 --auto --same-as eDP1'
alias screen-extend='xrandr --output HDMI1 --auto --right-of eDP1'
