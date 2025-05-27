param ([int]$p1, [string]$p2, [int]$p3, [int]$p4, [int]$p5)

$array = $p4..500 ;

if ($p1 -eq 3) {$array = gc links.log}
#gc links.log | ForEach-Object {} 

$array | ForEach-Object {

	if ($p1 -ne 3) {
		$url = "https://steamcommunity.com/id/"+$p2+"/screenshots/?p="+$_+"&appid="+$p3+"&sort=newestfirst&view=grid"
		if ($p1 -eq 2) {
			$url = "https://steamcommunity.com/id/"+$p2+"/screenshots/?p="+$_+"&appid="+$p3+"&sort=oldestfirst&view=grid"
		}
		
		Write-Output "scanning site $url" ;
		Write-Output "----------------------------------------" ;
	
		$links = @() ;
		$array2 = 1..5 ;
		$array2 | ForEach-Object {
			if ($links.count -eq 0) {
				$response = wget -UseBasicPArsing $url
				$response = $response.RawContent
				$links = [regex]::Matches($response, 'https://steamcommunity.com/sharedfiles/filedetails/\?id=\d+')		
				if ($links.count -eq 0) {
					Write-Output "no pics found on $url, retry $_/5"
				}
			}
		}
		if ($links.count -eq 0) {Write-Output "no pics found on $url, exit" ; exit}
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
				$d=$c -replace '.*filename=\"(.*)\";', '$1' 
				$e=$d.IndexOf('_') 
				$f=$d.SubString(0, $e) 
				$e=$d.IndexOf('_',$e+1) 
				$e=$d.IndexOf('_',$e+1) 
				$g=$d.SubString($e) 
				if ($p5 -eq 2) {$g=" " + $g.SubString(1)}
				if ($p5 -eq 4) {$g=" " + $g.SubString(1)}
				if ($p5 -eq 6) {$g=" " + $g.SubString(1)}
				if ($p5 -eq 8) {$g=" " + $g.SubString(1)}
				Write-Output "found server filename $d"
				
				$h=$b.headers['Last-Modified'] 
				$j=[datetime]::Parse($h).ToUniversalTime() 
				$k=$j.ToString('yyyy_MM_dd HH_mm_ss') 
				if ($p5 -eq 3) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				if ($p5 -eq 4) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				if ($p5 -eq 7) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				if ($p5 -eq 8) {$k=$j.ToString('yyyy-MM-dd HH_mm_ss')}
				
				Write-Output "found Last-Modified Date $k"
				
				$m='https://steamcommunity.com/app/'+$f+'/discussions/' 
				Write-Output "search for pic game name $f on SteamHub"
				$m=wget -UseBasicPArsing $m 
				$m=$m.Content -match '<div class=\"apphub_AppName ellipsis\"[^>]*>(.*?)</div>' 
				if ($m -eq 'true') {$m=$matches[1]} else {
					$m='https://store.steampowered.com/app/'+$f+'/' 
					Write-Output "search for pic game name $f on SteamStore"
					$m=wget -UseBasicPArsing $m 
					$m=$m.Content -match '<div id=\"appHubAppName\"[^>]*>(.*?)</div>' 
					if ($m -eq 'true') {$m=$matches[1]} else {
						$m='https://steamcharts.com/app/'+$f 
						Write-Output "search for pic game name $f on steamcharts.com"
						$m=wget -UseBasicPArsing $m 
						$m=$m.Content -match '<h1 id=\"app-title\"><a href=\"\"[^>]*>(.*?)</a></h1>' 
						if ($m -eq 'true') {$m=$matches[1]} else {
							$m=''
						}
					} 
				} 
			
				if ($p5 -eq 5) {$f=""}
				if ($p5 -eq 6) {$f=""}
				if ($p5 -eq 7) {$f=""}
				if ($p5 -eq 8) {$f=""}
				$l=$m+' '+$f+' '+$k+$g 
				Write-Output "setup name to $l"
				$pattern = 
				$l = $l -replace '[\\\/:*?"<>|]', ' '
				$l = $l -replace '\s{2,}', ' '
				Write-Output "setup final name to $l and download"

				wget -UseBasicPArsing $a -o screenshots\$l
				Write-Output "----------------------------------------"
			}
		}
	}
}