###################################################################################################
## mdhSteamScreenshotsDownloader(by Moerderhoschi) v2025-05-31
## github: https://github.com/Moerderhoschi/mdhSteamScreenshotsDownloader
## a set of Javascript and Powershell code to download screenshots from steam
###################################################################################################

param ([int]$p1, [string]$p2, [int]$p3, [int]$p4, [int]$p5, [int]$p6, [int]$p7, [int]$p8=0)

$debug = 0
if ($debug -eq 1) {$start = (Get-Date)}
$array = $p4..$p5
$q = @() 
$r = @() 

if ($p1 -eq 3) {$array = gc links.log}

$y = "id"
$endLoop = 0
$array | ForEach-Object {

	if ($endLoop -eq 1) {return}
	
	$url = "https://steamcommunity.com/"+$y+"/"+$p2+"/screenshots/?p="+$_+"&appid="+$p3+"&sort=newestfirst&view=grid"
	if ($p1 -ne 3) {
		if ($p1 -eq 2) {
			$url = "https://steamcommunity.com/"+$y+"/"+$p2+"/screenshots/?p="+$_+"&appid="+$p3+"&sort=oldestfirst&view=grid"
		}
		
		Write-Host "----------------------------------------------------------------------" 
		Write-Host "scanning site $url" 
		Write-Host "----------------------------------------------------------------------" 
		$links = @() 
		$array2 = 1..9 
		$array2 | ForEach-Object {
			if ($links.count -eq 0) {
				try {$response = wget -UseBasicPArsing $url} catch {}
if ($debug -eq 1) {$now = (Get-Date) - $start ; $now = $now.ToString().SubString(6) ; write-host "$now : wget screenshots page" ; $start = (Get-Date)}
				if ($?) {
					$response = $response.RawContent
					$links = [regex]::Matches($response, 'https://steamcommunity.com/sharedfiles/filedetails/\?id=\d+')		
				}
				if ($links.count -eq 0) {
					Write-Host "no pics found on $url, retry $_/9"
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
					try {$response = wget -UseBasicPArsing $url} catch {}
if ($debug -eq 1) {$now = (Get-Date) - $start ; $now = $now.ToString().SubString(6) ; write-host "$now : wget screenshots page instead id" ; $start = (Get-Date)}
					if ($?) {
						$response = $response.RawContent
						$links = [regex]::Matches($response, 'https://steamcommunity.com/sharedfiles/filedetails/\?id=\d+')		
					}
					if ($links.count -eq 0) {
						Write-Host "no pics found on $url, retry $_/9"
					}
				}
			}
		}

		if ($links.count -eq 0) {Write-Host "no pics found on $url, exit" ; $endLoop = 1 ; return}
	}
	else
	{
		$links = @($_)
	}

	$links1 = @() 
	foreach ($element in $links) {
		if ($links1 -notcontains $element) {
			$links1 += $element
		}
	}

	$links1 | ForEach-Object {
		if ($endLoop -eq 1) {return}
		$links2 = @()
		if ($p1 -ne 3) {
			$url2 = $_.Value
			#Write-Host "scanning pic site $url2"
			for ($i = 1; $i -le 5; $i++) {
				if ($i -eq 1 -or $? -eq $false) {
if ($debug -eq 1) {write-host "----------------------------------------------------------------------------------------------------------------------"}
					try {$response = wget -UseBasicPArsing $url2} catch {}
if ($debug -eq 1) {$now = (Get-Date) - $start ; $now = $now.ToString().SubString(6) ; write-host "$now : wget pic site" ; $start = (Get-Date)}
				}				
			}				

			if (-not $?) {
				Add-Content -Path ".\downloadLog.txt" -Value "error on scanning pic site $url2 of screenshotsite $url"
			} else {
				$response = $response.RawContent
				$links2 = [regex]::Match($response, 'https://images\.steamusercontent\.com/ugc/[^?]+')
				if (-not $links2.success) {
					Add-Content -Path ".\downloadLog.txt" -Value "error no screenshot found or Adult control on pic site $url2 of screenshotsite $url"
				}
			}
		}
		else
		{
			$links2 = @($_)
		}

		$links3 = @() 
		foreach ($element in $links2) {
			if ($links3 -notcontains $element) {
				$links3 += $element
			}
		}

		$links3 | ForEach-Object {
			if ($endLoop -eq 1) {return}
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
				#Write-Host "scanning pic $a"
				for ($i = 1; $i -le 5; $i++) {
					if ($i -eq 1 -or $? -eq $false) {
						try {$b=wget -UseBasicPArsing $a} catch {}
if ($debug -eq 1) {$now = (Get-Date) - $start ; $now = $now.ToString().SubString(6) ; write-host "$now : wget pic" ; $start = (Get-Date)}
					}				
				}				

				if (-not $?) {
					Add-Content -Path ".\downloadLog.txt" -Value "error on scanning pic $a of pic site $url2"
					return
				}
				
				$c=$b.headers['Content-Disposition'] 
				$d=$c -replace '.*filename="(.*)";', '$1'
				$e=$d.IndexOf('_') 
				$f=$d.SubString(0, $e) 
				$e=$d.IndexOf('_',$e+1) 

				$g=$d.SubString($d.IndexOf("."))
				$n="_"

				#Write-Host "found server filename $d"
				
				$h=$b.headers['Last-Modified'] 
				$j=[datetime]::Parse($h).ToUniversalTime() 
				$k=$j.ToString('yyyy_MM_dd HH_mm_ss') 
				if ($p7 -eq 2 -or $p7 -eq 4) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				#Write-Host "found Last-Modified Date $k"
				
				$m = 0
				if ($q.count -gt 0) {
					$o = $q.IndexOf($f)
					if ($o -ge 0) {
						$m = $r[$o]	
					}
				}
				
				if ($m -eq 0) {
					$m='https://steamcommunity.com/app/'+$f+'/discussions/' 
					#Write-Host "search for pic game name $f on SteamHub"
					try {$m=wget -UseBasicPArsing $m} catch {}
					$m=$m.Content -match '<div class="apphub_AppName ellipsis"[^>]*>(.*?)</div>' 
					if ($m -eq 'true') {$m = $matches[1].Trim() ; $q += $f ; $r += $m} else {
						$m='https://store.steampowered.com/app/'+$f+'/' 
						#Write-Host "search for pic game name $f on SteamStore"
						try {$m=wget -UseBasicPArsing $m} catch {}
						$m=$m.Content -match '<div id="appHubAppName"[^>]*>(.*?)</div>' 
						if ($m -eq 'true') {$m = $matches[1].Trim() ; $q += $f ; $r += $m} else {
							$m='https://steamcharts.com/app/'+$f 
							#Write-Host "search for pic game name $f on steamcharts.com"
							try {$m=wget -UseBasicPArsing $m} catch {}
							$m=$m.Content -match '<h1 id="app-title"><a href=""[^>]*>(.*?)</a></h1>' 
							#if ($m -eq 'true') {$m = $matches[1].Trim() ; $q += $f ; $r += $m} else {
								#$m='https://steamdb.info/app/'+$f 
								#Write-Host "search for pic game name $f on steamdb.info"
								#try {$m=wget -UseBasicPArsing $m} catch {}
								#$m=$m.Content -match '<h1 itemprop="name"[^>]*>(.*?)</h1>' 
								if ($m -eq 'true') {$m = $matches[1].Trim() ; $q += $f ; $r += $m} else {
									$m='UKNOWN_GAME' ; $q += $f ; $r += $m
								}
							#}
						} 
					} 
if ($debug -eq 1) {$now = (Get-Date) - $start ; $now = $now.ToString().SubString(6) ; write-host "$now : wget search for gamename" ; $start = (Get-Date)}
				}

				if ($url -like "https://steamcommunity.com/id/Moerderhoschi/screenshots/*") {
					if ($m -eq 'UKNOWN_GAME' -and $f -eq 14586209416903655424) {$m='Arma Cold War Assault' ; $f='65790'}
					if ($m -eq 'UKNOWN_GAME' -and $f -eq 271590) {$m='Grand Theft Auto V Legacy' ; $f='271590'}
					if ($m -eq 'UKNOWN_GAME' -and $f -eq 9974983548387459072) {$m='Grand Theft Auto V Legacy' ; $f='271590'}
					if ($m -eq 'UKNOWN_GAME' -and $f -eq 16769456153770852352) {$m='Grand Theft Auto V Legacy' ; $f='271590'}
					if ($m -eq 'UKNOWN_GAME' -and $f -eq 11423151661950959616) {$m='Tom Clancys The Division' ; $f='365590'}
					if ($m -eq 'UKNOWN_GAME' -and $f -eq 12200718730266673152) {$m='Tom Clancys Ghost Recon Wildlands' ; $f='460930'}
				}
				if ($m -eq 'UKNOWN_GAME' -and $f -eq 104320) {$m='Rising Storm Red Orchestra 2 Multiplayer' ; $f='35450'}
				
			
				if ($p7 -eq 3 -and $m -ne "UKNOWN_GAME") {$f=""}
				if ($p7 -eq 4 -and $m -ne "UKNOWN_GAME") {$f=""}

				$m = $m -replace '[\\\/:*?"<>|]', ' '
				$m = $m -replace '&amp;', '&'
				$m = $m -replace '&#39;', ''''
				$m = $m -replace '\s{2,}', ' '
				$m = $m.Trim()
				
				$l=$m+' '+$f+' '+$k+$g 
				$l = $l -replace '\s{2,}', ' '

				$path = ".\screenshots\"
				if ($p6 -eq 1) {
					if (-Not (Test-Path -Path ".\screenshots\$m")) {
						New-Item -Path ".\screenshots\$m" -ItemType Directory | Out-Null
					}
					$path = ".\screenshots\$m\"
				}

				$i2 = 1
				if (Test-Path "$path$l") {
					for ($i = 2; $i -le 9; $i++) {
						if (Test-Path "$path$l") {
							$x = gc "$path$l" -raw
							if ($b.RawContentLength -eq $x.Length) {
								Write-Host "$l duplicate file detected, skip download"
								Add-Content -Path ".\downloadLog.txt" -Value "$l duplicate file detected, skip download"
								if ($p8 -eq 1) {$endLoop = 1}
								$i2 = 99
								return
							}

							$l=$m+' '+$f+' '+$k+$n+$i.ToString()+$g 
							$l = $l -replace '\s{2,}', ' '
							$i2 = $i
						}
					}
if ($debug -eq 1) {$now = (Get-Date) - $start ; $now = $now.ToString().SubString(6) ; write-host "$now : search for duplicate" ; $start = (Get-Date)}
				}

				if ($i2 -eq 99) {return}
				
				Write-Host "download $l"
				$b.Content | Set-Content -Path "$path$l" -Encoding Byte
if ($debug -eq 1) {$now = (Get-Date) - $start ; $now = $now.ToString().SubString(6) ; write-host "$now : create pic" ; $start = (Get-Date)}
				if (-not $?) {
					Add-Content -Path ".\downloadLog.txt" -Value "error1 on writing pic $l from pic site $url2 to $path$l"
					#Write-Host "----------------------------------------"
					return
				}
				
				if (-not (Test-Path "$path$l")) {
					Add-Content -Path ".\downloadLog.txt" -Value "error2 on writing pic $l from pic site $url2 to $path$l"
					#Write-Host "----------------------------------------"
					return
				}
				
				if (Test-Path "$path$l") {
					Set-ItemProperty -Path "$path$l" -Name CreationTime -Value $h
					Set-ItemProperty -Path "$path$l" -Name LastWriteTime -Value $h
				}
				#Write-Host "----------------------------------------"
			}
		}
	}
}

if ($p6 -eq 1) {
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
}

if ($p8 -eq 0) {Read-Host "press any key to continue"}