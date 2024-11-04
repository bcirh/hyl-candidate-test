service {
  name = "consul-ui"
  port = 8500
  tags = ["traefik.enable=true", "traefik.http.routers.consul-ui.entrypoints=https", "traefik.http.routers.consul-ui.tls.certresolver=letsencrypt", "traefik.http.routers.consul-ui.rule=Host(`{{ consul_url }}.{{ top_domain }}`)"]
          
  check = {
    id = "tcp"
    name = "TCP on port 8500"
    tcp = "localhost:8500"
    interval = "10s"
    timeout = "5s"
  }
}