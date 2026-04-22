$ErrorActionPreference = 'Stop'

$srcDir = 'C:\xampp\htdocs\neoncave-v1.2\public\uploads\photos\site_logo\2025\10'
$dstDir = 'D:\ncg flutter v1.0.0\assets\branding'

# Navy badge (light theme splash)
$lightSrc = Join-Path $srcDir 'ncg-arena-high-resolution-logo-transparent-68f265c45c4b4.png'
$lightDst = Join-Path $dstDir 'logo_stacked_light.png'
Copy-Item -Path $lightSrc -Destination $lightDst -Force
Write-Output "LIGHT_COPIED: $((Get-Item $lightDst).Length) bytes"

# White text (dark theme splash)
$darkSrc = Join-Path $srcDir 'ncg-arena-high-resolution-logo-white-transparent-68f3fa24ae281.png'
$darkDst = Join-Path $dstDir 'logo_stacked_dark.png'
Copy-Item -Path $darkSrc -Destination $darkDst -Force
Write-Output "DARK_COPIED: $((Get-Item $darkDst).Length) bytes"

Write-Output 'DONE'
