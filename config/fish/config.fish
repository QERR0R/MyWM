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

# For Git Commit by PGP
set -x GPG_TTY (tty)
