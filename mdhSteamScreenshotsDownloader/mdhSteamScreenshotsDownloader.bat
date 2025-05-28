@echo off
goto oStart
///////////////////////////////////////////////////////////////////////////////////////////////////
// mdhSteamScreenshotsDownloader(by Moerderhoschi) v2025-05-28
// github: https://github.com/Moerderhoschi/mdhSteamScreenshotsDownloader
// a set of Javascript and Powershell code to download screenshots from steam
///////////////////////////////////////////////////////////////////////////////////////////////////
Variant 1 (easy to use):
1. execute the mdhSteamScreenshotsDownloader.bat and choose option 1 or 2

Variant 2 (you can download screenshots of friends which are not visible for public):
1. In your browser go to the Steam Screenshots page e.g. https://steamcommunity.com/id/Moerderhoschi/screenshots/
2. open the webbrowser developer tools (for chrome F12)
3. insert the following code and hit enter:
document.querySelectorAll('a').forEach(link =>{if (link.href.includes("steamcommunity.com/sharedfiles/filedetails/?id=")){fetch(link.href).then(response => {return response.text();}).then(html =>{let parser = new DOMParser();let doc = parser.parseFromString(html, 'text/html');doc.querySelectorAll('a').forEach(link =>{if (link.href.includes("images.steamusercontent.com/ugc/")){console.log(link.href.slice(0, link.href.indexOf('?')));};});}).catch(error =>{console.error('error cal site:', error);});}});

4. in your browser dev log you see a lot of image links so hit the right mouse button and save the log as links.log inside the mdhSteamScreenshotsDownloader folder
execute the mdhSteamScreenshotsDownloader.bat and choose option 3


:oStart
echo ------------------------------------------------------------------------------------------------------------------------------------
echo mdhSteamScreenshotsDownloader(by Moerderhoschi) v2025-05-28 - github: https://github.com/Moerderhoschi/mdhSteamScreenshotsDownloader
echo ------------------------------------------------------------------------------------------------------------------------------------
echo Option 1: download all screenshots of steam user (you enter the steamID in next step) start with newest screenshots
echo Option 2: download all screenshots of steam user (you enter the steamID in next step) start with oldest screenshots
echo Option 3: download all screenshots of links.log file
echo type a valid number and hit enter:

set _n1=1
set _n2=moerderhoschi
set _n3=0
set _n4=1
set _n5=500
set _n6=0
set _n7=2

set /p _n1=
echo.
if %_n1% == 3 GOTO o3
if %_n1% == 1 GOTO o2
if %_n1% == 2 GOTO o2
echo no valid option, exit
timeout /t 5
exit

:o2
echo enter the steam userID(name or number) e.g. moerderhoschi:
set /p _n2=
echo.

echo enter a specifig game id if you want to download only screenshots of a specific game e.g. 107410 for Arma 3 or press enter for all games:
set /p _n3=
echo.

echo enter the screenhots pagenumber to start with or press enter to start with page 1:
set /p _n4=
echo.

echo enter the screenhots pagenumber to end with or press enter to end with last page:
set /p _n5=
echo.

echo enter 1 to create a folder for every game or press enter to save all screenshots in one folder:
set /p _n6=
echo.

:o3
echo select a name sheme for the screenshots:
echo Option 1: Gamename GameID yyyy_MM_dd hh_mm_ss_id.jpg
echo Option 2: Gamename GameID yyyy_MM_dd hh_mm_ss id.jpg
echo Option 3: Gamename GameID yyyy-MM-dd hh_mm_ss_id.jpg
echo Option 4: Gamename GameID yyyy-MM-dd hh_mm_ss id.jpg
echo Option 5: Gamename yyyy_MM_dd hh_mm_ss_id.jpg
echo Option 6: Gamename yyyy_MM_dd hh_mm_ss id.jpg
echo Option 7: Gamename yyyy-MM-dd hh_mm_ss_id.jpg
echo Option 8: Gamename yyyy-MM-dd hh_mm_ss id.jpg
set /p _n7=

if not exist screenshots mkdir screenshots
powershell -ExecutionPolicy Bypass -File "bin\mdhPS1.ps1" -p1 %_n1% -p2 %_n2% -p3 %_n3% -p4 %_n4% -p5 %_n5% -p6 %_n6% -p7 %_n7%
pause
GOTO o1

:o4
cd screenshots
powershell -c "$n='Grand Theft Auto V 3240220 ';$o='9974983548387459072_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V 3240220 ';$o='9690426696418721792_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V 3240220 ';$o='271590_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V 3240220 ';$o='3240220_screenshots_';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"

:o1
