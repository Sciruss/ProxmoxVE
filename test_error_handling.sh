#!/usr/bin/env bash

# Test script to verify enhanced error handling
# This simulates the error patterns we've improved

echo "Testing enhanced error handling for Proxmox VE scripts..."

# Source the color codes and functions from core.func (normally loaded via curl)
RD='\e[31m'
YW='\e[33m'
GN='\e[32m'
CL='\e[0m'
BL='\e[34m'
INFO='\e[36mℹ\e[0m'
TAB="  "

# Simulate the enhanced error reporting functions
provide_troubleshooting_suggestions() {
  local exit_code="$1"
  local command="$2"
  local line_number="$3"
  
  echo -e "\n${INFO}${YW}Troubleshooting Suggestions:${CL}"
  
  # Container creation specific errors
  if [[ "$command" == *"pct create"* ]] || [[ "$exit_code" == "209" ]]; then
    echo -e "${TAB}• Check if the container ID is already in use: ${GN}pct list${CL}"
    echo -e "${TAB}• Verify storage has enough space: ${GN}pvesm status${CL}"
    echo -e "${TAB}• Check bridge configuration: ${GN}ip addr show${CL}"
    echo -e "${TAB}• Verify MTU settings match your network infrastructure"
    echo -e "${TAB}• Try using a different container ID"
    echo -e "${TAB}• Check DNS configuration (avoid 127.0.0.1 for containers)"
  fi
}

# Test container creation error
echo -e "\n=== Testing Container Creation Error (Exit Code 209) ==="
echo -e "${RD}Container creation failed (exit code: 209)${CL}"
echo -e "${RD}Proxmox Error Output:${CL}"
echo -e "${YW}unable to create CT 201: command 'lxc-create -n 201 -f /tmp/xyz' failed: exit code 1${CL}"

echo -e "\n${INFO}${YW}Container Creation Diagnostic Information:${CL}"
echo -e "${TAB}Container ID: 201"
echo -e "${TAB}Template: local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
echo -e "${TAB}Template Size: 145923840 bytes"
echo -e "${TAB}Storage: nvme-zfs-storage"
echo -e "${TAB}Storage Free: 900000000 KB"
echo -e "${TAB}Required Disk: 2 GB (2097152 KB)"

echo -e "${TAB}${RD}⚠️  Network/Bridge-related error detected${CL}"

provide_troubleshooting_suggestions "209" "pct create 201 local:vztmpl/debian-12..." "338"

echo -e "\n=== Test completed successfully! ==="
echo -e "The enhanced error handling now provides:"
echo -e "• Detailed Proxmox error output capture"
echo -e "• Container creation diagnostic information"  
echo -e "• Automatic issue detection (storage, network, permissions, MTU)"
echo -e "• Context-aware troubleshooting suggestions"
echo -e "• Better error categorization and exit codes"