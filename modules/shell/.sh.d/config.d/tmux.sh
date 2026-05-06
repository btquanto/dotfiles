function mux() {
    session=${1:-$USER}

    if tmux has -t $session 2>/dev/null; then
        tmux attach -t $session
    else
        tmux new -s $session
    fi
}