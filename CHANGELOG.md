# QuickSwitch - Quickstep enabler for supported launchers

QuickSwitch is a Magisk module which systemlessly allows supported launchers to access the recents (QuickStep) APIs

![GitHub All Releases](https://img.shields.io/github/downloads/skittles9823/quickswitch/total?label=Downloads%20on%20GitHub)

## Changelog:

### v3.3.0
### Note, this update will reset the current provider
- better support some LG devices on Android 9
- allow installation on MIUI 12.5+ (oops forgot the check was there)
- remove sepolicy rules as they didn't help most of the time
- increase overlay priority again
- format scripts to be more readable
- the QuickSwitch app will now correctly specify Android 12.1 instead of 12 where applicable
- change module ID to `quickswitch`, order has been restored
- for module developers who check for the modID, I'd recommend instead looking for the `/data/adb/modules/**/quickswitch` binary instead
- update README to better explain the modules functionality
- update the modules update-binary because it was 2 years outdated xd
