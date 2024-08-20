<#
================================== WordPress ===================================
#>

# Set temporary variables to be used during the WordPress installation
$IIS_PATH = "C:\inetpub"
$WORDPRESS_PATH = "$IIS_PATH\wordpress"
$WORDPRESS_URL = "https://wordpress.org/latest.zip"
$WORDPRESS_ZIP = "wordpress.zip"

# Download and install WordPress
"`r`nWordPress ..."
"  - Downloading"
Invoke-WebRequest "$WORDPRESS_URL" -OutFile "$WORDPRESS_ZIP"
"  - Expanding"
Expand-Archive "$WORDPRESS_ZIP" "$IIS_PATH"

# Grant the IIS_IUSRS and IUSR accounts Modify rights to the WordPress directory
"  - Appying NTFS Permissions (IIS_IUSRS)"
Add-NTFSAccess "$WORDPRESS_PATH" IIS_IUSRS Modify
"  - Appying NTFS Permissions (IUSR)"
Add-NTFSAccess "$WORDPRESS_PATH" IUSR Modify

# Create a new Internet Information Services application pool for WordPress
"  - Creating Application Pool"
$WebAppPool = New-WebAppPool "WordPress"
$WebAppPool.managedPipelineMode = "Classic"
$WebAppPool.managedRuntimeVersion = ""
$WebAppPool | Set-Item

# Create a new Internet Information Services website for WordPress
"  - Creating WebSite"
New-Website "WordPress" -ApplicationPool "WordPress" -PhysicalPath "$WORDPRESS_PATH"  | Out-Null

# Remove the “Default Web Site” and start the new “WordPress” website
"  - Activating WebSite"
Remove-Website "Default Web Site"
Start-Website "WordPress"

"Done."

<#
================================================================================
#>

"`r`nInstallation Complete!`r`n"
$IPADDRESS = (Get-NetIPAddress | ? {($_.AddressFamily -eq "IPv4") -and ($_.IPAddress -ne "127.0.0.1")}).IPAddress
"`r`nConnect your web browser to http://$IPADDRESS/ to complete this WordPress`r`ninstallation.`r`n"
