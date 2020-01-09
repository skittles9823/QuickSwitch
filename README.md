# QuickSwitch - Quickstep enabler for any supported launcher
QuickSwitch is a Magisk module which systemlessly enables Pie recents (Quickstep) in any supported launcher

## Donations:
- If you wish to donate to [Paphonb](https://github.com/paphonb) for creating the QuickSwitch app you can do so [here](https://paypal.me/Paphonb).
- Or if you wish to donate to [Skittles9823](https://github.com/skittles9823) for making the module, scripts, and handling support you can do so [here](https://paypal.me/Skittles2398).

## Disclaimer
- A full list of compatible launchers will not be provided as the app autodetects which launchers are compatible.
- Nova will likely never support QuickSwitch unless they decide to add support for the Razer Phone naitivly.
- MIUI does not have the necessary APIs to set third party launchers as the recents providers and as such is not supported.

## Requirements:
- Magisk 18+ (Android 10 needs Magisk v20 or higher)
- Android 9+

## Installation
1. Flash this module.
2. Reboot.
3. Open the QuickSwitch app that was installed.
4. Select a different launcher as your recents provider.
5. Reboot.
6. Verify your new recents provider is correct.
7. Set the new recents provider as the default launcher.
8. Profit.

## Debugging
- The boot scripts will save logs to /sdcard/Documents/quickstepswitcher whenever it detects the user wants to switch providers
- All logs begin with **quickstepswitcher**
- If you have any issues, please join the [Telegram group](https://t.me/QuickstepSwitcherSupport) and send the logs along with what your issue is.

## Sources and used/needed tools:
- [Module Source](https://github.com/skittles9823/QuickSwitch)
- [Magisk](https://github.com/topjohnwu/Magisk) by [topjohnwu](https://forum.xda-developers.com/member.php?u=4470081)
- [Magisk Module Template](https://github.com/topjohnwu/magisk-module-template) by [topjohnwu](https://forum.xda-developers.com/member.php?u=4470081)

## Thanks to
- [Paphonb](https://github.com/paphonb), for being the main brains behind the module, creating the app, and much more.
- [The Lawnchair team](https://t.me/lawnchairci), for testing QuickSwitch.
- [The Hyperion team](https://play.google.com/store/apps/details?id=projekt.launcher), for helping test QuickSwitch.

## Support
You can get support for the module in either the [Telegram group](https://t.me/QuickstepSwitcherSupport) or the [XDA Thread](https://forum.xda-developers.com/apps/magisk/module-quickswitch-universal-quickstep-t3884797/).

## Changelog:
### v3.0.4
- remove selinux dependant commands in favour of grepping packages.xml and listning contense of /data/app to find launcher dirs
- sign the overlay again
- I'd like to thank osm0sis@XDA for helping with this update

### v3.0.3
- fix provider resetting when updating the module

### v3.0.2
- attempt to fix bootloops on OnePlus devices

### v3.0.1
- fix small bug

### v3.0.0
- completely rewrite the app and the module backend. Now the app uses a shell binary as the backend to
  remove the need for bootscripts
- re-add the $MODDIR/product/overlay install path as the Magisk issue has been fixed
- added a check for MIUI which will abort the installation of the module

### v2.0.9
- add support for /oem/OP/OPEN_US/overlay/framework as the overlay dir
- temporarily reverted the /product change so Magisk canary users have a somewhat working QuickSwitch
- fix up inconsistent shell, it's all uniform now
- rewrite uninstall.sh so it works now (oversight on my part from before)
- actually make the module abort when it's flashed on an unsupported android version
- more miscellaneous fixes and optimisations

### v2.0.8
- quick hotfix for the while loop

### v2.0.7
- added check to prevent using Pie launchers on Q and vice-versa
- add while loop to hopefully make sure the overlay dir is created

### v2.0.6
- update is_mounted(\_rw) functions to match Magisks
- update apk and switch to a new reboot method
- updated /product logic for Magisk 19305+
- moved all bootscripts to /data/adb/service.d and /data/adb/post-fs-data.d so they will always get executed first
- more attempts at trying to fix magisk not successfully copying the overlay
- oopsie, forgot to add an API check again after switching templates

### v2.0.5
- fix grid recents

### v2.0.4
- fix rom info logging formatting
- check for /product being a symlink and copy the overlay systemlessly if it is
- add more checks in the late-start script so it isn't needlessly run every boot for devices with /product/overlay
- various improvements
- add grid recents toggle
- remove hyperion blacklist app side (will now show hyperion for everyone)

### v2.0.3
- fix major derp

### v2 0.2
- slight template update
- small change to make updating from 2.0.0+ not reset the recents provider
- back on the magisk repo

### v2.0.1
- hyperion is now public for all!

### v2.0.0
- switch to the new Magisk template. RIP rootless users
- overhauled basically everything
- remove device check and replace with a warning that RIL issues are rom side
- fix the creation of quickstepswitcher-old.log and clean up quickstepswitcher.log
- logs are now slightly more descriptive for me.
- more attempts to fix /product/overlay installs
- fix QuickSwitch creating multiple launcher dirs when ever the launcher gets an update
- add capability to set default home app

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
