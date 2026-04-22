Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$projectRoot = Split-Path -Parent $PSScriptRoot
$candidateSourcePaths = @(
    (Join-Path $projectRoot 'assets\branding\app_icon.png'),
    (Join-Path $projectRoot 'assets\images\neoncave_launcher_icon_source.png')
)

$sourcePath = $candidateSourcePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $sourcePath) {
    throw "Launcher icon source not found. Checked: $($candidateSourcePaths -join ', ')"
}

$androidIcons = @{
    'android\app\src\main\res\mipmap-mdpi\ic_launcher.png' = 48
    'android\app\src\main\res\mipmap-hdpi\ic_launcher.png' = 72
    'android\app\src\main\res\mipmap-xhdpi\ic_launcher.png' = 96
    'android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png' = 144
    'android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png' = 192
}

$iosIcons = @{
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\20.png' = 20
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\29.png' = 29
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\40.png' = 40
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\50.png' = 50
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\57.png' = 57
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\58.png' = 58
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\60.png' = 60
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\72.png' = 72
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\76.png' = 76
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\80.png' = 80
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\87.png' = 87
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\100.png' = 100
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\1024.png' = 1024
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\114.png' = 114
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\120.png' = 120
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\144.png' = 144
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\152.png' = 152
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\167.png' = 167
    'ios\Runner\Assets.xcassets\AppIcon.appiconset\180.png' = 180
}

$allIcons = $androidIcons + $iosIcons
$sourceImage = [System.Drawing.Image]::FromFile($sourcePath)

try {
    foreach ($entry in $allIcons.GetEnumerator()) {
        $destination = Join-Path $projectRoot $entry.Key
        $size = [int] $entry.Value

        $bitmap = New-Object System.Drawing.Bitmap $size, $size
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

        try {
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
            $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $graphics.Clear([System.Drawing.Color]::Transparent)

            # Center-crop to a square so non-square source art scales consistently.
            $srcSize = [Math]::Min($sourceImage.Width, $sourceImage.Height)
            $srcX = [Math]::Floor(($sourceImage.Width - $srcSize) / 2)
            $srcY = [Math]::Floor(($sourceImage.Height - $srcSize) / 2)
            $srcRect = New-Object System.Drawing.Rectangle($srcX, $srcY, $srcSize, $srcSize)

            $padding = [Math]::Max([int] [Math]::Round($size * 0.04), 1)
            $targetSize = $size - ($padding * 2)
            $destRect = New-Object System.Drawing.Rectangle($padding, $padding, $targetSize, $targetSize)

            $graphics.DrawImage($sourceImage, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

            $bitmap.Save($destination, [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally {
            $graphics.Dispose()
            $bitmap.Dispose()
        }
    }
}
finally {
    $sourceImage.Dispose()
}

Write-Output 'launcher-icons-regenerated'