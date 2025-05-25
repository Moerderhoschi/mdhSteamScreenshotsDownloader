mdhSteamScreenshotsDownloader(by Moerderhoschi) - v2025-05-25

a set of Javascript and Powershell code to download screenshots from steam

![image](https://github.com/user-attachments/assets/2df356de-5522-44ba-aa27-e51a9530d33d)



1. In your browser go to the Steam Screenshots page e.g. https://steamcommunity.com/id/Moerderhoschi/screenshots/
2. open the webbrowser developer tools (for chrome F12)
3. insert the following code and hit enter:

document.querySelectorAll('a').forEach(link =>{if (link.href.includes("steamcommunity.com/sharedfiles/filedetails/?id=")){fetch(link.href).then(response => {return response.text();}).then(html =>{let parser = new DOMParser();let doc = parser.parseFromString(html, 'text/html');doc.querySelectorAll('a').forEach(link =>{if (link.href.includes("images.steamusercontent.com/ugc/")){console.log(link.href);};});}).catch(error =>{console.error('error cal site:', error);});}});

![image](https://github.com/user-attachments/assets/c0a8db2b-0eb1-4218-b4c6-50742c45f96b)

5. in your browser dev log you see a lot of image links so hit the right mouse button and save the log as links.log inside the mdhSteamScreenshotsDownloader folder

![image](https://github.com/user-attachments/assets/dbbf2bc0-8cfb-47e5-b51c-49a7eeec4d87)


6. open the links.log file with an texteditor and clear the file so that only a list of valid links is in the links.log file
7. run the mdhSteamScreenshotsDownloader.bat and it will start downloading all screenshots of the links.log file
