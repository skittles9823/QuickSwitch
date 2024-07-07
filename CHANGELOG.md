# QuickSwitch - Quickstep enabler for supported launchers

QuickSwitch is a Magisk module which systemlessly allows supported launchers to access the recents (QuickStep) APIs

## Changelog:

### 4.0.3

- Various fixes for KSU/Apatch by @j7b3y, @DrDisagree, and @ammargitham

### 4.0.2

- unrevert embed framework-res
- add sepolicy to fix `pm path` (Thanks Jan from the telegram group)

### v4.0.1

- Revert embed framework-res
- I forgor to add some KSU stuff from the 3.3.7 test zips

### v4.0.0

- add KernelSU support
- potential fix for appt not working
- logging overlays now works correctly
- raise overlay priority back to 9999 (oops, lowered it too much)
- Build Overlay using embedded Framework (fixes overlay creation. By [DanGLES3](https://github.com/DanGLES3))
