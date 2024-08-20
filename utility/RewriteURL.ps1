# Download and install the "URL Rewrite 2.0" Extension for IIS
"`r`nURL Rewrite 2.0 Extension for IIS ..."
"  - Downloading"
Invoke-WebRequest "https://download.microsoft.com/download/D/8/1/D81E5DD6-1ABB-46B0-9B4B-21894E18B77F/rewrite_x86_en-US.msi" -OutFile "rewrite_amd64.msi"
"  - Installing"
Start-Process "msiexec.exe" "/i rewrite_amd64.msi /qn" -Wait
"Done."
