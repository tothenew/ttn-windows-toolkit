#Install Visual C++
Invoke-WebRequest "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe" -OutFile "vc_redist_2013_x64.exe"
.\vc_redist_2013_x64.exe /Q
Invoke-WebRequest "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe" -OutFile "vc_redist_2015_x64.exe"
.\vc_redist_2015_x64.exe /Q
