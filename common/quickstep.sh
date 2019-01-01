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
if [ -d "/product/overlay" ]; then
  if [ -f "$UNITY$VEN/overlay/QuickstepSwitcherOverlay.apk" ]; then
    cp $UNITY$VEN/overlay/QuickstepSwitcherOverlay.apk /product/overlayQuickstepSwitcherOverlay.apk
    chmod 644 /product/overlay/QuickstepSwitcherOverlay.apk
    rm $UNITY$VEN/overlay/QuickstepSwitcherOverlay.apk
  fi
fi
