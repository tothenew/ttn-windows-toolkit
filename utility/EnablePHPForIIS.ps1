# Adding Index.php in default documents

add-webconfigurationproperty /system.webServer/defaultDocument -name files -value @{value="index.php"}

#Install Module for FastCGI
New-WebHandler -Name PHPFASTCGI -PATH "*.php" -Verb "*" -Modules "FastCgiModule" -ScriptProcessor "C:\PHP\php-cgi.exe"  -ResourceType "Either"

Add-NTFSAccess C:\PHP\Upload IUSR Modify
Add-NTFSAccess C:\PHP\Upload IIS_IUSRS Modify

"Done."
