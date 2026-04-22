param(
    [string]$DeviceId = 'emulator-5554',
    [switch]$SkipRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$androidRoot = Join-Path $projectRoot 'android'

Push-Location $projectRoot
try {
    Write-Host '[1/6] Stopping Gradle daemons...'
    Push-Location $androidRoot
    try {
        .\gradlew.bat --stop | Out-Host
    }
    finally {
        Pop-Location
    }

    Write-Host '[2/6] Cleaning Flutter and Android build outputs...'
    flutter clean | Out-Host
    $androidBuildPath = Join-Path $androidRoot 'app\build'
    if (Test-Path $androidBuildPath) {
        Remove-Item -Path $androidBuildPath -Recurse -Force
    }

    Write-Host '[3/6] Resolving Dart/Flutter packages...'
    flutter pub get | Out-Host

    Write-Host '[4/6] Pre-warming Android resources task...'
    Push-Location $androidRoot
    try {
        .\gradlew.bat app:processDebugResources --stacktrace | Out-Host
    }
    finally {
        Pop-Location
    }

    Write-Host '[5/6] Building debug APK...'
    flutter build apk --debug | Out-Host

    if (-not $SkipRun) {
        Write-Host '[6/6] Launching app on device...'
        flutter run -d $DeviceId --no-resident | Out-Host
    }
    else {
        Write-Host '[6/6] Run step skipped by flag.'
    }
}
finally {
    Pop-Location
}


