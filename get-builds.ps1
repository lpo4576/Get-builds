#Declare variables
$computers = (Import-Csv -Path C:\pcs\stlpcs2.csv)
[pscustomobject[]]$finalresults = $null
$outputpath = "C:\temp\PCBuilds.csv"

Write-host ""
Write-host "Retrieving build numbers..." -ForegroundColor Yellow

#Grabs build number from registry of each PC and places in array
foreach ($pc in $computers) {
    $pcbuild = Invoke-Command -ComputerName $pc.hostname -ScriptBlock {(Get-ItemProperty -Path "HKLM:\software\Microsoft\windows NT\currentversion" -Name Releaseid).releaseid} -ErrorAction SilentlyContinue
    $results = '' | select Hostname,Build,Location
    $results.Hostname = $pc.Hostname
    $results.Build = $pcbuild
    $results.Location = $pc.Location
    $finalresults += $results
    }

$finalresults | Export-Csv -Path $outputpath
Write-host "Output placed in $outputpath" -ForegroundColor Green
pause