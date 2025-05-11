#!/bin/bash
apt-get update
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

mkdir -p /var/log/ecs /var/lib/ecs/data

docker run --name ecs-agent \
  --detach \
  --restart=on-failure:10 \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --volume=/var/log/ecs/:/log \
  --volume=/var/lib/ecs/data:/data \
  --net=host \
  --env ECS_CLUSTER=petclinic-cluster \
  amazon/amazon-ecs-agent:latest
