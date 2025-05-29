cd..
cd screenshots

$c = 0
Write-Host "----------------------------"
Write-Host "Screenshots folder overview"
Write-Host "----------------------------"
Get-ChildItem -Directory | ForEach-Object {
        $Folder = $_.Name
		$Files  = (Get-ChildItem -Path $_.FullName -Recurse).Count
	Write-Host "$($Files.ToString().PadLeft(4)) - $($Folder)"
	$c += $Files
}

Write-Host ""
Write-Host "$($c.ToString().PadLeft(4)) - allFolders"
Write-Host "----------------------------"
Read-Host -Prompt "Press any key to continue..."