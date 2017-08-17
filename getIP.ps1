Import-Module NetAdapter

$ipPath = 'C:\silk\VSROExecutor\ip.txt'
$exists = [System.IO.File]::Exists($ipPath)

if (!$exists) {
    $ip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

    $streamWriter = [System.IO.StreamWriter] $ipPath
    $streamWriter.Write($ip)
    $streamWriter.Close()
} else {
    $streamReader = [System.IO.StreamReader] $ipPath
    $readIP = $streamReader.ReadToEnd()
    $streamReader.Close()

    $ip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

    if (!$ip.Equals($readIP)) {
        echo "Different IP, killing Server!"

        Remove-Item $ipPath

        $newStreamWriter = [System.IO.StreamWriter] $ipPath
        $newStreamWriter.Write($ip)
        $newStreamWriter.Close()
        
        $stopVSROPath = 'C:\silk\VSROExecutor\stopVSRO.bat'
        start $stopVSROPath

        $netAdapter = Get-NetAdapter -Name "Ethernet 2"
        Get-NetIPAddress -IPAddress $readIP | Remove-NetIPAddress -Confirm:$false
        $netAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $ip -PrefixLength 24 -Type Unicast
        
        $srNodeTypePath = 'C:\silk\cert_server\Certification\ini\srNodeType.ini'
        $newsrNodeType = [System.IO.File]::ReadAllText($srNodeTypePath).Replace($readIP, $ip)
        [System.IO.File]::WriteAllText($srNodeTypePath, $newsrNodeType)

        $serverPath = 'C:\silk\cert_server\Server Files\server.cfg'
        $newServer = [System.IO.File]::ReadAllText($serverPath).Replace($readIP, $ip)
        [System.IO.File]::WriteAllText($serverPath, $newServer)

        $serviceManagerPath = 'C:\silk\cert_server\Server Files\ServiceManager.cfg'
        $newServiceManager = [System.IO.File]::ReadAllText($serviceManagerPath).Replace($readIP, $ip)
        [System.IO.File]::WriteAllText($serviceManagerPath, $newServiceManager)

        $SMCUpdaterPath = 'C:\silk\cert_server\Server Files\server.cfg'
        $newSMCUpdater = [System.IO.File]::ReadAllText($SMCUpdaterPath).Replace($readIP, $ip)
        [System.IO.File]::WriteAllText($SMCUpdaterPath, $newSMCUpdater)

        Start-Sleep -s 5

        echo "Changes made, relaunching!"
        
        $startVSROPath = 'C:\silk\VSROExecutor\startVSRO.bat'
        start "startVSRO.bat"
    }
}