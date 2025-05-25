@echo off
goto oStart
///////////////////////////////////////////////////////////////////////////////////////////////////
// mdhSteamScreenshotsDownloader(by Moerderhoschi) - v2025-05-25
// github: https://github.com/Moerderhoschi/mdhSteamScreenshotsDownloader
// a set of Javascript and Powershell code to download screenshots from steam
///////////////////////////////////////////////////////////////////////////////////////////////////
1. In your browser go to the Steam Screenshots page e.g. https://steamcommunity.com/id/Moerderhoschi/screenshots/
2. open the webbrowser developer tools (for chrome F12)
3. insert the following code and hit enter:
document.querySelectorAll('a').forEach(link =>{if (link.href.includes("steamcommunity.com/sharedfiles/filedetails/?id=")){fetch(link.href).then(response => {return response.text();}).then(html =>{let parser = new DOMParser();let doc = parser.parseFromString(html, 'text/html');doc.querySelectorAll('a').forEach(link =>{if (link.href.includes("images.steamusercontent.com/ugc/")){console.log(link.href.slice(0, link.href.indexOf('?')));};});}).catch(error =>{console.error('error cal site:', error);});}});

4. in your browser dev log you see a lot of image links so hit the right mouse button and save the log as links.log inside the mdhSteamScreenshotsDownloader folder
5. open the links.log file with an texteditor and clear the file so that only a list of valid links is in the links.log file
6. run the mdhSteamScreenshotsDownloader.bat and it will start downloading all screenshots of the links.log file


:oStart
echo -----------------------------------------------------------------------------------------------------------------------
echo mdhSteamScreenshotsDownloader by Moerderhoschi - github: https://github.com/Moerderhoschi/mdhSteamScreenshotsDownloader
echo -----------------------------------------------------------------------------------------------------------------------
echo Option 1: download all screenshots from links.log file
echo Option 2: download all screenshots from links.log file and make the timestamp better readable
echo Option 3: download all screenshots from links.log file and add game name to screenshots if available
echo Option 4: download all screenshots from links.log file and make the timestamp better readable and add game name to screenshots if available
echo type a valid number and hit enter
set _n=1
set /p _n=

mkdir screenshots
powershell -c "gc \"links.log\" | ForEach-Object {  $a=$_ ; $b=wget $a ; $c=$b.headers[\"Content-Disposition\"] ; $d = $c -replace '.*filename=\"(.*)\";', '$1' ; wget $a -o screenshots\$d }"
if %_n% == 1 GOTO o1
if %_n% == 3 GOTO o3

cd screenshots
mkdir temp
@echo off & Setlocal EnableDelayedExpansion
for %%g in (*.jpg) do (
set _g=%%g

	for /f "tokens=1,2,3,4 delims=_" %%a in ("!_g!") do (
	set _s1=%%a
	set _s2=%%b
	set _s3=%%c
	set _s4=%%d
	)

	set _check=!_s3:~4,1!
	set _year=!_s3:~0,4!
	set _month=!_s3:~4,2!
	set _day=!_s3:~6,2!
	set _hour=!_s3:~8,2!
	set _minute=!_s3:~10,2!
	set _second=!_s3:~12,2!

set "_final=!_s1!_!_s2!_!_year!_!_month!_!_day! !_hour!_!_minute!_!_second! !_s4!"
ren "!_g!" "!_final!"
move "!_final!" temp\
echo renamed !_g! to !_final!
)

for %%g in ("%cd%") do (set _d1=%%g)

for %%g in (temp\*.jpg) do (
set _g=%%g
move "!_g!" "!_d1!"
)
rmdir temp

if %_n% == 2 GOTO o1
:o3
powershell -c "$n='ARK Survival Evolved 346110 ';$o='346110_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Arma 2 Operation Arrowhead 33930 ';$o='33930_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Arma 3 107410 ';$o='107410_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Arma Cold War Assault 65790 ';$o='65790_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Arma Reforger 1874880 ';$o='1874880_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Arma Reforger Experimental 1890860 ';$o='1890860_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Arma Reforger Tools 1874910 ';$o='1874910_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V 271590 ';$o='9974983548387459072_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V 271590 ';$o='271590_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V 3240220 ';$o='3240220_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Ready or Not 1144200 ';$o='1144200_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='UBOAT 494840 ';$o='494840_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
exit

:o1
exit
