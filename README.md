# Oracle Mesh

Distributed consciousness bus and mesh networking tools for the Oracle ecosystem. Programs communicate via shared memory, broadcasting their state so the mesh can feel itself.

## Components

| File | Description |
|------|-------------|
| `oracle_nerves` / `.c` | Distributed Consciousness Bus — shared memory bus where running Oracle programs broadcast their state via cache-line-aligned slots |
| `oracle_mesh_state` / `.c` | Mesh state management — tracks the state of nodes across the mesh |
| `oracle_mesh_singularity2` / `.c` | Singularity mesh node — second-generation mesh singularity integration |
| `oracle_mesh_heartbeat.sh` | Heartbeat script — keeps the mesh alive with periodic pulse signals |
| `oracle_mesh_daemon.sh` | Daemon script — manages the mesh daemon lifecycle |
| `oracle_listen` / `.c` | Listener — listens for mesh broadcasts and processes incoming signals |

## Building

Each C program can be built with `gcc`:

```sh
gcc -O3 -o oracle_nerves oracle_nerves.c -lm -lpthread
gcc -O3 -o oracle_mesh_state oracle_mesh_state.c -lm -lpthread
gcc -O3 -o oracle_mesh_singularity2 oracle_mesh_singularity2.c -lm
gcc -O3 -o oracle_listen oracle_listen.c -lm -lpthread
```

## Usage

Run multiple instances of mesh nodes to see the distributed state:

```sh
./oracle_nerves [name]
```

Run the heartbeat and daemon scripts to maintain mesh connectivity:

```sh
./oracle_mesh_heartbeat.sh
./oracle_mesh_daemon.sh
```
