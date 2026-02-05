# Last Dance

A quick app to turn Samba File Sharing off on login and shutdown, or manually, to workaround a [long-standing macOS bug](https://mjtsai.com/blog/2022/12/30/fixing-smb-file-sharing-in-ventura/). For macOS 11 and newer.

Why _Last Dance_? Because Samba.

## Screenshot

<img width="241" height="172" alt="Screen shot 2026-02-05 at 12 49 35" src="https://github.com/user-attachments/assets/9814da71-2a22-40c9-a6cf-c214007c7f3f" />

## How

The app registers itself as a login item on first launch. On first run/toggle it will prompt for administrator credentials to install a privileged helper (SMJobBless) so it can enable/disable File Sharing at login/shutdown without further prompts. 

## Self builds

If you change the signing identity, update the SMJobBless requirement strings in the app Info.plist and the helper Info.plist.

## Inspired by

- [Bluesnooze](https://github.com/odlp/bluesnooze)

## Licence

[MIT](/LICENSE)
