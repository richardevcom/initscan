# Init - Port Scanner

![Version](https://img.shields.io/badge/version-1.0.1-blue)
[![Sponsor](https://img.shields.io/badge/sponsor-richardevcom-pink)](https://github.com/sponsors/richardevcom)

## Overview

This repository contains a simple port scanning script written in Bash. The script uses `nmap` to perform an initial port scan and a service version scan on a target IP address. It also includes functionality to check and install required packages.

## Features

- Checks and installs required packages (`nmap`).
- Performs an initial port scan on the target IP.
- Maps open ports found by `nmap`.
- Performs a deep service version scan on the open ports.
- Saves the results of the service version scan to a file.

## Usage

To use the script, run the following command:

```sh
sudo bash ./portscan.sh -h <target_ip>
```
_Replace <target_ip> with the IP address you want to scan._

# TODO
- Add vulnerability scanning scripts.
- Save vulnerability CVEs codes to file.
- Test CVEs against known exploits using msfconsole or other tools.

Author: [richardevcom](https://github.com/richardevcom)
License: _This project is licensed under the MIT License._