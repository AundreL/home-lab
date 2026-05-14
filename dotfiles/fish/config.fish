fish_vi_key_bindings

alias tree="tree -C"
alias reloadfish="source ~/.config/fish/config.fish"
alias tmux-pane-size="tmux display -p '#{pane_width}x#{pane_height}'"
alias end-dev="tmux kill-session -t dev-environment"
bind -M insert \co accept-autosuggestion

fastfetch

function start-dev -d "tmux session starting"
    set session_name dev-environment

    tmux has-session -t $session_name 2>/dev/null

    if test $status != 0
        # setup bottom row
        # clears remove the fastfetch message
        tmux new-session -d -s $session_name -x "$COLUMNS" -y "$LINES"
        tmux send-keys -t $session_name clear Enter

        tmux split-window -v -l 16 -t $session_name
        tmux send-keys -t $session_name clear Enter

        tmux select-pane -t $session_name:1.2
        tmux split-window -h -l 191 -t $session_name
        tmux send-keys -t $session_name clear Enter

        tmux select-pane -t $session_name:1.3
        tmux split-window -h -l 95 -t $session_name
        tmux send-keys -t $session_name clear Enter

        #setup top row
        tmux select-pane -t $session_name:1.1
        tmux split-window -h -l 75 -t $session_name

        tmux select-pane -t $session_name:1.1
        tmux send-keys -t $session_name nvim Enter
    end

    tmux attach-session -t $session_name
end
