cd..
cd screenshots

$sourceFolder = ".\"
$destinationFolder = ".\!movedScreenhots"

Get-ChildItem -Path $sourceFolder -Filter *.jpg | ForEach-Object {
    $filename = $_.Name
    $filePath = $_.FullName

    if ($filename -match '^(.*\D)(\d+)\s+\d{4}-\d{2}-\d{2}') {
        $newFolderName = $matches[1] + $matches[2]
    } else {
		Write-Host "No matching format found for the file: $filename"
        return
    }

    $newFolderPath = Join-Path $destinationFolder $newFolderName
    if (-not (Test-Path $newFolderPath)) {
        New-Item -Path $newFolderPath -ItemType Directory
    }

    $newFilePath = Join-Path $newFolderPath $filename
    Move-Item -Path $filePath -Destination $newFilePath

	Write-Host "Image '$filename' has been moved to the folder '$newFolderPath'."
}

Write-Host "------------------"
Read-Host -Prompt "Press any key to continue..."