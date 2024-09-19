# k3s-proxmox-automation

## Overview
This project provides the capability to quickly setup a highly-available (HA) K3S cluster with Proxmox. The general architecture can be seen below:

```mermaid
%%{
  init: {
    'theme': 'dark',
    'themeVariables': {
      'primaryColor': '#BB2528'
    }
  }
}%%

architecture-beta
    service internet(internet)[API and Web Traffic]

    group k3s_cluster[K3S Cluster]

    group supporting_infra[Supporting Infra]
    service nginx(server)[Nginx] in supporting_infra
    service postgres(database)[Postgres as K3S datastore] in supporting_infra

    group control_plan_nodes[Control Plane Nodes] in k3s_cluster
    service hive01(server)[hive01] in control_plan_nodes
    service hive02(server)[hive02] in control_plan_nodes
    service hive03(server)[hive03] in control_plan_nodes

    group worker_nodes[Worker Nodes] in k3s_cluster
    service drone01(server)[drone01] in worker_nodes
    service drone02(server)[drone02] in worker_nodes
    service drone03(server)[drone03] in worker_nodes

    group storage_nodes[Storage Nodes] in k3s_cluster
    service storage01(server)[storage01] in storage_nodes
    service storage02(server)[storage02] in storage_nodes
    service storage03(server)[storage03] in storage_nodes

    nginx{group}:B <--> T:hive01{group}

    storage01:L <--> R:storage02
    storage02:L <--> R:storage03
    storage01:L <--> R:storage03

    drone01:L <--> R:drone02
    drone02:L <--> R:drone03
    drone01:L <--> R:drone03

    hive02:L <--> R:hive03
    hive01:L <--> R:hive02
    hive01:L <--> R:hive03

    internet:R --> L:nginx
```

It uses various methods and tools to achieve this automation. Some of them are listed below:
- Terraform
- Ansible
- Cloud Init

More information coming soon...
