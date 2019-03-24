[ -d "/product/overlay" ] && PRODUCT=/product/overlay
if [ -d "$PRODUCT" ]; then rm $PRODUCT/QuickstepSwitcherOverlay.apk; fi
rm -rf /data/resource-cache/*