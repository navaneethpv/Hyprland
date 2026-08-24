if status is-interactive
    # Commands to run in interactive sessions can go here
end

fastfetch
echo

function fish_prompt
    set_color cba6f7
    echo -n $USER'@'$hostname' '
    echo -n (prompt_pwd)
    set_color normal
    echo -n ' > '
end
