#!/bin/bash

# List of required packages
required_packages=("nmap")

# Function to print the banner
print_banner() {
    echo -e "\n"
    echo "               _      _ __  "
    echo "          (_)__  (_) /_     "
    echo "         / / _ \/ / __/     "
    echo "        /_/_//_/_/\__/      "
    echo "    ____  ____  ____  ______"
    echo "   / __ \/ __ \/ __ \/_  __/"
    echo "  / /_/ / / / / /_/ / / /   "
    echo " / ____/ /_/ / _, _/ / /    "
    echo "/_/____\_\\\\\\_\\| /_\   __"
    echo "  / ___// ____/   |  / | / /"
    echo "  \__ \/ /   / /| | /  |/ / "
    echo " ___/ / /___/ ___ |/ /|  /  "
    echo "/____/\____/_/  |_/_/ |_/   "
    echo -e "-----------------------------------"
    echo "Author: @richardevcom; Version: 1.0.1"
    echo -e "-----------------------------------\n"
}

# Function to check and install required packages
install_packages() {
    echo "- Checking and installing required packages..."
    for package in "${required_packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            echo "[-] $package is not installed. Installing..."
            sudo apt update
            sudo apt install -y "$package"
        else
            echo "[+] $package is installed."
        fi
    done
    echo -e ""
}

# Function to run initial nmap port scan
run_nmap_initial_port_scan() {
    local target_ip="$1"
    if [[ -z "$target_ip" ]]; then
        read -p "[-] No target IP provided. Please enter target IP: " target_ip
        if [[ -z "$target_ip" ]]; then
            echo "[-] No target IP provided. Exiting."
            exit 1
        fi
    fi
    echo "- Running nmap scan on $target_ip..."
    open_ports=($(sudo nmap -T5 -p 1-6635 -Pn "$target_ip" -r | grep -oP '^\d+/tcp' | cut -d/ -f1))
}

# Function to map open ports found by nmap
map_nmap_ports() {
    if [[ ${#open_ports[@]} -eq 0 ]]; then
        echo "[-] No open ports found. Exiting."
        exit 1
    fi

    echo "[i] Open ports: $(IFS=,; echo "${open_ports[*]}")"
    echo -e ""
}

# Function to run nmap service version scan on open ports
run_nmap_port_service_scan() {
    local target_ip="$1"
    if [[ -z "$target_ip" ]]; then
        echo "[-] No target IP provided. Exiting."
        exit 1
    fi

    if [[ ${#open_ports[@]} -eq 0 ]]; then
        echo "[-] No open ports to scan. Exiting."
        exit 1
    fi

    echo "- Running deep service scan on $target_ip for ports: $(IFS=,; echo "${open_ports[*]}")..."
    open_ports_services=$(sudo nmap -sV -p "$(IFS=,; echo "${open_ports[*]}")" "$target_ip" | grep -oP '^\d+/tcp\s+\w+\s+.*')

    echo "[i] Open ports, services & versions:"
    echo "$open_ports_services"
    echo "$open_ports_services" >> "nmap_${target_ip}_sv_ports.txt"
    echo -e ""
}

# Parse command-line arguments
while getopts "h:" opt; do
    case $opt in
        h) target_ip="$OPTARG" ;;
        *) echo "Usage: $0 -h <target_ip>"
           exit 1 ;;
    esac
done

# Main script execution
print_banner
install_packages
run_nmap_initial_port_scan "$target_ip"
map_nmap_ports
run_nmap_port_service_scan "$target_ip"

# TODO
# - Add vulnerabilitiy scanning scripts
# - Save vulnerability CVEs codes to file
# - Test CVEs against known exploits using msfconsole or other tools