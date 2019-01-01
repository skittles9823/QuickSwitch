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
# Assign vars
SWITCHER_DIR=/data/user_de/0/xyz.paphonb.quickstepswitcher
SWITCHER_OUTPUT=$SWITCHER_DIR/files
if [ -f "$SWITCHER_OUTPUT/isProduct" ]; then
  if [ -f "$SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk" ]; then
    cp -rf $SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk /product/overlay/QuickstepSwitcherOverlay.apk
    chmod 644 /product/overlay/QuickstepSwitcherOverlay.apk
    if [ -f "/product/overlay/QuickstepSwitcherOverlay.apk" ]; then
      rm -rf $SWITCHER_OUTPUT/lastChange
    fi
  fi
fi
