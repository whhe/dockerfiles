# OceanBase Log Proxy

The Dockerfile and scripts used to start a Docker container which contains [oblogproxy](https://github.com/oceanbase/oblogproxy) service.

## Build the Docker Image

Build the Docker image:

```shell
cd oblogproxy
docker build -t ${image_repo:tag} .
```

### Build Args

There are some arguments that can be used through `--build-arg` in the `docker build` command.

| Name         | Description                      | Default                                                                                                             |
|--------------|----------------------------------|---------------------------------------------------------------------------------------------------------------------|
| PKG_NAME     | The package name.                | `oblogproxy-ce-for-4x-1.1.3-20230815201457.tar.gz`                                                                  |
| DOWNLOAD_URL | The download url of the package. | `https://github.com/oceanbase/oblogproxy/releases/download/v1.1.3/oblogproxy-ce-for-4x-1.1.3-20230815201457.tar.gz` |

## How to Use

See https://hub.docker.com/r/whhe/oblogproxy

### Start the Docker container

Log proxy service uses port `2983` to communicate with client.

```shell
docker run --name ${container_name} -p 2983:2983 -d whhe/oblogproxy:${tag}
```

#### Environment variables

| Name            | Default    | Description                                             |
|-----------------|------------|---------------------------------------------------------|
| OB_SYS_USERNAME | `root`     | The username of `sys` tenant, must not be empty string. |
| OB_SYS_PASSWORD | `password` | The password of `sys` tenant, must not be empty string. |
