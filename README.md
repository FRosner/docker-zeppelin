# Docker Zeppelin

[![Build Status](https://travis-ci.org/Data-Science-Platform/docker-zeppelin.svg?branch=master)](https://travis-ci.org/Data-Science-Platform/docker-zeppelin)
[![Docker Pulls](https://img.shields.io/docker/pulls/datascienceplatform/zeppelind.svg?maxAge=2592000)](https://hub.docker.com/r/datascienceplatform/zeppelind/)
[![Image Size](https://images.microbadger.com/badges/image/data-science-platform/zeppelind.svg)](https://microbadger.com/images/datascienceplatform/zeppelind "Get your own image badge on microbadger.com")

## Description

Docker image for starting [Apache Zeppelin](https://zeppelin.apache.org/).

## Usage

You can either start the image directly with Docker, or use the [Nomad-Docker-Wrapper](https://github.com/Data-Science-Platform/nomad-docker-wrapper) if you are running your containers on Nomad.

```
docker run -p 8080:8080 \
  -e ZEPPELIN_SPARK_MASTER="local[*]" \
  -e ZEPPELIN_PASSWORD="secret" \
  -e ZEPPELIN_NOTEBOOK_STORAGE=org.apache.zeppelin.notebook.repo.VFSNotebookRepo \
  -e ZEPPELIN_PROCESS_USER_NAME="zeppelinu" \
  -e ZEPPELIN_PROCESS_USER_ID=12345 \
  -e ZEPPELIN_PROCESS_GROUP_NAME="zeppeling" \
  -e ZEPPELIN_PROCESS_GROUP_ID=12340 \
  -e ZEPPELIN_SERVER_PORT=8080 \
  -e ZEPPELIN_SPARK_DRIVER_MEMORY="512M" \
  -e ZEPPELIN_SPARK_UI_PORT=4040 \
  -e ZEPPELIN_PYSPARK_PYTHON=/usr/bin/python \
  -e ZEPPELIN_MEM="-Xms1024m -Xmx1024m -XX:MaxPermSize=512m" \
  -v $(pwd)/notebooks:/usr/local/zeppelin/notebooks \
  -v $(pwd)/conf:/usr/local/zeppelin/conf \
  -v $(pwd)/hive:/hive \
  datascienceplatform/zeppelind:latest-zv0.6.2-s2.0.2-h2.7
```

## Configuration

The docker image requires some environment variables to be set. They are used to configure your Zeppelin.

| Variable | Description |
| -------- | ----------- |
| `ZEPPELIN_SPARK_MASTER` | URL of the Spark master that Zeppelin should use. |
| `ZEPPELIN_PASSWORD` | Password to use for authenticating as `zeppelin` user on the UI. |
| `ZEPPELIN_NOTEBOOK_STORAGE` | [Notebook storage](https://zeppelin.apache.org/docs/0.6.0/storage/storage.html) to use. |
| `ZEPPELIN_PROCESS_USER_NAME` | User name to execute the Zeppelin process as. |
| `ZEPPELIN_PROCESS_USER_ID` | User ID to execute the Zeppelin process as. |
| `ZEPPELIN_PROCESS_GROUP_NAME` | Group name to assign to the Zeppelin user. |
| `ZEPPELIN_PROCESS_GROUP_ID` | Group ID to assign to the Zeppelin user. |
| `ZEPPELIN_SERVER_PORT` | Port to bind the Zeppelin server to. |
| `ZEPPELIN_SPARK_UI_PORT` | Port to use for the Spark UI. |
| `ZEPPELIN_SPARK_DRIVER_MEMORY` | Amount of memory to allocate to the Spark driver process (e.g. `512M`). |
| `ZEPPELIN_PYSPARK_PYTHON` | Path to python executable for the Spark worker nodes. |
| `ZEPPELIN_MEM` | Zeppelin JVM Options |

## Travis CI/CD

These environment variables should be defined and set appropriately in your Travis CI Settings.
https://travis-ci.org/<your travis account name>/docker-zeppelin/settings

| Variable | Description |
| -------- | ----------- |
| `DOCKER_USER` | Your docker ID |
| `DOCKER_PASSWORD` | Password for your docker ID (make sure "display value in build log" is disabled for this env var)|
| `DOCKER_NAMESPACE` | Docker namespace, where the image(s) should be pushed; usually equals to DOCKER_USER; if empty, then "datascienceplatform" (that can lead to permission issues while pushing) |

## SQL Database Support

SQL databases are supported trough [SQLAlchemy](https://docs.sqlalchemy.org/en/latest/) (a python package  with a comprehensive set of tools for working with databases). This container includes the following [dialects](https://docs.sqlalchemy.org/en/latest/dialects/):

| Dialect | Target DB |
| ------- | --------- |
| `pymssql` | Microsoft SQL Server |
| `psycopg2` | PostgreSQL |
| `cx_Oracle` | Oracle |

Support for additional databases can be added by installing additional [dialects](https://docs.sqlalchemy.org/en/latest/dialects/) into an anaconda environment and setting `ZEPPELIN_PYSPARK_PYTHON` to the environment location.

###  Microsoft SQL Server Example

```
%spark.pyspark
import sqlalchemy
from sqlalchemy import create_engine
conn_str = "mssql+pymssql://<User>:<Password>@<Host>:<Port>"
engine = create_engine(conn_str)
# List All DBs
res = engine.execute('SELECT * FROM master.sys.databases')
for row in res:
    print row
```

###  PostgreSQL Example

```
%spark.pyspark
import sqlalchemy
from sqlalchemy import create_engine
conn_str = "postgresql+psycopg2:///<User>:<Password>@<Host>:<Port>"
engine = create_engine(conn_str)
# List All DBs
res = engine.execute('SELECT * FROM pg_database')
for row in res:
    print row
```

###  Oracle Example

```
%spark.pyspark
import sqlalchemy
from sqlalchemy import create_engine
conn_str = "oracle+cx_oracle:///<User>:<Password>@<Host>:<Port>/<db>"
engine = create_engine(conn_str)
res = engine.execute('SELECT * FROM my_table')
for row in res:
    print row
```
