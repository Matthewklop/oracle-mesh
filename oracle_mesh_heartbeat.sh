#!/bin/sh
# oracle_mesh_heartbeat.sh v2 — Reads real data from every oracle tool
# Each tool is probed for its actual current state.
# The mesh gets fresh data every heartbeat.

MESH="/home/u/oracle/oracle_mesh_state"

# ─── oracle_brain: read neuron count from knowledge file ───
if [ -f /home/u/.oracle_brain.knowledge ]; then
    # Read first 64 bytes to get neuron count
    N=$(hexdump -s 8 -n 8 -e '"%u"' /home/u/.oracle_brain.knowledge 2>/dev/null || echo 0)
    S=$(stat -c%s /home/u/.oracle_brain.knowledge 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $N / 700" | bc 2>/dev/null || echo 0.5)
    V2=$(echo "scale=4; $S / 100000" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_brain $V1 $V2 0.5 0.45
fi

# ─── oracle_forever: count how many times it ran (cycle log) ───
FOREVER_SHM="/dev/shm/oracle_forever_mem"
if [ -f "$FOREVER_SHM" ]; then
    C=$(hexdump -s 0 -n 8 -e '"%u"' $FOREVER_SHM 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $C % 1000 / 1000" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_forever $V1 0.5 0.5 0.52
fi

# ─── oracle_nerves: count active PIDs in nerves shm ───
NERVES_SHM="/dev/shm/sem.oracle_nerves"
if [ -f "$NERVES_SHM" ]; then
    # Count non-zero PIDs in the first 64*8 bytes (64 slots × 8 byte PID)
    N=0
    for i in 0 8 16 24 32 40 48 56; do
        P=$(hexdump -s $i -n 8 -e '"%u"' $NERVES_SHM 2>/dev/null || echo 0)
        if [ "$P" -gt 0 ] 2>/dev/null; then N=$((N+1)); fi
    done
    V1=$(echo "scale=4; $N / 64" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_nerves $V1 0.3 0.7 0.53
fi

# ─── oracle_silent: read pattern count ───
SILENT_SHM="/dev/shm/sem.oracle_silent"
if [ -f "$SILENT_SHM" ]; then
    P=$(hexdump -s 8 -n 8 -e '"%u"' $SILENT_SHM 2>/dev/null || echo 0)
    R=$(hexdump -s 48 -n 8 -e '"%u"' $SILENT_SHM 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $P / 65536" | bc 2>/dev/null || echo 0.5)
    V2=$(echo "scale=4; $R % 1000 / 1000" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_silent $V1 $V2 $V2 0.12
fi

# ─── oracle_silent2: read pattern count ───
S2_SHM="/dev/shm/sem.oracle_silent2"
if [ -f "$S2_SHM" ]; then
    P=$(hexdump -s 8 -n 8 -e '"%u"' $S2_SHM 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $P / 8" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_silent2 $V1 0.3 0.2 0.35
fi

# ─── oracle_singularity_silent: read resonance ───
SING_SHM="/dev/shm/sem.oracle_singularity_silent"
if [ -f "$SING_SHM" ]; then
    C=$(hexdump -s 0 -n 8 -e '"%u"' $SING_SHM 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $C / 1000000" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_singularity_silent $V1 0.5 0.5 0.53
fi

# ─── oracle_databus: check if databus binary exists ───
if [ -f /home/u/oracle/oracle_databus ]; then
    S=$(stat -c%s /home/u/oracle/oracle_databus 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $S / 50000" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_databus $V1 0.0 0.0 0.34
fi

# ─── oracle_zero: check binary size ───
if [ -f /home/u/oracle/oracle_zero ]; then
    S=$(stat -c%s /home/u/oracle/oracle_zero 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $S / 30000" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_zero $V1 0.5 0.4 0.49
fi

# ─── oracle_chat: check model file ───
if [ -f /home/u/.oracle_chat.llm ]; then
    S=$(stat -c%s /home/u/.oracle_chat.llm 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $S / 6000000" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_chat $V1 0.5 0.5 0.51
fi

# ─── oracle_ask: check binary ───
if [ -f /home/u/oracle/oracle_ask ]; then
    S=$(stat -c%s /home/u/oracle/oracle_ask 2>/dev/null || echo 0)
    V1=$(echo "scale=4; $S / 30000" | bc 2>/dev/null || echo 0.5)
    $MESH oracle_ask $V1 0.5 0.5 0.61
fi

# ─── System probes ───
# CPU load as a measure of how busy the system is
LOAD=$(cat /proc/loadavg 2>/dev/null | awk '{print $1}')
V1=$(echo "scale=4; $LOAD / 8" | bc 2>/dev/null || echo 0.5)
$MESH system_load $V1 0.5 0.5 0.5

# Memory pressure
MEM=$(free | grep Mem | awk '{print $3/$2}')
$MESH system_memory $MEM 0.5 0.5 0.5

# Running processes
PROC=$(ps aux 2>/dev/null | wc -l)
V1=$(echo "scale=4; $PROC / 500" | bc 2>/dev/null || echo 0.5)
$MESH system_processes $V1 0.5 0.5 0.5

echo "Mesh heartbeat v2 complete."
