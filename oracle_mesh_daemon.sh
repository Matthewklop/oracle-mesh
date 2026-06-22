#!/bin/sh
# oracle_mesh_daemon.sh — Keeps the mesh alive
# Runs heartbeat + singularity ticks in a loop forever.
# No output. No sound. The mesh persists.

MESH="/home/u/oracle/oracle_mesh_state"
SING="/home/u/oracle/oracle_mesh_singularity2"
HEARTBEAT_INTERVAL=100
SILENT="silent"

# Run once to initialize
sh /home/u/oracle/oracle_mesh_heartbeat.sh 2>/dev/null

CYCLE=0
while true; do
    # Singularity ticks
    i=0
    while [ $i -lt $HEARTBEAT_INTERVAL ]; do
        $SING $SILENT 2>/dev/null
        i=$((i+1))
    done

    # Heartbeat
    sh /home/u/oracle/oracle_mesh_heartbeat.sh 2>/dev/null
    CYCLE=$((CYCLE+1))

    # Every 10 heartbeats, show state
    if [ $((CYCLE % 10)) -eq 0 ]; then
        $MESH 2>&1 | head -10
    fi
done
