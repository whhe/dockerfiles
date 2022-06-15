# Log proxy standalone

The Dockerfile and scripts used to start a Docker container which contains [oblogproxy](https://github.com/oceanbase/oblogproxy) server.

## How to use

### Build the docker image

Build the Docker image under the directory where the Dockerfile located:

```shell
docker build -t ${image_repo:tag} .
```

#### Docker build args

| Name                 | Default | Description                         |
|----------------------|---------|-------------------------------------|
| OB_LOG_PROXY_VERSION | `1.0.2` | The version of `oblogproxy`.        |
| OB_LIB_VERSION       | `3.1.3` | The version of `oceanbase-ce` libs. |

### Start the Docker container

Log proxy standalone uses port `2983` to communicate with client.

```shell
docker run --name ${container_name} -p 2983:2983 -d ${image_repo:tag}
```

#### Environment variables

| Name            | Default | Description                                             |
|-----------------|---------|---------------------------------------------------------|
| OB_SYS_USERNAME | `user`  | The username of `sys` tenant, must not be empty string. |
| OB_SYS_PASSWORD | `pswd`  | The password of `sys` tenant, must not be empty string. |

### Test with client

You can use [oblogclient](https://github.com/oceanbase/oblogclient) to connect to log proxy on 2983. Here is an example for configuration:

- ObReaderConfig.RsList: `127.0.0.1:2882:2881`
- ObReaderConfig.Username: `root`
- ObReaderConfig.Password: `pswd`
- ObReaderConfig.TableWhiteList: `sys.*.*`
- ObReaderConfig.StartTimestamp: `0`
- LogProxyClient.Host: `${hostname}`
- LogProxyClient.Port: `2983`
