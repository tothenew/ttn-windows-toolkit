# Enable Remote Management Service
"  - Enabling Remote Management"
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\WebManagement\Server EnableRemoteManagement 1
Set-Service WMSVC -StartupType Automatic
Start-Service WMSVC

"Done."
