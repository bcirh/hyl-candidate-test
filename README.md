# Hylastix Candidate Test
### Simple Architecture
```mermaid
graph  LR
  client([client])-.load balancer .->ingress[Traefik];
  ingress;
  subgraph Nomad
  ingress;
  ingress-->pod1[Keyclaoak];
  pod1-->pod3[Postgres];
  ingress-->pod2[Grafana];
  pod2-->pod1[Keycloak]
  pod4[duck-dns];
  end
  classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
  classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
  classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
  class ingress,service,pod1,pod2 k8s;
  class client plain;
  class cluster cluster;
```
#### Improvments
* Variable naming to better describe what variable is used for.
* Using valid domain instead of dynamic dns service
* Expanding configuration templates for Consul and Nomad
* Improving github actions to have clear separation of jobs, instead having only one job
* Expanding terraform code to deploy full cluster instead single node cluster
* Implement Azure availability zones with terraform
 
## Pre-requisites
* [ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)
* [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
* Azure Service Principal
* Azure Storage Account for storing state file

Ansible Role(s) Variables
--------------

| Name | Value | Description |
|---|---|---|
| consul_server | Default = false | Set VM to Consul server |
| data_center_name | Default = "dc1" | Data Center Name |
| enable_local_script_checks | Default = false | Enable script checks in Consul |
| bootstrap_expect |Default = 1 | Consul/Nomad how many servers to bootstrap |
| docker_sock_enabled | Default = false | Add docker socket readonly volume map in nomad configuration | 
| docker_privileged_mode | Default = false | Enable docker to run in privileged mode |
| nomad_ui_label_backgroung_color | Default = "purple" | Set label background color in Nomad UI | 
| nomad_ui_label_text_color | Default = "white" | Set label color in Nomad UI |
| psql_password | Default = "changeme" | Psql Server password **Please change the value for the deployment** |
| keycloak_admin_user | Default = "admin" | Set Keycloak admin user |
| keycloak_admin_password | Default = "changeme" | Set Keycloak admin user password |
| kc_grafana_client_roles | Default = ['admin','editor','viewer'] | Keycloak client roles for Grafana |
| kc_realm_name | Default = "grafana" | Keycloak realm name |
| kc_client_name | Default = "grafana-oauth" | Keycloak client name |
| kc_client_secret | Default = "dummy string" | Keycloak client secret |
| kc_url | Default = "hyl-keycloak" | Keycloak URL |
| grafana_url | Default = "hyl-grafana" | Grafana URL |
| kc_user_grafana_realm | Default = "" | Keycloak client dummy users with mapped client roles |
| duck_dns_token | Default = "dummy string" | Token for Duckdns to update ip of dns records |
| letsencrypt_email | Default = "dummy string" | Email to allow traefik to generate let's encrypt certificates |
| top_domain | Default = "duckdns.org" | Duckdns domain |
**Note:** If you want to override default values, please change values in the inventory file.

### Example inventory file
```
consul_server:
  hosts:
    hylvm:
      ansible_host: xxx.xxx.xxx.xxx
      ansible_user: adminuser
      data_center_name: dev
      consul_server: true
```
## Notes and Tips
* export ANSIBLE_HOST_KEY_CHECKING=False
* consul_server_ips Ansible variable will look for server group named **consul_server** in inventory file to fill proper IPs for retry_join stanza in Consul configuration
* This code example is heavily reliant on duckdns.org for dynamic dns features. If duckdns is not working this code example will not work. Since duckdns.org is free service **you get what you paid for**. "It's dns", meme goes here.
* Environment is ephemeral 
