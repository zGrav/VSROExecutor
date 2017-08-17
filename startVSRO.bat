@echo off

echo TODO GET IP

del "C:\silk\cert_server\Server Files\*.dmp"

CD "C:\silk\VSROExecutor"

CD ..\cert_server\certification
start /min Convert.exe ini ini dat packt.dat
CHOICE /N /T 2 /D y /M " 0) CustomCertification compiled:"
taskkill /f /im Convert.exe

start /min CertificationServer.exe packt.dat
CHOICE /N /T 4 /D y /M " 1) CertificationServer executed:"
CD ..
CD "Server Files"

start GlobalManager.exe
CHOICE /N /T 4 /D y /M " 2) GlobalManager executed:"

start GatewayServer.exe
CHOICE /N /T 4 /D y /M " 3) GatewayServer executed:"

start MachineManager.exe
CHOICE /N /T 4 /D y /M " 4) MachineManager executed:"

start DownloadServer.exe
CHOICE /N /T 4 /D y /M " 5) DownloadServer executed:"

start FarmManager.exe
CHOICE /N /T 4 /D y /M " 6) FarmManager executed:"

REM good ol' batch fake sleep
ping 127.0.0.1 -n 10 > nul 

start SR_ShardManager.exe
CHOICE /N /T 4 /D y /M " 7) SR_ShardManager executed:"

start AgentServer.exe
CHOICE /N /T 4 /D y /M " 8) AgentServer executed:"

start SR_GameServer.exe
CHOICE /N /T 4 /D y /M " 9) SR_GameServer executed:"

start smc.exe
CHOICE /N /T 4 /D y /M "10) smc executed:"

exit
