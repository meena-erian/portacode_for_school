# Persistent Workspace Setup

Need something longer-lived than the temporary workshop but still easy to run?
This folder spins up one container per student and bind-mounts a unique host
directory into each container so their files survive restarts (and are easy to
inspect or back up).

---

## Requirements

- Linux host with Docker Engine + `docker compose`
- Python 3.10 or newer
- A PortaCode pairing code from your dashboard

---

## Provision the class

```bash
git clone https://github.com/meena-erian/portacode_for_school.git
cd portacode_for_school/persistent_workspace
python3 generate_classroom.py
```

> The script builds the Docker image in this folder the first time it runs, so
> make sure Docker is installed and available on your PATH.

The script will ask for:

1. PortaCode pairing code
2. Device name prefix (default `Workshop-Device`)
3. Number of student containers
4. PortaCode gateway URL (default `wss://portacode.com/gateway`)

After confirming, it will:

- Create `students/<slug>/workspace/` folders (one per student)
- Write `.env`, `docker-compose.yaml`, and `classroom_state.json`
- Run `docker compose up -d`

Head back to the PortaCode dashboard, approve each pairing request, then transfer
ownership of each device to the appropriate student email.

---

## Day‑2 operations

- List containers: `docker compose ps`
- Follow logs: `docker compose logs -f`
- Stop everything: `docker compose down`
- Need a different student count? Re-run `python3 generate_classroom.py` and it
  will regenerate everything for you.

All student files live directly under `students/`, so copying work off the host
is as easy as zipping one of those directories—no special tooling required.
