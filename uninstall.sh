if [ -d "/product/overlay" -a ! -L "/product" ]; then
  PRODUCT=/product/overlay
fi
if [ "$PRODUCT" ]; then rm -rf $PRODUCT/QuickstepSwitcherOverlay.apk; fi
rm -rf /data/resource-cache/*
