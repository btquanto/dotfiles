function truncate_docker_logs() {
    sudo find /var/lib/docker/containers/ -type f -name '*-json.log' | xargs sudo truncate -s 0 {}
}