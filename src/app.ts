import * as path from 'path'
import * as url from 'url'
import * as electron from 'electron'
const { app, BrowserWindow } = electron

const createWindow = () => {
  const window = new BrowserWindow({
    show: false,
    width: 800,
    height: 600
  })

  window.once('ready-to-show', window.show)

  window.loadURL(url.format({
    pathname: path.join(__dirname, 'web/index.html'),
    protocol: 'file:',
    slashes: true
  }))

  return window
}

app.on('ready', createWindow)

app.on('window-all-closed', () => {
  const isNotMac = process.platform !== 'darwin'
  if (isNotMac) {
    app.quit()
  }
})