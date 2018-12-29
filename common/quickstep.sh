#!/system/bin/sh
MAGISK=<MAGISK>
MODID=<MODID>
# Start logging
set -x 2>/cache/$MODID-service.log
# The user can uninstall however they like. Yeet.png
if $MAGISK; then
  if [ ! -d "$UNITY" ]; then
    if [ -d "/product/overlay" ]; then rm /product/overlay/QuickstepSwitcherOverlay.apk; fi
    rm /data/resource-cache/overlays.list
    rm $0
    exit 0
  elif [ -f "$UNITY/disable" ]; then
    rm /data/resource-cache/overlays.list
  fi
fi
