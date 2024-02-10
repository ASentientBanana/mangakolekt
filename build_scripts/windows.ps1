$libName = "manga_archive.dll";
$sourcePath = ".\unzip\$libName"
$releaseDestinationPath = ".\lib\dev_lib\"
$devDestinationPath = ".\build\windows\x64\runner\Release\"

# Go to unzip and run make windows
Set-Location -Path ".\unzip"

if (Test-Path ".\makefile") {
    Invoke-Expression "make windows"
    Write-Host "Make completed."
} else {
    Write-Host "Makefile not found."
}

Set-Location -Path ".."

# build flutter app
Invoke-Expression "flutter build windows"

# Copy the dll to dev folder
if (Test-Path $sourcePath) {
    Copy-Item -Path $sourcePath -Destination $devDestinationPath
    Write-Host "Dev dll copied successfully."
} else {
    Write-Host "Source file not found."
}

# Copy the dll to dev folder
if (Test-Path $sourcePath) {
    Copy-Item -Path $sourcePath -Destination $releaseDestinationPath
    Write-Host "Release dll copied successfully."
} else {
    Write-Host "Release file not found."
}


