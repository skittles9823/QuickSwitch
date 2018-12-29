# Quickstep Switcher - Quickstep enabler for any supported launcher
Quickstep Switcher is a magisk module which systemlessly enables Pie recents (Quickstep) in any supported launcher

## Donations:
- If you wish to donate to [Paphonb](https://github.com/paphonb) for creating the QuickstepSwitcher app you can do so [here](https://paypal.me/Paphonb).
- Or if you wish to donate to [Skittles9823](https://github.com/skittles9823) for making the module you can do so [here](https://paypal.me/Skittles2398).

## Launcher Compatibility:
- All launchers that have merged the Android P Launcher3 commits.

## Disclaimer
- A full list of compatible launchers will not be provided as the app autodetects which launchers are compatible.
- Hyperion is currently unavailable as a recents provider as it's implementation is not stable enough. Please be patient and wait for an update regarding this.

## Requirements:
- Magisk 17+ (Rootless installs are currently broken, try at your own risk)
- Android 9.0 Pie

## Installation
1. Flash this module.
2. Open the Quickstep Switcher app that was installed.
3. Select a different launcher as your recents provider.
4. Reboot.
5. Profit.

## Debugging
- The boot scripts will save logs to /cache whenever it detects the user wants to switch providers
- All logs begin with **quickstepswitcher**
- If you have any issues, please join the [Telegram group](https://t.me/QuickstepSwitcherSupport) and send the logs along with what your issue is.

## Sources and used/needed tools:
- [Module Source](https://github.com/LawnchairLauncher/LawnstepModule)
- [Unity](https://github.com/Zackptg5/Unity) by [Zackptg5](https://github.com/Zackptg5)
- [Magisk](https://github.com/topjohnwu/Magisk) by [topjohnwu](https://forum.xda-developers.com/member.php?u=4470081)
- [Magisk Module Template](https://github.com/topjohnwu/magisk-module-template) by [topjohnwu](https://forum.xda-developers.com/member.php?u=4470081)

## Thanks to
- [Paphonb](https://github.com/paphonb), for being the main brains behind the modules, creating the app, and much more.
- [The Lawnchair team](https://t.me/lawnchairci), for testing Quickstep Switcher.
- [The Hyperion team](https://play.google.com/store/apps/details?id=projekt.launcher), for helping test Quickstep Switcher.

## Changelog:
### v1.0.2
- updated QuickstepSwitcher app (improved info and fixed theme bugs)
- fixed switching providers not working (Android dir handling is dumb af)

### v1.0.1
- hotfix for uninstalls

### v1.0.0
- initial release
