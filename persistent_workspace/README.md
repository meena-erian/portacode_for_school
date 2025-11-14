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
python3 manage_classroom.py
```

> The first run provisions the class from scratch and builds the Docker image in
> this folder. Later runs detect the existing classroom and show a menu to add
> or remove student containers.

During the initial run the script will ask for:

1. PortaCode pairing code
2. Device name prefix (default `Workshop-Device`)
3. Number of student containers
4. PortaCode gateway URL (default `wss://portacode.com/gateway`)

After confirming, it will:

- Create `students/<slug>/workspace/` folders (one per student)
- Write `.env`, `docker-compose.yaml`, and `classroom_state.json`
- Run `docker compose up -d`

Head back to the PortaCode dashboard, approve the pairing requests, then transfer
ownership of each device to the correct student.

---

## Day‑2 operations

- List containers: `docker compose ps`
- Follow logs: `docker compose logs -f`
- Stop everything: `docker compose down`
- Need to adjust the class size later? Re-run `python3 manage_classroom.py`
  and use the menu to add or remove students; the script regenerates Compose and
  restarts the stack automatically.

All student files live directly under `students/`, so copying work off the host
is as easy as zipping one of those directories—no special tooling required.

---

## Pairing data persistence

Each student folder now contains three bind-mounted directories:

- `workspace/`: the editable project files students see inside the container.
- `.portacode/`: the device identity, key pairs, and any other pairing metadata
  written by the `portacode` CLI.
- `.local/share/portacode/`: additional PortaCode cache + key pairs as created by
  the CLI (mirrors the default Linux data dir).
- `logs/`: runtime logs captured by `entrypoint.sh` for troubleshooting.

Because these folders live on the host under `students/<slug>/`, recreating a
container no longer wipes the pairing material; the new container immediately
picks up the existing `.portacode` data and resumes with the already-approved
device identity. If you remove a student and elect to delete their data, the
pairing artifacts are removed along with the workspace.
