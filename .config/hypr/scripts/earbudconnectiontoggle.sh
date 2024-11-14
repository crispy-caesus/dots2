#!/bin/bash

# Define the MAC address of the Bluetooth device
DEVICE_MAC="AC:80:0A:03:FD:D3"

# Check if the device is connected
STATUS=$(bluetoothctl info "$DEVICE_MAC" | grep "Connected" | awk '{print $2}')

if [ "$STATUS" == "yes" ]; then
    # If connected, disconnect the device
    echo "Device is connected, disconnecting..."
    bluetoothctl disconnect "$DEVICE_MAC"
else
    # If not connected, connect the device
    echo "Device is not connected, connecting..."
    bluetoothctl connect "$DEVICE_MAC"
fi
