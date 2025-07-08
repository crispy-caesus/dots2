if status is-interactive
    # Commands to run in interactive sessions can go here

    # tmux a

    if uwsm check may-start && uwsm select
        exec uwsm start default
    end

    set -gx PATH $PATH ~/.local/bin/ ~/go/bin
    set -Ux EDITOR nvim

    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

    alias ...='cd ../..'

    source ~/.config/fish/functions/bindings.fish

    set -U tide_right_promt_items
    set CHROOT $HOME/chroot
    # ===================== theme ================ #
    fish_config theme choose "Rosé Pine"

    set -U hydro_color_pwd $fish_color_pine
    set -U hydro_color_git $fish_color_foam
    set -U hydro_color_start $fish_color_iris
    set -U hydro_color_error $fish_color_love
    set -U hydro_color_prompt $fish_color_pine
    set -U hydro_color_duration $fish_color_iris
    set -U fish_prompt_pwd_dir_length 0
    set -g fish_color_search_match
    set -g fish_pager_color_background
    set -g fish_pager_color_selected_background

end

set fish_greeting ""
