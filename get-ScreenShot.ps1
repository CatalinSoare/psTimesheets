# get screen resolution

try {
    Add-Type -AssemblyName System.Windows.Forms | Out-Null
    $screenWidth = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
    $screenHeight = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
} catch {
    Write-Host "Couldn't get screen resolution. Setting them manually"
    $screenWidth = 1920
    $screenHeight = 1080
}

$now = Get-Date
$screenshotsPath = "${env:USERPROFILE}\Pictures\Timeshots\$($now.year)\$($now.Month)\$($now.Day)"

if (! (Test-Path $screenshotsPath)) { mkdir $screenshotsPath -Force | Out-Null }

[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
function screenshot([Drawing.Rectangle]$bounds, $path) {
   $image = New-Object Drawing.Bitmap $bounds.width, $bounds.height
   $graphics = [Drawing.Graphics]::FromImage($image)
   $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
   $image.Save($path)
   $graphics.Dispose()
   $image.Dispose()
}

$bounds = [Drawing.Rectangle]::FromLTRB(0, 0, $screenWidth, $screenHeight)
screenshot $bounds "$screenshotsPath\timeshot-$($now.Hour)-$($now.Minute)-$($now.Second).png"
