# Docker Zeppelin

[![Docker Pulls](https://img.shields.io/docker/pulls/frosner/zeppelin.svg?maxAge=2592000)](https://hub.docker.com/r/frosner/zeppelin/)

## Description

Docker image for starting [Apache Zeppelin](https://zeppelin.apache.org/).

## Usage

You can either start the image directly with Docker, or use the [Nomad-Docker-Wrapper](https://github.com/FRosner/nomad-docker-wrapper) if you are running your containers on Nomad.

```
docker run -p 8080:8080 \
  -e ZEPPELIN_SPARK_MASTER="local[*]" \
  -e ZEPPELIN_PASSWORD="secret" \
  -e ZEPPELIN_PROCESS_USER_NAME="zeppelinu" \
  -e ZEPPELIN_PROCESS_USER_ID=12345 \
  -e ZEPPELIN_PROCESS_GROUP_NAME="zeppeling" \
  -e ZEPPELIN_PROCESS_GROUP_ID=12340 \
  -e ZEPPELIN_SERVER_PORT=8080 \
  -e ZEPPELIN_SPARK_DRIVER_MEMORY="512M" \
  -v $(pwd)/notebooks:/usr/local/zeppelin/notebooks \
  -v $(pwd)/conf:/usr/local/zeppelin/conf \
  -v $(pwd)/hive:/hive \
  frosner/zeppelin
```

## Configuration

The docker image requires some environment variables to be set. They are used to configure your Zeppelin.

| Variable | Description |
| -------- | ----------- |
| `ZEPPELIN_SPARK_MASTER` | URL of the Spark master that Zeppelin should use. |
| `ZEPPELIN_PASSWORD` | Password to use for authenticating as `zeppelin` user on the UI. |
| `ZEPPELIN_PROCESS_USER_NAME` | User name to execute the Zeppelin process as. |
| `ZEPPELIN_PROCESS_USER_ID` | User ID to execute the Zeppelin process as. |
| `ZEPPELIN_PROCESS_GROUP_NAME` | Group name to assign to the Zeppelin user. |
| `ZEPPELIN_PROCESS_GROUP_ID` | Group ID to assign to the Zeppelin user. |
| `ZEPPELIN_SERVER_PORT` | Port to bind the Zeppelin server to |
| `ZEPPELIN_SPARK_DRIVER_MEMORY` | Amount of memory to allocate to the Spark driver process (e.g. `512M`) |
