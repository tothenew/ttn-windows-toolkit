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
