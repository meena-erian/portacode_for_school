## Portacode Workshop Environment

This folder lets you run a classroom full of Portacode devices with **one pairing code** and **one compose file**:

1. `export PORTACODE_PAIRING_CODE=7351`
2. (Optional) edit `deploy.replicas` in `docker-compose.yaml` if you need more than 3 students
3. `docker compose up -d`

All containers pair with the teacher’s account, you approve the requests once, and then you use the standard dashboard workflow to transfer each device to the right student. That’s it.

### Prerequisites

- Docker Engine with the compose plugin (`docker compose`)
- Any modern Linux/macOS host (no bind mounts required)
- One active pairing code from the Portacode dashboard

### Build & Deploy

```bash
cd portacode_for_school
docker build -t portacode/workshop-device:latest .
export PORTACODE_PAIRING_CODE=7351
docker compose up -d
```

The compose file already includes `deploy.replicas: 3`. Increase or decrease that value as needed, or override it on the command line:

```bash
docker compose up -d --scale workshop-device=10
```

Every container shares the same pairing code, so you’ll get 10 requests at once. Approve them, transfer ownership per student, and start teaching.

### Customising

- `PORTACODE_DEVICE_NAME` (optional): set it before `docker compose up` to control the label shown in the dashboard. By default, each container uses `Workshop-Device-<slot>` (slot is derived from the container hostname).
- `PORTACODE_GATEWAY`: override if you run a self-hosted gateway.

### Operations

- **Logs**: `docker compose logs -f workshop-device` shows every student container streaming into one log window.
- **Restart/Reset**: `docker compose down && docker compose up -d` tears down and recreates all devices. Pairing survives because the CLI stores its keys inside each container.
- **Scaling Mid-Class**: `docker compose up -d --scale workshop-device=12` brings new devices online instantly—they reuse the exported pairing code, so you just approve the new requests.

### Cleanup

When the workshop ends:

```bash
docker compose down
```

No host folders remain; all data lives inside the containers. You can rebuild/redeploy anytime with a new pairing code. !*** End Patch
