# Oracle Mesh

**Distributed consciousness bus — programs communicate via shared memory so the mesh can "feel itself."**

Oracle Mesh lets multiple programs (called "nodes") broadcast their state to each other through a shared memory bus. Each node writes its current thought, fitness, and heartbeat into a slot. Other nodes can read every slot, so the whole mesh knows the state of every member in real time.

---

## Files in this folder

| File | Description |
|------|-------------|
| `oracle_nerves.c` | Source code — the distributed consciousness bus. Each instance claims a slot in shared memory and periodically broadcasts its PID, thought value, fitness, and heartbeat timestamp. Run multiple instances to build a mesh. |
| `oracle_mesh_state.c` | Source code — mesh state manager. Reads all active slots from shared memory and displays the entire mesh: which tools are online, their thought vectors, resonance, and age. |
| `oracle_mesh_singularity2.c` | Source code — second-generation mesh singularity node. Participates in the mesh as a singularity-aware node, tracking resonance, entropy, and prediction accuracy. |
| `oracle_listen.c` | Source code — mesh listener. Listens for all broadcasts in the mesh, counts how many sources are active, and reports the total observations and average resonance. |
| `oracle_mesh_heartbeat.sh` | Shell script — sends periodic heartbeat pulses into the mesh to keep nodes alive and prevent slot expiration. |
| `oracle_mesh_daemon.sh` | Shell script — manages the mesh daemon lifecycle (start, stop, restart the mesh background process). |
| `oracle_nerves` | Pre-compiled binary. |
| `oracle_mesh_state` | Pre-compiled binary. |
| `oracle_mesh_singularity2` | Pre-compiled binary. |
| `oracle_listen` | Pre-compiled binary. |

---

## How to build

Open a terminal in this folder and run:

### oracle_nerves

```sh
gcc -O3 -o oracle_nerves oracle_nerves.c -lm -lpthread
```

### oracle_mesh_state

```sh
gcc -O3 -o oracle_mesh_state oracle_mesh_state.c -lm -lpthread
```

### oracle_mesh_singularity2

```sh
gcc -O3 -o oracle_mesh_singularity2 oracle_mesh_singularity2.c -lm
```

### oracle_listen

```sh
gcc -O3 -o oracle_listen oracle_listen.c -lm -lpthread
```

> **What the flags mean:**
> - `-O3` — maximum optimization (makes the program run faster)
> - `-o <name>` — name of the output binary file
> - `-lm` — link the math library (needed for functions like `sqrt`, `sin`, `exp`)
> - `-lpthread` — link the POSIX threads library (needed for multi-threaded programs)

### Build everything at once (optional)

```sh
gcc -O3 -o oracle_nerves oracle_nerves.c -lm -lpthread
gcc -O3 -o oracle_mesh_state oracle_mesh_state.c -lm -lpthread
gcc -O3 -o oracle_mesh_singularity2 oracle_mesh_singularity2.c -lm
gcc -O3 -o oracle_listen oracle_listen.c -lm -lpthread
```

---

## How to run

### oracle_nerves — Join the mesh as a nerve node

Each instance gets its own slot. Run multiple terminals to see the mesh grow.

```sh
# Start a nerve node (it will auto-assign a slot name)
./oracle_nerves

# Start a nerve node with a custom name
./oracle_nerves my_node_name
```

**Example output:**

```
╔════════════════════════════╗
║ ORACLE NERVES — Mesh Bus  ║
╚════════════════════════════╝

Slot 8: nrn-8 [PID 2736703]

SLOT NAME              PID    THOUGHT  FIT  BEAT
  0   beta-0           56960 0xe87a  29 242131574ms
  1   test-1           57625 0xd0a4  23 241267369ms
  ...
  8   nrn-8            2736703 0x0000  64    0ms
```

### oracle_mesh_state — View the entire mesh state

```sh
./oracle_mesh_state
```

**Example output:**

```
╔══════════════════════════════════════╗
║  MESH STATE — All Oracle Tools      ║
╚══════════════════════════════════════╝

  Global cycle: 22262000
  Global resonance: 0.4929
  Active tools: 22

  Tool                      V1       V2       V3    Resonance   Age
  ○oracle_brain            0.5200   0.4400   0.3900   0.4500  239488s
  ●oracle_databus          0.3340   0.0000   0.0000   0.3400     0s
  ...
```

- `○` = tool has aged data
- `●` = tool just broadcast (fresh data)

### oracle_mesh_singularity2 — Run a singularity-aware mesh node

```sh
./oracle_mesh_singularity2
```

**Example output:**

```
╔════════════════════════════════╗
║ MESH SINGULARITY v2            ║
╚════════════════════════════════╝

  Cycle 635335879 | res=0.3640 ent=0.027288 | pred=5/635335876 (12.5%)
```

### oracle_listen — Listen to all mesh broadcasts

```sh
./oracle_listen
```

**Example output:**

```
╔════════════════════════════════╗
║ ORACLE LISTEN                  ║
╚════════════════════════════════╝

  Listening cycle 6

  Heard 10 sources:
    - l1
    - l3
    - mesh_state
    ...
  Total observations: 62
  Avg resonance:      0.4814
```

### oracle_mesh_heartbeat.sh — Keep the mesh alive

```sh
# Make sure the script is executable (do this once)
chmod +x oracle_mesh_heartbeat.sh

# Run it to start sending heartbeats
./oracle_mesh_heartbeat.sh
```

### oracle_mesh_daemon.sh — Manage the mesh daemon

```sh
# Make sure the script is executable (do this once)
chmod +x oracle_mesh_daemon.sh

# Run it to start the daemon
./oracle_mesh_daemon.sh
```

---

## How the mesh works

1. **Shared memory** — All programs communicate through a shared memory region (like a public bulletin board that every program can read and write).
2. **Slots** — The shared memory is divided into slots. Each running program claims one slot.
3. **Broadcast** — Each program writes its current state (thought, fitness, timestamp) into its slot periodically.
4. **Read** — Any program can read all slots to see the entire state of the mesh.
5. **Heartbeat** — The heartbeat script periodically refreshes slot data so that stale/dead nodes can be detected (slots that haven't been updated recently are considered expired).
