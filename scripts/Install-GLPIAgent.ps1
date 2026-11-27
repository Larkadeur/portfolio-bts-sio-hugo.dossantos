$GlpiServer = "http://172.17.8.60/glpi/front/inventory.php"
$MsiName    = "GLPI-Agent-1.19-x64.msi"
$Tag        = "TEST-AGENT"
$Reg = "HKLM:\SOFTWARE\GLPI-Agent"
$Dir = "C:\Program Files\GLPI-Agent"

function Log($m, $c = "White") {
    $l = "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')  $m"
    Write-Host $l -ForegroundColor $c
    Add-Content "C:\Windows\Temp\GLPI-Agent-install.log" $l
}

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Lancer ce script dans un PowerShell administrateur." -ForegroundColor Red
    exit 1
}

Log "===== Debut installation agent GLPI sur $env:COMPUTERNAME =====" Cyan

$v = (Get-ItemProperty "$Reg\Installer" -ErrorAction SilentlyContinue).Version
if ($v) { Log "Agent deja installe (version $v), il sera reconfigure." Yellow }

$Msi = Join-Path $PSScriptRoot $MsiName
if (-not (Test-Path $Msi)) { Log "MSI introuvable : $Msi" Red; exit 1 }

if (Test-Connection ([Uri]$GlpiServer).Host -Count 1 -Quiet) {
    Log "Serveur GLPI joignable." Green
} else {
    Log "Serveur GLPI injoignable, inventaire envoye plus tard." Yellow
}

$p = Start-Process msiexec.exe -Wait -PassThru -ArgumentList "/i `"$Msi`" /quiet SERVER=`"$GlpiServer`" TAG=`"$Tag`" EXECMODE=1 RUNNOW=1 ADD_FIREWALL_EXCEPTION=1 /l*v C:\Windows\Temp\GLPI-Agent-msi.log"
if ($p.ExitCode -notin 0, 3010) { Log "Echec de l'installation (code $($p.ExitCode))." Red; exit $p.ExitCode }
Log "Installation terminee (code $($p.ExitCode))." Green

Set-ItemProperty $Reg -Name server -Value $GlpiServer
Set-ItemProperty $Reg -Name tag -Value $Tag
Log "Serveur configure : $((Get-ItemProperty $Reg).server)" Green

Restart-Service glpi-agent; Start-Sleep 5
if ((Get-Service glpi-agent).Status -eq "Running") { Log "Service glpi-agent demarre." Green } else { Log "Service glpi-agent arrete." Red }

Log "Envoi d'un inventaire immediat..."
& "$Dir\glpi-agent.bat" --force | Out-Null
Get-Content "$Dir\logs\glpi-agent.log" -Tail 10 | ForEach-Object { Log "   $_" }

Log "===== Fin. Verifier le PC dans GLPI : Parc > Ordinateurs =====" Cyan
