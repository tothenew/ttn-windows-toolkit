#Install MySQL-8.0.
Invoke-WebRequest "https://downloads.mysql.com/archives/get/p/25/file/mysql-installer-web-community-8.0.37.0.msi" -OutFile "mysql_8.0.msi"
Start-Process "msiexec.exe" "/i mysql_8.0.msi /qn" -Wait

# Install MySQL as a Windows service
mysqld --install

# Start the MySQL service
Start-Service MySQL

# Generate random passwords for 'root' and 'WordPress' accounts
Add-Type -AssemblyName System.Web
$MYSQL_ROOT_PWD = [System.Web.Security.Membership]::GeneratePassword(18,3)
$MYSQL_WORD_PWD = [System.Web.Security.Membership]::GeneratePassword(18,3)

# Create a MySQL initialisation script
Set-Content $MYSQL_INIT "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD';"
Add-Content $MYSQL_INIT "CREATE DATABASE wordpress;"
Add-Content $MYSQL_INIT "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '$MYSQL_WORD_PWD';"
Add-Content $MYSQL_INIT "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"

# Execute the MySQL initialisation script
mysql --user=root --execute="source $MYSQL_INIT"

# Delete the MySQL initialisation script
Remove-Item $MYSQL_INIT
