# Log proxy with OceanBase mini-local cluster

The Dockerfile and scripts used to start a Docker container which contains [oceanbase](https://github.com/oceanbase/oceanbase) using [mini-local](https://github.com/oceanbase/obdeploy/blob/master/example/mini-local-example.yaml) config and [oblogproxy](https://github.com/oceanbase/oblogproxy).

## How to use

### Requirements

The OceanBase CE requires at least 2g8g to bootstrap, so please make sure that there are enough resource on your machine and the resource limit of Docker is suitable.

### Build the docker image

Build the Docker image under the directory where the Dockerfile located:

```shell
docker build -t ${image_repo:tag} .
```

#### Docker build args

| Name                 | Default | Description                  |
|----------------------|---------|------------------------------|
| OB_VERSION           | `3.1.1` | The version of `oceanbase`.  |
| OB_LOG_PROXY_VERSION | `1.0.0` | The version of `oblogproxy`. |

### Start the Docker container

OceanBase standalone uses ports `2881` and `2882` for MySQL connection and rpc , and `oblogproxy` serves `2983` port to communicate with client.

To query the snapshot and log data, you should expose ports `2881` and `2983`. For example

```shell
docker run --name ${container_name} -p 2881:2881 -p 2983:2983 -d ${image_repo:tag}
```

You can also use `host` network to bind all ports to host machine.

```shell
docker run --name ${container_name} --net=host -d ${image_repo:tag}
```

Note: `host` network is only supported on Linux.

#### Environment variables

| Name             | Default    | Description                                                            |
|------------------|------------|------------------------------------------------------------------------|
| OB_HOME_PATH     | `/root/ob` | The home path for an OceanBase server.                                 |
| OB_ROOT_PASSWORD | `pswd`     | The password of `root` user in `sys` tenant, must not be empty string. |
| OB_CLUSTER_NAME  | `mini-ce`  | The cluster name used by `obdeploy`                                    |

### Test with client

You can use any client for MySQL 5.6 or 5.7 to connect to the OceanBase server on port 2881, and [oblogclient](https://github.com/oceanbase/oblogclient) for log proxy on 2983. Here is an example for configuration:

##### jdbc

- driver: `com.mysql.jdbc.Driver`
- url: `jdbc:mysql://${hostname}:2881/oceanbase?useSSL=false`
- username: `root`
- password: `pswd`

##### logclient

- ObReaderConfig.RsList: `127.0.0.1:2882:2881`
- ObReaderConfig.Username: `root`
- ObReaderConfig.Password: `pswd`
- ObReaderConfig.TableWhiteList: `sys.*.*`
- ObReaderConfig.StartTimestamp: `0`
- LogProxyClient.Host: `${hostname}`
- LogProxyClient.Port: `2983`
