if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Removes deafult fish greeting banner.
set fish_greeting


# running pywal with color.py script that will prepare the .Xresources that will be used by dwm for changing a color in realtime.
function set_wallpaper
    set path $argv[1]
    wal -n -i $path
    feh --bg-scale $path
    python3 /home/quantum/.config/suckless/colors.py
    sh /home/quantum/.config/suckless/pywal.sh
end

# For Git Commit by PGP
set -x GPG_TTY (tty)
