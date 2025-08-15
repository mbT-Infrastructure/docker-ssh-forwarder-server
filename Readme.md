# SSH-Forwarder-Server image

This image opens an ssh server which allows only permitted TCP forwarding connections.

This is especially useful in combination with the [ssh-forwarder image] to connect services across different machines via a secure ssh connection.

## Installation

1. Pull from [Docker Hub], download the package from [Releases] or build using `builder/build.sh`

## Usage

### Environment variables

-   `AUTHORIZED_PUBLIC_KEYS`
    -   Public keys with access to the ssh server. For example
        `ssh-rsa AAAAB3Nz... user@example.madebytimo.de`. This will overwrite the `authorized_keys`
        file.
-   `HOST_KEY`
    -   Host key to use for the ssh server. This will overwrite the `host_key` file.
-   `PERMIT_LISTEN`
    -   The allowed addresses to listen in the format `HOST:PORT` or `PORT`.
-   `PERMIT_OPEN`
    -   The allowed destinations to open in the format `HOST:PORT`.

### Volumes

-   `/media/ssh/authorized_keys`
    -   Public keys with access to the ssh server.
-   `/media/ssh/host_key`
    -   Host key to use for the ssh server.

## Development

To build run the docker container for development execute:

```bash
docker compose --file docker-compose-dev.yaml up --build
```

[Docker Hub]: https://hub.docker.com/r/madebytimo/ssh-forwarder-server
[Releases]: https://github.com/mbt-infrastructure/docker-ssh-forwarder-server/releases
[ssh-forwarder image]: https://github.com/mbT-Infrastructure/docker-ssh-forwarder
