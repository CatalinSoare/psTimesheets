[CmdletBinding()]
param(
    $startDate = '2023-10-01',
    $endDate = '2023-10-27'
)

# test that we have the get-FirefoxHistory command available before continuing
# I expect it to be defined in the PS Profile
try  {
    Get-Command -Name get-FirefoxHistory -ErrorAction Stop
} catch [System.Management.Automation.ActionPreferenceStopException]{
    Write-Host "the `"get-FirefoxHistory`" cmdlet needs to be defined!" -ForegroundColor Red -BackgroundColor Black
    exit 1
}

$now = Get-Date
$ExportPath = "${env:USERPROFILE}\work\FRQ\ZZ_timeshits"
if (! (Test-Path $ExportPath -ErrorAction SilentlyContinue)) { mkdir $ExportPath | Out-Null}
Write-Host "The export path is: $ExportPath. Check that folder for CSV files"

$reportStart = Get-Date -Month $now.Month -Year $now.Year -Day 1 -Hour 0 -Minute 0 -Second 0
$reportEnd = Get-Date -Month $now.Month -Year $now.Year -Day $now.Day -Hour 0 -Minute 0 -Second 0

foreach ($day in (1..$now.Day)) {
    if ($day -lt 10) { $day = "0$day" }
    Write-Host "Getting browser history for: " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "$($now.Year)-$($now.Month)-$day" -ForegroundColor Green -BackgroundColor Black
    get-FirefoxHistory -on "$($now.Year)-$($now.Month)-$day" | Export-Csv -Force -Path $ExportPath\"$($now.Year)-$($now.Month)-$($day).csv" -ErrorAction SilentlyContinue
}
Write-Host "Generating the whole month report..."
Import-Csv (Get-ChildItem -Path $ExportPath -Filter "$($now.Year)-$($now.Month)-*.csv") | Export-Csv $ExportPath\"$($now.Year)-$($now.Month).csv"
Write-Host "Done"
Import-Csv $ExportPath\"$($now.Year)-$($now.Month).csv" | ogv
