@echo off
goto oStart
///////////////////////////////////////////////////////////////////////////////////////////////////
// mdhSteamScreenshotsDownloader(by Moerderhoschi) v2025-05-31
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
if not exist bin if exist "F:\temp\Onlinepraesenz\Steam\mdhSteamScreenshotsDownloader\bin" mklink /j bin "F:\temp\Onlinepraesenz\Steam\mdhSteamScreenshotsDownloader\bin"
echo ------------------------------------------------------------------------------------------------------------------------------------
echo mdhSteamScreenshotsDownloader(by Moerderhoschi) v2025-05-31 - github: https://github.com/Moerderhoschi/mdhSteamScreenshotsDownloader
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
set _n7=1
set _n8=0

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

echo MULTI INSTANCE CAN BE CPU HEAVY USE ONLY IF YOU KNOW WHAT YOU DO AND WHEN YOU HAVE A GOOD CPU COOLING
echo enter a number to start a new download instance every n pages or press enter for only one instance:
set /p _n8=
echo.

:o3
echo enter 1 to create a folder for every game or press enter to save all screenshots in one folder:
set /p _n6=
echo.

echo select a name sheme for the screenshots:
echo Option 1: Gamename GameID yyyy-MM-dd hh_mm_ss_id.jpg
echo Option 2: Gamename GameID yyyy_MM_dd hh_mm_ss_id.jpg
echo Option 3: Gamename yyyy-MM-dd hh_mm_ss_id.jpg
echo Option 4: Gamename yyyy_MM_dd hh_mm_ss_id.jpg
set /p _n7=

if not exist screenshots mkdir screenshots
if %_n8% gtr 0 GOTO o5
powershell -ExecutionPolicy Bypass -File "bin\mdhPS1.ps1" -p1 %_n1% -p2 %_n2% -p3 %_n3% -p4 %_n4% -p5 %_n5% -p6 %_n6% -p7 %_n7%
GOTO o1

:o5
setlocal enabledelayedexpansion
for /l %%i in (%_n4%, %_n8%, %_n5%) do (
	set /a _n4 = %%i
	set /a _n5 = %%i + %_n8% - 1
	start /low powershell -ExecutionPolicy Bypass -File "bin\mdhPS1.ps1" -p1 %_n1% -p2 %_n2% -p3 %_n3% -p4 !_n4! -p5 !_n5! -p6 %_n6% -p7 %_n7%
)
GOTO o1

:o4
cd screenshots
powershell -c "$n='Arma Cold War Assault 65790 ';$o='UKNOWN_GAME 14586209416903655424 ';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Armored Warfare 443110 ';$o='UKNOWN_GAME 17568754592668188672 ';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V Legacy 271590 ';$o='UKNOWN_GAME 16769456153770852352 ';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V Legacy 271590 ';$o='UKNOWN_GAME 9690426696418721792 ';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Grand Theft Auto V Legacy 271590 ';$o='UKNOWN_GAME 9974983548387459072 ';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Tom Clancys Ghost Recon Wildlands 460930 ';$o='UKNOWN_GAME 12200718730266673152 ';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"
powershell -c "$n='Tom Clancys The Division 365590 ';$o='UKNOWN_GAME 11423151661950959616 ';gci -Recurse | Where-Object{$_.Name -match $o} | foreach{$cn=$_.Name;$nn=$cn -replace $o, $n ; echo ($cn + ' -- RENAMED TO -- ' + $nn) ; ren $_.fullname $nn}"

:o1
