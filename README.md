# Last Dance

A quick app to turn File Sharing off on login and shutdown, or manually, to workaround a [long-standing macOS bug](https://mjtsai.com/blog/2022/12/30/fixing-smb-file-sharing-in-ventura/).

The app registers itself as a login item on first launch. On first toggle it will prompt for administrator credentials to install a privileged helper (SMJobBless) so it can enable/disable File Sharing at login/shutdown without further prompts. If you change the signing identity, update the SMJobBless requirement strings in the app Info.plist and the helper Info.plist.

<img width="233" alt="GWE9TiGXIAAcVHR" src="https://github.com/user-attachments/assets/dc4a8ced-cf7b-421b-97ab-1e7c78b12615">

For macOS 11 and newer.

## Inspired by

- [Bluesnooze](https://github.com/odlp/bluesnooze)

## Licence

[MIT](/LICENSE)
