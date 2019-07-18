[CmdletBinding()]
param()

$Username = Get-VstsInput -Name username -Require
$Password = Get-VstsInput -Name password -Require
$Action = Get-VstsInput -Name action -Require
$KempUri = Get-VstsInput -Name kempUri -Require
$IpConfigFile = Get-VstsInput -Name ipList -Require

function Get-Basic-Auth() {
    $Key = $Username + ":" + $Password
    $authVal = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($key))
    
    return @{ "Authorization" = $authVal }
}

function ToggleAddresses() {
    foreach ($server in $servers) {
        $serverLabel = $server.Label
        $realIP = $server.RealServerIP

        Write-Host "Toggling $serverLabel - $realIP..." -NoNewline

        $function = "enablers"
        if ($Action.ToLower() -eq "disable") {
            $function = "disablers"
        }

        $uri = "https://$KempUri/access/$function" +
            "?rs=$realIP"

        try {
            $response = Invoke-WebRequest -Uri $uri -Headers $auth -Method Get -UseBasicParsing -SkipCertificateCheck
            if ($response.StatusCode -eq 200) { Write-Host "OK" -ForegroundColor Green }
        }
        catch {
            Write-Host "##vso[task.logissue type=error;] $_" -ForegroundColor Red
            Write-Host "##vso[task.complete result=Failed;]"
        }
    }
}

Trace-VstsEnteringInvocation $MyInvocation
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $auth = Get-Basic-Auth
    $servers = Get-Content -Raw -Path $IpConfigFile | ConvertFrom-Json
    ToggleAddresses
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
