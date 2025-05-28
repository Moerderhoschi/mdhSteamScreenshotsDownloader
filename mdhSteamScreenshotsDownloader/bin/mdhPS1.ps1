###################################################################################################
## mdhSteamScreenshotsDownloader(by Moerderhoschi) v2025-05-28
## github: https://github.com/Moerderhoschi/mdhSteamScreenshotsDownloader
## a set of Javascript and Powershell code to download screenshots from steam
###################################################################################################

param ([int]$p1, [string]$p2, [int]$p3, [int]$p4, [int]$p5, [int]$p6, [int]$p7)

$array = $p4..$p5
$q = @() 
$r = @() 

if ($p1 -eq 3) {$array = gc links.log}

$y = "id"
$endLoop = 0
$array | ForEach-Object {

	if ($endLoop -eq 1) {return}
	
	if ($p1 -ne 3) {
		$url = "https://steamcommunity.com/"+$y+"/"+$p2+"/screenshots/?p="+$_+"&appid="+$p3+"&sort=newestfirst&view=grid"
		if ($p1 -eq 2) {
			$url = "https://steamcommunity.com/"+$y+"/"+$p2+"/screenshots/?p="+$_+"&appid="+$p3+"&sort=oldestfirst&view=grid"
		}
		
		Write-Output "scanning site $url" 
		Write-Output "----------------------------------------" 
	
		$links = @() 
		$array2 = 1..9 
		$array2 | ForEach-Object {
			if ($links.count -eq 0) {
				$response = wget -UseBasicPArsing $url
				$response = $response.RawContent
				$links = [regex]::Matches($response, 'https://steamcommunity.com/sharedfiles/filedetails/\?id=\d+')		
				if ($links.count -eq 0) {
					Write-Output "no pics found on $url, retry $_/9"
				}
			}
		}

		if ($links.count -eq 0) {
			if ($y -eq "id") {$y = "profiles"} else {$y = "id"}
			$url = "https://steamcommunity.com/"+$y+"/"+$p2+"/screenshots/?p="+$_+"&appid="+$p3+"&sort=newestfirst&view=grid"
			if ($p1 -eq 2) {
				$url = "https://steamcommunity.com/"+$y+"/"+$p2+"/screenshots/?p="+$_+"&appid="+$p3+"&sort=oldestfirst&view=grid"
			}

			$array2 | ForEach-Object {
				if ($links.count -eq 0) {
					$response = wget -UseBasicPArsing $url
					$response = $response.RawContent
					$links = [regex]::Matches($response, 'https://steamcommunity.com/sharedfiles/filedetails/\?id=\d+')		
					if ($links.count -eq 0) {
						Write-Output "no pics found on $url, retry $_/9"
					}
				}
			}
		}

		if ($links.count -eq 0) {Write-Output "no pics found on $url, exit" ; $endLoop = 1 ; return}
	}
	else
	{
		$links = @($_)
	}

	$links | ForEach-Object {
		if ($p1 -ne 3) {
			$url = $_.Value
			Write-Output "scanning pic site $url"
			$response = wget -UseBasicPArsing $url
			$response = $response.RawContent
			$links2 = [regex]::Match($response, 'https://images\.steamusercontent\.com/ugc/[^?]+')
		}
		else
		{
			$links2 = @($_)
		}

		$links2 | ForEach-Object {
			if ($p1 -eq 3) {
				$a=$_.SubString($_.IndexOf('https://images.steamusercontent.com/ugc/')) 
				$i=$a.indexOf('/',40) 
				$i=$a.indexOf('/',$i+1) 
				$a=$a.subString(0, $i+1) 
			}
			else
			{
				$a=$_.Value
			}
			
			if ($a.Contains("https://images.steamusercontent.com/ugc/")) {
				Write-Output "scanning pic $a"
				$b=wget -UseBasicPArsing $a 
				$c=$b.headers['Content-Disposition'] 
				$d=$c -replace '.*filename="(.*)";', '$1' 
				$e=$d.IndexOf('_') 
				$f=$d.SubString(0, $e) 
				$e=$d.IndexOf('_',$e+1) 
				$e=$d.IndexOf('_',$e+1) 
				$g=$d.SubString($e) 
				if ($p7 -eq 2) {$g=" " + $g.SubString(1)}
				if ($p7 -eq 4) {$g=" " + $g.SubString(1)}
				if ($p7 -eq 6) {$g=" " + $g.SubString(1)}
				if ($p7 -eq 8) {$g=" " + $g.SubString(1)}
				Write-Output "found server filename $d"
				
				$h=$b.headers['Last-Modified'] 
				$j=[datetime]::Parse($h).ToUniversalTime() 
				$k=$j.ToString('yyyy_MM_dd HH_mm_ss') 
				if ($p7 -eq 3) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				if ($p7 -eq 4) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				if ($p7 -eq 7) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				if ($p7 -eq 8) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				
				Write-Output "found Last-Modified Date $k"
				
				$m = 0
				if ($q.count -gt 0) {
					$o = $q.IndexOf($f)
					if ($o -ge 0) {
						$m = $r[$o]	
					}
				}
				
				if ($m -eq 0) {
					$m='https://steamcommunity.com/app/'+$f+'/discussions/' 
					Write-Output "search for pic game name $f on SteamHub"
					$m=wget -UseBasicPArsing $m 
					$m=$m.Content -match '<div class="apphub_AppName ellipsis"[^>]*>(.*?)</div>' 
					if ($m -eq 'true') {$m = $matches[1] ; $q += $f ; $r += $m} else {
						$m='https://store.steampowered.com/app/'+$f+'/' 
						Write-Output "search for pic game name $f on SteamStore"
						$m=wget -UseBasicPArsing $m 
						$m=$m.Content -match '<div id="appHubAppName"[^>]*>(.*?)</div>' 
						if ($m -eq 'true') {$m = $matches[1] ; $q += $f ; $r += $m} else {
							$m='https://steamcharts.com/app/'+$f 
							Write-Output "search for pic game name $f on steamcharts.com"
							$m=wget -UseBasicPArsing $m 
							$m=$m.Content -match '<h1 id="app-title"><a href=""[^>]*>(.*?)</a></h1>' 
							#if ($m -eq 'true') {$m = $matches[1] ; $q += $f ; $r += $m} else {
								#$m='https://steamdb.info/app/'+$f 
								#Write-Output "search for pic game name $f on steamdb.info"
								#$m=wget -UseBasicPArsing $m 
								#$m=$m.Content -match '<h1 itemprop="name"[^>]*>(.*?)</h1>' 
								if ($m -eq 'true') {$m = $matches[1] ; $q += $f ; $r += $m} else {
									$m='UKNOWN_GAME' ; $q += $f ; $r += $m
								}
							#}
						} 
					} 
				}
			
				if ($p7 -eq 5 -and $m -ne "UKNOWN_GAME") {$f=""}
				if ($p7 -eq 6 -and $m -ne "UKNOWN_GAME") {$f=""}
				if ($p7 -eq 7 -and $m -ne "UKNOWN_GAME") {$f=""}
				if ($p7 -eq 8 -and $m -ne "UKNOWN_GAME") {$f=""}

				$m = $m -replace '[\\\/:*?"<>|]', ' '
				$m = $m -replace '&amp;', '&'
				$m = $m -replace '\s{2,}', ' '
				
				$l=$m+' '+$f+' '+$k+$g 
				$l = $l -replace '\s{2,}', ' '

				Write-Output "setup final name to $l and download"

				$path = ".\screenshots\"
				if ($p6 -eq 1) {
					if (-Not (Test-Path -Path ".\screenshots\$m")) {
						New-Item -Path ".\screenshots\$m" -ItemType Directory
					}
					$path = ".\screenshots\$m\"
				}
				$b.Content | Set-Content -Path "$path$l" -Encoding Byte
				Set-ItemProperty -Path "$path$l" -Name CreationTime -Value $h
				Set-ItemProperty -Path "$path$l" -Name LastWriteTime -Value $h
				Write-Output "----------------------------------------"
			}
		}
	}
}

cd screenshots
Start-Sleep -Seconds 3
Get-ChildItem -Directory | ForEach-Object {
    [PSCustomObject]@{
        Folder = $_.FullName
		Files  = (Get-ChildItem -Path $_.FullName -Recurse).Count
    }
}