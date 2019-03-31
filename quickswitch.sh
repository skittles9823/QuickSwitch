#!/system/bin/sh
imageless_magisk() {
  MAGISK_VER_CODE=`grep MAGISK_VER_CODE /data/adb/magisk/util_functions.sh`
  [ $MAGISK_VER_CODE -gt 18100 ]
  return $?
}
if imageless_magisk; then
  MODDIR=/data/adb/modules/quickstepswitcher
else
  MODDIR=/sbin/.magisk/img/quickstepswitcher
fi
[ -f "/product/overlay/QuickstepSwitcherOverlay.apk" ] && PRODUCT=/product/overlay/QuickstepSwitcherOverlay.apk
if [ ! -d "$MODDIR" ]; then
  if [ -d "$PRODUCT" ]; then rm $PRODUCT; fi
  rm -rf /data/resource-cache/*
  rm $0
  exit 0
elif [ -f "$MODDIR/disable" ]; then
  rm -rf /data/resource-cache/*
fi
