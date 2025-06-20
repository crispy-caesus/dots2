if status is-interactive
    # Commands to run in interactive sessions can go here

    # tmux a

    # fastfetch
    #starship init fish | source

    # tide configure --auto --style=Classic --prompt_colors='16 colors' --show_time=No --classic_prompt_separators=Angled --powerline_prompt_heads=Slanted --powerline_prompt_tails=Slanted --powerline_prompt_style='Two lines, frame' --prompt_connection=Disconnected --powerline_right_prompt_frame=Yes --prompt_spacing=Compact --icons='Few icons' --transient=No



    if uwsm check may-start && uwsm select
        exec uwsm start default
    end


    set -gx PATH $PATH ~/.local/bin/ ~/go/bin
    set -Ux EDITOR nvim

    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

    source ~/.config/fish/functions/bindings.fish

    set -U tide_right_promt_items
end

set fish_greeting ""
