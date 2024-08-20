cd ~\Downloads

<#
======================== Internet Information Services =========================
#>

"`r`nInternet Information Server ..."
"  - Installing Features"
If ((Get-CimInstance Win32_OperatingSystem).ProductType -eq 1) {

    # Windows Client

    Enable-WindowsOptionalFeature -FeatureName `
		IIS-WebServerRole,IIS-WebServer,IIS-CommonHttpFeatures,IIS-StaticContent, `
		IIS-DefaultDocument,IIS-DirectoryBrowsing,IIS-HttpErrors, `
		IIS-ApplicationDevelopment,IIS-CGI,IIS-HealthAndDiagnostics, `
		IIS-HttpLogging,IIS-LoggingLibraries,IIS-RequestMonitor,IIS-Security, `
		IIS-RequestFiltering,IIS-Performance,IIS-HttpCompressionStatic, `
		IIS-WebServerManagementTools,IIS-ManagementConsole,IIS-ManagementService, `
		WAS-WindowsActivationService,WAS-ProcessModel,WAS-NetFxEnvironment, `
		WAS-ConfigurationAPI,NetFx3 -Online -All -Source D:\Sources\sxs | Out-Null
}
Else {

    # Windows Server

    Install-WindowsFeature `
		Web-Server,Web-Common-Http,Web-Static-Content,Web-Default-Doc, `
		Web-Dir-Browsing,Web-Http-Errors,Web-App-Dev,Web-CGI,Web-Health, `
		Web-Http-Logging,Web-Log-Libraries,Web-Request-Monitor,Web-Security, `
		Web-Filtering,Web-Performance,Web-Stat-Compression,Web-Mgmt-Tools, `
		Web-Mgmt-Service,WAS,WAS-Process-Model,WAS-NET-Environment, `
		WAS-Config-APIs,Net-Framework-Core -IncludeManagementTools | Out-Null
}

[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

# Enable Remote Management Service
"  - Enabling Remote Management"
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\WebManagement\Server EnableRemoteManagement 1
Set-Service WMSVC -StartupType Automatic
Start-Service WMSVC

"Done."

# Download and install the "URL Rewrite 2.0" Extension for IIS
"`r`nURL Rewrite 2.0 Extension for IIS ..."
"  - Downloading"
Invoke-WebRequest "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi" -OutFile "rewrite_amd64.msi"
"  - Installing"
Start-Process "msiexec.exe" "/i rewrite_amd64.msi /qn" -Wait
"Done."

<#
==================== File System Security PowerShell Module ====================
#>

# Download and extract the "File System Security PowerShell Module"
"`r`nFile System Security PowerShell Module ..."
Install-Module -Name NTFSSecurity -RequiredVersion 4.2.4  -Repository PSGallery -Force
"Done."

<#
===================== Visual C++ Redistributable Packages ======================
#>

# Download and install the Visual C++ 2013 Redistributable (required for MySQL)
"`r`nVisual C++ 2013 Redistributable ..."
"  - Downloading"
Invoke-WebRequest "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe" -OutFile "vc_redist_2013_x64.exe"
"  - Installing"
.\vc_redist_2013_x64.exe /Q
"Done."

# Download and install the Visual C++ 2015 Redistributable (required for PHP 7.x)
"`r`nVisual C++ 2015 Redistributable ..."
"  - Downloading"
Invoke-WebRequest "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe" -OutFile "vc_redist_2015_x64.exe"
"  - Installing"
.\vc_redist_2015_x64.exe /Q
"Done."


<#
=================================== PHP 7.2 ====================================
#>

# Download and install PHP
"`r`nPHP 7.2 ..."
"  - Downloading"
Install-Module -Name PhpManager -Repository PSGallery -Force
Install-Php -Version 7.2 -Architecture x64 -ThreadSafe 0 -Path C:\PHP -TimeZone UTC -Force
"Done."

“Configure various PHP settings”
Set-PhpIniKey date.timezone UTC  C:\PHP
Set-PhpIniKey upload_max_filesize 20M  C:\PHP
"Done."

"Done."

# Download and install WinCache
"`r`nWinCache 2.0 ..."
"  - Downloading"
Invoke-WebRequest "https://windows.php.net/downloads/pecl/releases/wincache/2.0.0.8/php_wincache-2.0.0.8-7.2-nts-vc15-x64.zip" -OutFile "php_wincache-2.0.0.8-7.2-nts-vc15-x64.zip"
"  - Expanding"
Expand-Archive $env:USERPROFILE\Downloads\php_wincache-2.0.0.8-7.2-nts-vc15-x64.zip $env:USERPROFILE\Downloads\wincache\
"  - Installing"
Copy-Item "wincache\php_wincache.dll" "C:\PHP\\ext\php_wincache.dll"

“Enabling Mysqliextensions”
Enable-PhpExtension mysqli C:\PHP

“Enabling PHP-Wincache Extention”
"  - Removing temporary files"
Enable-PhpExtension wincache C:\PHP

Remove-Item "wincache" -Recurse -Force
"Done."




"`r`nConfigure PHP with IIS ..."

# Adding Index.php in default documents

add-webconfigurationproperty /system.webServer/defaultDocument -name files -value @{value="index.php"}

#Install Module for FastCGI
New-WebHandler -Name PHPFASTCGI -PATH "*.php" -Verb "*" -Modules "FastCgiModule" -ScriptProcessor "C:\PHP\php-cgi.exe"  -ResourceType "Either"

Add-NTFSAccess C:\PHP\Upload IUSR Modify
Add-NTFSAccess C:\PHP\Upload IIS_IUSRS Modify

"Done."

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
