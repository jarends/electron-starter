# electron-starter
A simple starting point for electron apps.

With grunt tasks for running the app and simple packaging for mac and windows.
The electron app itself is separated in a subfolder, as node module with own package.json.

The sample app is the [electron-quick-start](https://github.com/electron/electron-quick-start) app.

You can use
```script
    grunt run 
    grunt build-mac
    grunt build-win32
    grunt build-win64
    grunt build-win
    grunt build-all
    grunt open // (on mac)     
```