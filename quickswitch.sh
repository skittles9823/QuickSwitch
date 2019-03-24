#!/system/bin/sh
ADBMOD=/data/adb/modules/quickstepswitcher
MAGMOD=/sbin/.magisk/img/quickstepswitcher
[ -d "/product/overlay" ] && PRODUCT=/product/overlay
if [ ! -d "$ADBMOD" -a ! -d "$MAGMOD" ]; then
  if [ -d "$PRODUCT" ]; then rm $PRODUCT/QuickstepSwitcherOverlay.apk; fi
  rm $0
  exit 0
elif [ -f "$ADBMOD/disable" -o -f "$MAGMOD/disable" ]; then
  rm /data/resource-cache/overlays.list
fi