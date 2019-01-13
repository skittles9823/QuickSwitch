# QuickSwitch - Quickstep enabler for any supported launcher
QuickSwitch is a magisk module which systemlessly enables Pie recents (Quickstep) in any supported launcher

## Donations:
- If you wish to donate to [Paphonb](https://github.com/paphonb) for creating the QuickstepSwitcher app you can do so [here](https://paypal.me/Paphonb).
- Or if you wish to donate to [Skittles9823](https://github.com/skittles9823) for making the module you can do so [here](https://paypal.me/Skittles2398).

## Launcher Compatibility:
- All launchers that have merged the Android P Launcher3 commits.

## Disclaimer
- A full list of compatible launchers will not be provided as the app autodetects which launchers are compatible.
- Hyperion is currently unavailable as a recents provider as it's implementation is not stable enough. Please be patient and wait for an update regarding this.

## Requirements:
- Magisk 17+ (Or TWRP and an unlocked bootloader with init.d support for a rootless install)
- Android 9.0 Pie

## Installation
1. Flash this module.
2. Reboot.
3. Open the QuickSwitch app that was installed.
4. Select a different launcher as your recents provider.
5. Reboot.
6. Profit.

## Debugging
- The boot scripts will save logs to /cache and /sdcard/Documents/quickstepswitcher whenever it detects the user wants to switch providers
- All logs begin with **quickstepswitcher**
- If you have any issues, please join the [Telegram group](https://t.me/QuickstepSwitcherSupport) and send the logs along with what your issue is.

## Sources and used/needed tools:
- [Module Source](https://github.com/Skittles9823/QuickstepSwitcher)
- [Unity](https://github.com/Zackptg5/Unity) by [Zackptg5](https://github.com/Zackptg5)
- [Magisk](https://github.com/topjohnwu/Magisk) by [topjohnwu](https://forum.xda-developers.com/member.php?u=4470081)
- [Magisk Module Template](https://github.com/topjohnwu/magisk-module-template) by [topjohnwu](https://forum.xda-developers.com/member.php?u=4470081)

## Thanks to
- [Paphonb](https://github.com/paphonb), for being the main brains behind the modules, creating the app, and much more.
- [The Lawnchair team](https://t.me/lawnchairci), for testing QuickSwitch.
- [The Hyperion team](https://play.google.com/store/apps/details?id=projekt.launcher), for helping test QuickSwitch.

## Support
You can get support for the module in either the [Telegram group](https://t.me/QuickstepSwitcherSupport) or the [XDA Thread](hh).

## Changelog:
### v1.1.2
- move app back to /system/app as it was broken for some people in priv-app
- remove quickswitches privapp-permissions.xml file (toggling swipe up gestures in the app is likely broken now)

### v.1.1.1
- update to Unity 3.1
- update QuickSwitch APK, now can enable/disable navigation bar gestures
- copy logs to /sdcard/Documents/quickstepswitcher as well
- various fixes for resetting to the default provider
- temporarily disable installs on OnePlus3(T) devices as it causes RIL to die for unknown reasons

### v1.1.0
- fix recents provider not persisting after updating the module
- remove old apk

### v1.0.9-hotfix
- fix bootloop when resetting to default provider

### v1.0.9
- more /product/overlay fix attempts
- fix the bootscript error appearing even though the bootscript successfully ran
- add a warning when setting a systemized launcher as the recents provider
- add a way to reset the recents provider back to stock

### v1.0.8
- add debugging to the QuickSwitch app so its more user-friendly
- recents provider will persist on updates from now on
- another possible fix for devices with /product/overlay

### v1.0.7
- fix uninstallation of Lawnstep

### v1.0.6
- Unity 2.3 update
- bring back rootless installs
- remove lawnstep if detected in magisk

### v1.0.5
- rename to QuickSwitch
- begin troubleshooting /product/overlay installs

### v1.0.4
- fix app having issues acquiring root

### v1.0.3
- fix late-start script (uninstalling anyway the user wants actually works now)
- fix derp in config.sh

### v1.0.2
- updated QuickstepSwitcher app (improved info and fixed theme bugs)
- fixed switching providers not working (Android dir handling is dumb af)

### v1.0.1
- hotfix for uninstalls

### v1.0.0
- initial release
