# Panda Team Task

In this task, I automatically install Jenkins using Docker compose. In this task, Jenkins and DSL scripts played the role of creating a pipeline for a containerized Python application. Also, with the help of Docker compose, a monitoring system (Grafana + Prometheus) was configured to track the state of the server and the application container, and I used terraform to create the infrastructure for these tasks. If you don't have [Docker installed](https://docs.docker.com/engine/install/ubuntu/), you should install it<br> Elements that were used in this task:<br>
[Jenkins](#Jenkins) | [Grafana + Prometheus](#Grafana+Prometheus) | [Terraform](#Terraform)

# <a name="Jenkins">Jenkins</a>
Url: https://jenkins.dns.army/

![image](https://github.com/user-attachments/assets/e939a4b1-aed6-469b-885c-3e49eeb26071)

### Settings
Before starting Jenkins, you can use the [docker compose file](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/docker-compose.yml), where you can write the [configuration of Jenkins](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/casc.yaml) and [Jenkins plugins](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/plugins.txt)

Note: It is advisable to change the admin password in the [Jenkins configuration](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/casc.yaml)

To start Jenkins, just use the command:
```
docker compose up -d
```
And as a result we will get
![image](https://github.com/user-attachments/assets/78ff717f-49d8-4963-8b84-09104264dbe5)

# <a name="Grafana+Prometheus">Grafana + Prometheus</a>

# <a name="Terraform">Terraform</a>