rm /data/resource-cache/overlays.list
touch /data/user_de/0/xyz.paphonb.quickstepswitcher/files/lastChange
if ! $MAGISK; then
  if [ -d /product/overlay ]; then
    STEP=/product/overlay/QuickstepSwitcherOverlay.apk
  else
    STEP=$VEN/overlay/QuickstepSwitcherOverlay.apk
  fi
  PERMISSIONXML=$SYS/etc/permissions/privapp-permissions-quickstepswitcher.xml
  WHITELISTXML=$SYS/etc/sysconfig/quickstepswitcher-hiddenapi-package-whitelist.xml
  SYSTEMIZE_TARGET=$SYS/priv-app/QuickstepSwitcherLauncher
  rm $PERMISSIONXML
  rm $WHITELISTXML
  rm $STEP
  rm -rf $SYSTEMIZE_TARGET
fi
