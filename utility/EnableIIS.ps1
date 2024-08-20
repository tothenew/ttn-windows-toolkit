#Enable IIS ServerRole and Feature on Windows Server or Windows Client
If ((Get-CimInstance Win32_OperatingSystem).ProductType -eq 1) {
    # For Windows Client
    Enable-WindowsOptionalFeature -FeatureName IIS-WebServerRole,IIS-WebServer,IIS-CommonHttpFeatures,IIS-StaticContent,IIS-DefaultDocument,IIS-DirectoryBrowsing,IIS-HttpErrors,IIS-ApplicationDevelopment,IIS-CGI,IIS-HealthAndDiagnostics,IIS-HttpLogging,IIS-LoggingLibraries,IIS-RequestMonitor,IIS-Security,IIS-RequestFiltering,IIS-Performance,IIS-HttpCompressionStatic,IIS-WebServerManagementTools,IIS-ManagementConsole,IIS-ManagementService,WAS-WindowsActivationService,WAS-ProcessModel,WAS-NetFxEnvironment,WAS-ConfigurationAPI,NetFx3 -Online -All -Source D:\Sources\sxs | Out-Null
} Else {
    # For Windows Server
    Install-WindowsFeature Web-Server,Web-Common-Http,Web-Static-Content,Web-Default-Doc,Web-Dir-Browsing,Web-Http-Errors,Web-App-Dev,Web-CGI,Web-Health,Web-Http-Logging,Web-Log-Libraries,Web-Request-Monitor,Web-Security,Web-Filtering,Web-Performance,Web-Stat-Compression,Web-Mgmt-Tools,Web-Mgmt-Service,WAS,WAS-Process-Model,WAS-NET-Environment,WAS-Config-APIs,Net-Framework-Core -IncludeManagementTools | Out-Null
}
