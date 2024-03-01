#!/bin/sh

# Initial delay to give the primary container time to start
sleep 10

while true; do
    # Check for ptp4l process
    if pgrep ptp4l > /dev/null; then
        echo "ptp4l process found."
        # Perform your logic here
    else
        echo "ptp4l process not found, retrying in 10 seconds..."
        sleep 10
    fi
done
