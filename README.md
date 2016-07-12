# Docker Zeppelin

## Description

Docker image and Nomad wrapper for starting [Apache Zeppelin](https://zeppelin.apache.org/).

## Usage

You can add the docker wrapper to your Nomad job definition as an artifact. Then you can use it in your command.

```
artifact {
  source = "https://raw.githubusercontent.com/FRosner/docker-zeppelin/master/zeppelin-docker-wrapper"
}

config {
  command = "zeppelin-docker-wrapper"
}
```

It also needs a port called "ui" to be configured in Nomad.

```
resources {
  network {
    mbits = 10
    port "ui" {}
  }
}
```

## Configuration

The docker wrapper requires some environment variables to be set in the `env` section of your Nomad job definition.
They are used to configure your Zeppelin.

| Variable | Description |
| -------- | ----------- |
| `ZEPPELIN_CONTAINER_NAME` | Name of the docker container that the wrapper will use to reference it. |
| `ZEPPELIN_NOTEBOOK_MOUNT` | Mount point on the docker host where Zeppelin will store / look for notebooks. |
| `ZEPPELIN_SPARK_MASTER` | URL of the Spark master that Zeppelin should use. |
| `ZEPPELIN_PASSWORD` | Password to use for authenticating as `zeppelin` user. |
