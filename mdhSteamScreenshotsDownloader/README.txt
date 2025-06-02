///////////////////////////////////////////////////////////////////////////////////////////////////
// mdhSteamScreenshotsDownloader(by Moerderhoschi) v2025-06-02
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
