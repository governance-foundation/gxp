# Docker Logging

source: https://grafana.com/docs/loki/latest/clients/docker-driver/

## Loki Logging Driver

### Check if installed

```bash
docker plugin ls
```

### Install

```bash
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```

### Update

```bash
docker plugin disable loki --force
docker plugin upgrade loki grafana/loki-docker-driver:latest --grant-all-permissions
docker plugin enable loki
systemctl restart docker
```

### Update

```bash
docker plugin disable loki --force
docker plugin rm loki
```
