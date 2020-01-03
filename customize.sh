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


if [ $API -lt "28" ]; then
  abort "QuickSwitch is for Android Pie+ only"
fi
VEN=/system/vendor
[ -L /system/vendor ] && VEN=/vendor
if [ -f $VEN/build.prop ]; then BUILDS="/system/build.prop $VEN/build.prop"; else BUILDS="/system/build.prop"; fi
# Thanks Narsil/Sauron for the huge props list for various android systems
# Far easier to look there then ask users for their build.props
MIUI=$(grep "ro.miui.ui.version.*" $BUILDS)
if [ $MIUI ]; then
  ui_print " MIUI is not supported"
  abort " Aborting..."
fi
ui_print "- Extracting module files"

unzip -o "$ZIPFILE" 'overlays/*' 'system/*' 'common/*' 'module.prop' 'uninstall.sh' 'quickswitch' 'QuickSwitch.apk' -d $MODPATH >&2
chmod +x $MODPATH/common/*
[ "$($MODPATH/common/aaptx86 v)" ] && AAPT=aaptx86
[ "$($MODPATH/common/aapt v)" ] && AAPT=aapt
[ "$($MODPATH/common/aapt64 v)" ] && AAPT=aapt64
cp -af $MODPATH/common/$AAPT $MODPATH/aapt
rm -rf $MODPATH/common
rm -rf /data/adb/service.d/quickswitch.sh
rm -rf /data/adb/service.d/quickswitch-service.sh
rm -rf /data/adb/post-fs-data.d/quickswitch-post.sh
# Custom install stuffs
if imageless_magisk; then MODULEDIR="/data/adb/modules/$MODID"; else MODULEDIR="/sbin/.magisk/img/$MODID"; fi
rm -rf /data/resource-cache/overlays.list
find /data/resource-cache/ -name *QuickstepSwitcherOverlay* -exec rm -rf {} \;
if [  `grep "versionCode=" $MODULEDIR/module.prop | sed 's/versionCode=//'` -ge 300 ];then
  if [ -d $MODULEDIR ]; then
    for i in $(find $MODULEDIR/system/* \
      -type d -maxdepth 0 | sed "/bin/ d; /^app/ d"); do
        cp -rf "$i" $MODPATH/system/
    done
  fi
else
  for i in $(find $MODULEDIR/* \
    -maxdepth 0 | sed "/^module.prop/ d"); do
      rm -rf "$i"
  done
  ui_print " Major upgrade! clearing out all old files and directories."
fi
ui_print "!!!!!!!!!!!!!!!!!!!!!!!!!Important!!!!!!!!!!!!!!!!!!!!!!!!"
ui_print "!  I am sick of people reporting issues without reading  !"
ui_print "! Many people only show pics of the scripts not running. !"
ui_print "!        DO NOT ONLY SEND PICTURES OF QUICKSWITCH        !"
ui_print "!              OR THEY WILL NOT BE LOOKED AT             !"
ui_print "!            ANY AND ALL ISSUES MUST HAVE LOGS           !"
ui_print "!  Read the XDA thread to find out how to report issues  !"
ui_print "!!!!!!!!!!!!!!!!!!!!!!!!!Important!!!!!!!!!!!!!!!!!!!!!!!!"

pm install $MODPATH/QuickSwitch.apk

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/aapt 0 2000 0755
set_perm $MODPATH/quickswitch 0 2000 0777
