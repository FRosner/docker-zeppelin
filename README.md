# Docker Zeppelin

## Description

Docker image for starting [Apache Zeppelin](https://zeppelin.apache.org/).

## Usage

You can either start the image directly with Docker, or use the [Nomad-Docker-Wrapper](https://github.com/FRosner/nomad-docker-wrapper) if you are running your containers on Nomad.

```
docker run -p 8080:8080 \
  -e ZEPPELIN_SPARK_MASTER="local[*]" \
  -e ZEPPELIN_PASSWORD="secret" \
  -v $(pwd)/notebooks:/usr/local/zeppelin/notebooks \
  frosner/zeppelin
```

## Configuration

The docker image requires some environment variables to be set. They are used to configure your Zeppelin.

| Variable | Description |
| -------- | ----------- |
| `ZEPPELIN_SPARK_MASTER` | URL of the Spark master that Zeppelin should use. |
| `ZEPPELIN_PASSWORD` | Password to use for authenticating as `zeppelin` user. |
