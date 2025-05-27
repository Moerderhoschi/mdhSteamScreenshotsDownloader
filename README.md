mdhSteamScreenshotsDownloader(by Moerderhoschi)

a set of Javascript and Powershell code to download screenshots from steam

![image](https://github.com/user-attachments/assets/12ea9965-2301-4cce-8146-97af177fd0ec)

Variant 1 (easy to use):
1. execute the mdhSteamScreenshotsDownloader.bat and choose option 1 or 2

Variant 2 (you can download screenshots of friends which are not visible for public):
1. In your browser go to the Steam Screenshots page e.g. https://steamcommunity.com/id/Moerderhoschi/screenshots/
2. open the webbrowser developer tools (for chrome F12)
3. insert the following code and hit enter:
```
document.querySelectorAll('a').forEach(link =>{if (link.href.includes("steamcommunity.com/sharedfiles/filedetails/?id=")){fetch(link.href).then(response => {return response.text();}).then(html =>{let parser = new DOMParser();let doc = parser.parseFromString(html, 'text/html');doc.querySelectorAll('a').forEach(link =>{if (link.href.includes("images.steamusercontent.com/ugc/")){console.log(link.href.slice(0, link.href.indexOf('?')));};});}).catch(error =>{console.error('error cal site:', error);});}});
```

![image](https://github.com/user-attachments/assets/c0a8db2b-0eb1-4218-b4c6-50742c45f96b)

4. in your browser dev log you see a lot of image links so hit the right mouse button and save the log as links.log inside the mdhSteamScreenshotsDownloader folder

![image](https://github.com/user-attachments/assets/dbbf2bc0-8cfb-47e5-b51c-49a7eeec4d87)

![image](https://github.com/user-attachments/assets/e3a02b3f-7bb2-47e0-a9d0-024b401c6bdc)

![image](https://github.com/user-attachments/assets/4dfc855e-6b42-415f-949c-d466b320b199)

5. execute the mdhSteamScreenshotsDownloader.bat and choose option 3

![image](https://github.com/user-attachments/assets/d9763984-81bc-433c-880d-c9f4ca86341a)

![image](https://github.com/user-attachments/assets/072b8d64-0687-4f3f-91aa-e4165e68e263)

![image](https://github.com/user-attachments/assets/a75960d1-2684-424b-b44e-acba30f7a002)
