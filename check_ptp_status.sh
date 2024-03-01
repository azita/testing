#!/bin/sh

# Timeout duration in seconds
TIMEOUT_DURATION=5

# Check if the ptp4l process is running
PTP4L_PID=$(pgrep ptp4l)
if [ -z "$PTP4L_PID" ]; then
    echo "ptp4l process not found"
fi

# Check if the phc2sys process is running
PHC2SYS_PID=$(pgrep phc2sys)
if [ -z "$PHC2SYS_PID" ]; then
    echo "phc2sys process not found"
fi
exit 0

