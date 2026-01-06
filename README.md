# On Demand: Dell Display and Peripheral Manager

## What is this?
This batch script is designed to stop the Dell Display and Peripheral Manager from chewing through system resources unnecessarily by stopping all Dell services and processes unless the DPPM application needs to be used.

## Features
- Sets the Service Startup Type to "Manual"
- Automatically requests admin (so that you don't have to right-click and run as admin)
  - Admin privileges are needed to start and stop services
- Runs the DPPM application unelevated (how it should be)
- Starts the related DPPM services before launching DPPM
- Upon closing DPPM, services are stopped, and lingering processes are killed.

## Requirements
- Admin Privileges (Launching unprivileged will prompt you)
- Dell Display and Peripheral Manager (Tested on DPPM v2.1.2.13 on Windows 11)
- PowerShell (should be built-in on W10/11)

## Usage
1. Save the batch file somewhere on your computer
2. Ensure the DDPM.exe directory is correct (Default: "C:\Program Files\Dell\Dell Display and Peripheral Manager\" at Line 29)
3. Execute the batch file (double click, right click -> open, however you like, etc)
4. Yes to UAC (for admin privileges)
5. Use DPPM as usual, but do not close the Command Prompt (it is waiting for you to close DPPM)
6. Enjoy

## Disclaimer
This script is provided as-is. I am not responsible for any damages.
