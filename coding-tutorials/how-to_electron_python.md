# electron & python desktop application

NOT COMPLETE YET, be aware

preparations:

```shell
npm init -y
touch index.js index.html

npm install --save python-shell

// install angular-cli globally
npm install -g @angular/cli

ng new appname
cd appname

npm install --save-dev electron
```

```package.json
  "scripts": {
      /*...*/
    "start": "electron .",
```

```index.js
const {app, BrowserWindow} = require('electron')

function createWindow () {
    window = new BrowserWindow({width: 800, height: 600})
    window.loadFile('index.html')
}

```

```index.html
some html
<head>
    <base href="./">
```

run the app with `npm start`
