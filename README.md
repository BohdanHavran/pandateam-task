# Panda Team Task

In this task, I automatically install Jenkins using Docker compose. In this task, Jenkins and DSL scripts played the role of creating a pipeline for a containerized Python application. Also, with the help of Docker compose, a monitoring system (Grafana + Prometheus) was configured to track the state of the server and the application container, and I used terraform to create the infrastructure for these tasks. If you don't have [Docker installed](https://docs.docker.com/engine/install/ubuntu/), you should install it<br> Elements that were used in this task:<br>
[Jenkins](#Jenkins) | [Grafana + Prometheus](#Grafana+Prometheus) | [Terraform](#Terraform)

# <a name="Jenkins">Jenkins</a>
URL: https://jenkins.dns.army/

![image](https://github.com/user-attachments/assets/e939a4b1-aed6-469b-885c-3e49eeb26071)

### Settings
Before starting Jenkins, you can use the [docker compose file](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/docker-compose.yml), where you can write the [configuration of Jenkins](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/casc.yaml) and [Jenkins plugins](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/plugins.txt)

Note: 

- It is advisable to change the admin password in the [Jenkins configuration](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/casc.yaml)
- All jobs were executed on Jenkins slave, how to configure it can be seen [here](https://codemyworld.hashnode.dev/setting-up-jenkins-agent-using-ssh)

To start Jenkins, just use the command:
```
docker compose up -d
```
And as a result we will get:
![image](https://github.com/user-attachments/assets/4427295d-cadd-486c-8a38-5ed996a1c031)

You can also configure webhooks to automatically run jobs if there are changes in the repository:
![image](https://github.com/user-attachments/assets/6e5dd676-580b-4c7a-8ed2-d5fc41958130)

### DSL

Now you need to configure the job that will run the [dsl-script](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/DSL_script.groovy)
![image](https://github.com/user-attachments/assets/168bafa0-8c08-4168-a9ae-6cf7c1ba1923)
![image](https://github.com/user-attachments/assets/07bada12-5f79-41c4-a5f5-d65187a5b711)
![image](https://github.com/user-attachments/assets/5df2af93-a139-4879-afb2-17cd992a9c20)

As a result of the execution of this job, the jobs described in [dsl-script](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/jenkins/DSL_script.groovy) will appear
![image](https://github.com/user-attachments/assets/2ff9d8b7-b119-4c7c-9dff-dea7f413c42a)

### Pipeline for a Python application
URL: https://flask.dns.army/

A [pipeline](https://github.com/BohdanHavran/pandateam-task/blob/master/flask.groovy) for a containerized Python application has been configured

Here is the output of the pipeline:
![image](https://github.com/user-attachments/assets/01dbe81c-7713-41cb-b64d-c961c05dcc57)
![image](https://github.com/user-attachments/assets/b366c475-9207-4922-b2b9-96ecf908339f)

There is also a notification of the status of the pipeline in [Telegram](https://t.me/panda_alert)
![image](https://github.com/user-attachments/assets/16051411-abd8-412a-9c79-b3fe36a21e89)

### Restart the container by command
![image](https://github.com/user-attachments/assets/d69d678c-c5c1-49aa-ba22-d2215d6bb25f)
![image](https://github.com/user-attachments/assets/615cd72f-d646-4cac-9a99-8765047a1e7c)

# <a name="Grafana+Prometheus">Grafana + Prometheus</a>
URL: https://grafana.dns.navy/
![image](https://github.com/user-attachments/assets/7ce7cd0c-cd3b-4bb7-b169-7953a4e2223b)

### Settings
Before starting Grafana + Prometheus, you can use the [docker compose file](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/grafana/docker-compose.yml)

Note: It is advisable to review the [Prometheus configuration](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/grafana/prometheus/config/prometheus.yml) and adjust it for yourself

To start Grafana + Prometheus, just use the command:
```
docker compose up -d
```
![image](https://github.com/user-attachments/assets/f10b4682-9c27-4b5f-81cc-5d8d745e2748)

Examples of monitoring visualization:
![image](https://github.com/user-attachments/assets/aafe4464-7303-4d4d-9e57-aad0b91ce8c5)

There are also configured alerts that are notified [Telegram](https://t.me/panda_alert)
![image](https://github.com/user-attachments/assets/8cf3102d-bbe5-41c6-adbc-e92f28af6de3)
![image](https://github.com/user-attachments/assets/143b2379-6c41-42d9-a4a1-6c83f40ad409)

For jenkins slave, you need to configure agents for monitoring, you can use the [docker compose file](https://github.com/BohdanHavran/pandateam-task/blob/infrastructure/monitoring_agent/docker-compose.yml)

# <a name="Terraform">Terraform</a>
If you don't have infrastructure yet, you can use my [terraform](https://github.com/BohdanHavran/pandateam-task/tree/infrastructure/terraform) to raise it in digitalocean

Note: Don't forget to create your token

In order to start working with the project, you need:
```
git clone --branch infrastructure https://github.com/BohdanHavran/pandateam-task.git
```
```
cd terraform
```
In order to run this project, you need to enter the following commands:
```
terraform init
```
```
terraform apply
```