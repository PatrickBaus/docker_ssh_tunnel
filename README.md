[![GitHub release](https://img.shields.io/github/release/PatrickBaus/docker_ssh_tunnel.svg)](../../releases/latest)
[![CI workflow](https://img.shields.io/github/actions/workflow/status/PatrickBaus/docker_ssh_tunnel/ci.yml?branch=master&label=ci&logo=github)](../../actions?workflow=ci)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](../../pkgs/container/docker_ssh_tunnel)
# Docker SSH Tunnel
A lightweight SSH tunnel container to connect services between remote sites. It is used to forward a port from a remote
server behind a secure SSH endpoint.

# Setup
The `Docker SSH Tunnel` is best installed via the Docker repository provided with this repository.

## ... via [`docker-compose`](https://github.com/docker/compose)

Example `docker-compose.yml` for the `Docker SSH Tunnel`:
```yaml
services:
  ssh-tunnel:
    image: ghcr.io/patrickbaus/docker_ssh_tunnel:latest
    container_name: ssh-tunnel
    restart: always
    networks:
      - remote
    environment:
      - USER=SSH_USER
      - REMOTE_HOST=REMOTE_SERVER
      - REMOTE_PORT=REMOTE_PORT
      - ENDPOINT=SSH_ENDPOINT
    secrets:
      - ssh_key

secrets:
  ssh_key:
    file: ./THE_PRIVATE_SSH.key

networks:
  remote:
```

The SSH tunnel can now be accessed from another Docker service within the same `remote` network via
`ssh-tunnel:REMOTE_PORT`. Do note, that by default, the local port of the tunnel is the same as the remote port. See
[SSH settings](#ssh-settings) for details.

## Customizing
The following parameters need to be set to establish an SSH tunnel:

### SSH settings

| Name                  | Description                                                                                       |
|-----------------------|---------------------------------------------------------------------------------------------------|
| `SSH_USER`            | The SSH user name to log into the remote SSH endpoint. Typically: SSH_USER@SSH_ENDPOINT           |
| `SSH_ENDPOINT`        | The hostname or IP (optional: port) of the remote SSH endpoint. Typically: SSH_USER@SSH_ENDPOINT  |
| `SSH_PORT`            | The SSH port of the endpoint. (default=22)                                                        |
| `KEEP_ALIVE_INTERVAL` | Send a keep alive every $KEEP_ALIVE_INTERVAL seconds. Terminate after three failures. (default=1) |
| `THE_PRIVATE_SSH.key` | The location of the private SSH key file used for public key authentication.                      |

This service requires the use of public key authentication. It does not work with a username and password. To create a
valid key pair use
```bash
ssh-keygen -t ed25519 -C "SSH key for my remote service"
```
Do remember to replace the comment with something useful and memorable.

### Remote connection settings

| Name                  | Description                                                                                                                       |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `LOCAL_PORT`          | The local port to which the remote service is forwarded to. The service can be reached on this port later. (default=REMOTE_PORT)  |
| `REMOTE_SERVER`       | The hostname or IP of the server hosting the service within the remote network and behind the SSH endpoint.                       |
| `REMOTE_PORT`         | The port on the remote server hosting the service.                                                                                |


## Versioning
I use [SemVer](http://semver.org/) for versioning. For the versions available, see the
[tags on this repository](../../tags).

## Authors
* **Patrick Baus** - *Initial work* - [PatrickBaus](https://github.com/PatrickBaus)

## License
This project is licensed under the GPL v3 license - see the [LICENSE](LICENSE) file for details
