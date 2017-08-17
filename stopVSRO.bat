@echo off

taskkill /f /im smc.exe
taskkill /f /im SR_GameServer.exe
taskkill /f /im AgentServer.exe
taskkill /f /im SR_ShardManager.exe
taskkill /f /im FarmManager.exe
taskkill /f /im DownloadServer.exe
taskkill /f /im MachineManager.exe
taskkill /f /im GatewayServer.exe
taskkill /f /im GlobalManager.exe
taskkill /f /im CertificationServer.exe

del "C:\silk\cert_server\Server Files\*.dmp"

exit