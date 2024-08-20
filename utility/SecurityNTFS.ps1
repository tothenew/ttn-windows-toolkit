[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
#Enable NTFS Security Module
Install-Module -Name NTFSSecurity -RequiredVersion 4.2.4