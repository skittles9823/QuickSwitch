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
if [ -d "/product/overlay" -a ! -L "/product" ]; then
  PRODUCT=/product/overlay
fi
if [ ! -d "$MODDIR" ]; then
  if [ ! -z "$PRODUCT" ]; then rm $PRODUCT/QuickstepSwitcherOverlay.apk; fi
  rm -rf /data/resource-cache/*
  rm $0
  exit 0
elif [ -f "$MODDIR/disable" ]; then
  rm -rf /data/resource-cache/*
fi
