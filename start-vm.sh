#!/bin/bash

#########################################
# Author: Joshua Noll
# Version: 1.1
# Date: 04 July 2023
# Description: Start WinBox VM and bring fullscreen
# Usage: ./start-winbox.sh <VM Name>
#########################################

# Set the name of your VirtualBox VM
VM_NAME=${1}

# Function to find the VM window and make it fullscreen
function fullscreen_vm() {
    local vm_name="$1"
    local vm_window_id=""
    local max_tries=10
    local try_count=0

    # Wait until the VM window appears
    while [ -z "$vm_window_id" ] && [ "$try_count" -lt "$max_tries" ]; do
        sleep 2
        vm_window_id=$(wmctrl -l | grep "$vm_name" | awk '{print $1}')
        ((try_count++))
    done

    # Check if the VM window ID was found
    if [ -z "$vm_window_id" ]; then
        echo "Failed to find the VM window."
        exit 1
    fi

    # Activate the VM window (bring it to the front)
    wmctrl -i -R "$vm_window_id"

    # Bring the VM window to fullscreen
    wmctrl -i -r "$vm_window_id" -b add,maximized_vert,maximized_horz

    echo "VM is now running in fullscreen mode."
}

#Check for VM_NAME variable and prompt if empty.
if test -z ${VM_NAME}; then read -p "Please enter the name of the VM: "; fi

# Check if the VM is running
if VBoxManage list runningvms | grep -q "$VM_NAME"; then
    echo "VM is already running."
    fullscreen_vm "$VM_NAME"
else
    echo "Starting VM..."
    VBoxManage startvm "$VM_NAME" --type gui
    fullscreen_vm "$VM_NAME"
fi

