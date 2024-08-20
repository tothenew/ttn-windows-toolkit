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
