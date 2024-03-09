SKIPUNZIP=1
# @Skittles9823 made this ascii and is way to proud of it
ui_print " "
ui_print "       _____       "
ui_print "   __ |     | __   "
ui_print "  |  ||     ||  |  "
ui_print "  |  ||     ||  |  "
ui_print "  |__||     ||__|  "
ui_print "      |_____|      "
ui_print "    QuickSwitch    "
ui_print "                   "
ui_print " The Lawnchair Team"
ui_print " "

[ $BOOTMODE == "false" ] && abort "Installation failed! QuickSwitch must be installed via Magisk/KernelSU Manager!"
[ $API -lt "28" ] && abort "QuickSwitch is for Android Pie+ only"

VEN=/system/vendor
[ -L /system/vendor ] && VEN=/vendor
if [ -f $VEN/build.prop ]; then BUILDS="/system/build.prop $VEN/build.prop"; else BUILDS="/system/build.prop"; fi
# Thanks Narsil/Sauron for the huge props list for various android systems
# Far easier to look there then ask users for their build.props
MIUI=$(grep "ro.miui.ui.version.*" $BUILDS)
if [ $MIUI ] && [ $API -lt "30" ]; then
  ui_print " MIUI 12 or lower is not supported"
  abort " Aborting..."
fi
ui_print "- Extracting module files"

unzip -o "$ZIPFILE" 'overlays/*' 'system/*' 'common/*' 'module.prop' 'framework-res.apk' 'system.prop' 'sepolicy.rule' 'zipsigner*' 'uninstall.sh' 'quickswitch' 'service.sh' -d $MODPATH >&2
chmod +x $MODPATH/common/*

if [ -z "$NOAPK" ]; then
  unzip -o "$ZIPFILE" 'QuickSwitch.apk' -d /data/local/tmp >&2
  ui_print "- installing QuickSwitch.apk"
  pm install -r "/data/local/tmp/QuickSwitch.apk"
  rm -rf /data/local/tmp/QuickSwitch.apk
fi

[ "$($MODPATH/common/aaptx86 v)" ] && AAPT=aaptx86
[ "$($MODPATH/common/aapt v)" ] && AAPT=aapt
[ "$($MODPATH/common/aapt64 v)" ] && AAPT=aapt64
cp -af $MODPATH/common/$AAPT $MODPATH/aapt
rm -rf $MODPATH/common
rm -rf /data/adb/service.d/quickswitch.sh
rm -rf /data/adb/service.d/quickswitch-service.sh
rm -rf /data/adb/post-fs-data.d/quickswitch-post.sh

# Custom install stuffs
rm -rf /data/resource-cache/overlays.list
find /data/resource-cache/ -name "*QuickstepSwitcherOverlay*" -exec rm -rf {} \;
find /data/resource-cache/ -name "*QuickSwitchOverlay*" -exec rm -rf {} \;
MODULEDIR="/data/adb/modules/$MODID"
MODVER=$(grep_prop versionCode $MODULEDIR/module.prop)

# Check for KSU
if [ -z "$KSU" ]; then
  sed -i "/KSU=true*/d" $MODDIR/quickswitch
fi

rm -rf /data/adb/modules/quickstepswitcher # yeet old module dir

if [ -d $MODULEDIR ]; then
  if [ $MODVER -ge 3300 ]; then # Been a minute since we've made people clean the install dir, prolly should do it now
    ui_print "- Module updating - retaining current provider"
    for i in $(find $MODULEDIR/system/* -type d -maxdepth 0); do
      cp -rf "$i" $MODPATH/system/
    done
  else
    for i in $(find $MODULEDIR/* -maxdepth 0 | sed "/^module.prop/ d"); do
      rm -rf "$i"
    done
    ui_print "- Major upgrade! clearing out all old files and directories."
  fi
fi

# Nobody reads it anyway Sadge

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/aapt 2000 2000 0755
set_perm $MODPATH/quickswitch 2000 2000 0777
set_perm $MODPATH/zipsigner 0 0 0755
set_perm $MODPATH/zipsigner-3.0-dexed.jar 0 0 0644
