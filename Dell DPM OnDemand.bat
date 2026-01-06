@ECHO off
@TITLE "On-Demand: Dell Display and Peripheral Manager"

:: Request for elevation if not running as admin
net session >nul 2>&1
IF %errorlevel% neq 0 (
    ECHO Requesting Admin Privileges...
    powershell -NoProfile -Command ^
        "Start-Process '%~f0' -Verb RunAs"
    EXIT /b
)

ECHO === Checking Dell Service Startup Types ===
CALL :SetServiceStartUpTypes

ECHO === Checking if DDPM is already open ===
SET "PROCESS_NAME=DDPM.exe"
tasklist /FI "IMAGENAME eq %PROCESS_NAME%" /FO CSV /NH | findstr /I /C:"%PROCESS_NAME%" >nul

:: Kill DDPM if already open
IF %errorlevel% equ 0 (  
    ECHO Warning: %PROCESS_NAME% is already running. Terminating existing %PROCESS_NAME%.  
    taskkill /F /im %PROCESS_NAME%
)

CALL :StartDellServices

ECHO === Starting %PROCESS_NAME% ===
explorer.exe "C:\Program Files\Dell\Dell Display and Peripheral Manager\%PROCESS_NAME%"
ECHO %PROCESS_NAME% Running...
:WaitForDDPMToClose
tasklist /FI "IMAGENAME eq %PROCESS_NAME%" | find /I "%PROCESS_NAME%" >nul
if not errorlevel 1 (
    timeout /t 2 >nul
    goto WaitForDDPMToClose
)
ECHO %PROCESS_NAME% exited, killing Dell Processes...

CALL :ListDellProcesses
CALL :StopDellServices
CALL :KillDellProcesses
ECHO Waiting for processes to terminate...
timeout 5
CALL :ListDellProcesses


::PAUSE
EXIT


:ListDellProcesses
ECHO === Dell Processes Currently Running: ===
tasklist /fi "IMAGENAME eq Dell*"
tasklist /fi "IMAGENAME eq DDPM*"
EXIT /B 0

:StopDellServices
ECHO === Stopping Dell Services ===
net stop "DellTechHub"
net stop "DPMService"
net stop "DellClientManagementService"
EXIT /B 0

:KillDellProcesses
ECHO === Killing Dell Processes ===
taskkill /F /im Dell*
taskkill /F /im DDPM*
EXIT /B 0

:StartDellServices
ECHO === Starting Dell Services ===
net start "DellTechHub"
net start "DPMService"
net start "DellClientManagementService"
EXIT /B 0

:SetServiceStartUpTypes
powershell -NoProfile -Command ^
  "Get-Service -Name 'DellTechHub' | Where-Object {$_.StartType -ne 'Manual'} | Set-Service -StartupType Manual"
ECHO DellTechHub set to Manual
powershell -NoProfile -Command ^
  "Get-Service -Name 'DPMService' | Where-Object {$_.StartType -ne 'Manual'} | Set-Service -StartupType Manual"
ECHO DPMService set to Manual
powershell -NoProfile -Command ^
  "Get-Service -Name 'DellClientManagementService' | Where-Object {$_.StartType -ne 'Manual'} | Set-Service -StartupType Manual"
ECHO DellClientManagementService set to Manual
EXIT /B 0