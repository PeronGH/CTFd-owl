# CTFd-owl

Dynamically Spawn and Manage Docker Compose Instances for CTFd.

This project is a fork of [CTFd-owl](https://github.com/BIT-NSC/CTFd-owl), which was modified from [H1ve/ctfd-owl](https://github.com/D0g3-Lab/H1ve/tree/master/CTFd/plugins/ctfd-owl) and [CTFd-Whale](https://github.com/frankli0324/CTFd-Whale).

## Quick Start

0. Only UNIX-like systems are officially supported.
1. Ensure that `docker` and `docker compose` is installed.
2. Run `docker compose -f single-debug.yml up` to start debug server, which listens at localhost:8000.
3. Use `docker compose -f single-debug.yml down` to stop it.

## Configuration

Refer to the pictures and tables for default configuration.

### Docker Settings

![Docker Settings](./assets/ctfd-owl_admin_settings-docker.png)

| Options                      | Content                                                      |
| ---------------------------- | ------------------------------------------------------------ |
| **Docker Flag Prefix**       | Flag prefix                                                  |
| **Docker APIs URL**          | API name (default is `unix://var/run/docker.sock`)           |
| **Max Container Count**      | Maximum number of containers (unlimited by default)          |
| **Docker Container Timeout** | Maximum running time for containers (will be destroyed automatically when reached) |
| **Max Renewal Time**         | Maximum number of container renewals (unable to renew after exceeding) |

### FRP Settings

![FRP Settings](./assets/ctfd-owl_admin_settings-frp.png)

| Options                     | Content                                                      |
| --------------------------- | ------------------------------------------------------------ |
| **FRP Http Domain Suffix**  | FRP domain prefix (required if dynamic domain forwarding enabled) |
| **FRP Direct IP Address**   | frp server IP                                                |
| **FRP Direct Minimum Port** | Minimum port (keep consistent with minimum port exposed by `frps` in `docker compose`) |
| **FRP Direct Maximum Port** | Maximum port (keep consistent with maximum port exposed by `frps` in `docker compose`) |
| **FRP config template**     | frpc hot reload config header template (use default if unsure about customization) |

Generate a random `token`, replace `random_this`, and modify `token` in `frp/conf/frps.ini` to be the same.

```ini
[common]
token = random_this
server_addr = frps  
server_port = 80
admin_addr = 10.1.0.4
admin_port = 7400
```

## FAQ

### How to add new challenges?

When creating a new challenge, the `docker-compose.yml` file for the problem should follow [BIT-NSC/ctfd-owl.docker-compose](https://github.com/BIT-NSC/ctfd-owl.docker-compose). The CTFd challenge configuration is as follows

| Options | Content |
|-|-|  
| **Challenge Type** | Problem type (select `dynamic_check_docker`) |
| **Deployment Type** | Deployment method (select `SINGLE-DOCKER-COMPOSE`, the other one is invalid) |
| **Dirname** | Problem folder (relative path to `./challenges`, for example, `test/simple_server`) |
| **FRP Type** | frp type (`DIRECT` for direct IP access with port, `HTTP` for subdomain access) |
| **FRP Port** | Exposed port in problem docker-compose (e.g. `8000` in example) |
| **Flag Type** | If dynamically generating flag, select `Dynamic`; if static flag like normal problem, select `Static` and add flag in problem flag |

![Challenge Configuration](./assets/admin_challenges_new.png)
