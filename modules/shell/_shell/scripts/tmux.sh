function mux() {
    if [ $# -eq 0 ]
    then
        session=$USER
    else
        session=$1
    fi
    (tmux has -t $session && tmux attach -t $session) || tmux new -s $session;
}