# This script will be executed in post-fs-data mode
# More info in the main Magisk thread
# Start logging
set -x 2>/cache/$MODID.log

# Assign vars
SWITCHER_DIR=/data/user_de/0/xyz.paphonb.quickstepswitcher
SWITCHER_OUTPUT=$SWITCHER_DIR/files
DID_MOUNT_RW=

# Delete lastBoot so QuickSwitch knows the script initiated.
rm $SWITCHER_OUTPUT/lastBoot

# Function to check if product is mounted
is_mounted() {
  cat /proc/mounts | grep -q " `readlink -f $1` " 2>/dev/null
  return $?
}

is_mounted_rw() {
  cat /proc/mounts | grep -q " `readlink -f $1` " | grep -q " rw," 2>/dev/null
  return $?
}

mount_rw() {
  mount -o remount,rw $1
  DID_MOUNT_RW=$1
}

unmount_rw() {
  if [ "x$DID_MOUNT_RW" = "x$1" ]; then
    mount -o remount,ro $1
  fi
}
# Check if user wants to reset the Quickstep provider
if [ -f "$SWITCHER_OUTPUT/reset" ]; then
  # Assign $STEPDIR var
  if [ -f "$SWITCHER_OUTPUT/isProduct" ]; then
    STEPDIR=/product/overlay
    # Try to mount /product
    is_mounted /product || mount /product
    is_mounted_rw /product || mount_rw /product
  else
    if $MAGISK; then
      STEPDIR=$UNITY/system/vendor/overlay
    else
      STEPDIR=$UNITY/$VEN/overlay
    fi
  fi
  rm -rf $STEPDIR/QuickstepSwitcherOverlay.apk
  rm -rf $UNITY$SYS/etc/permissions/privapp-permissions-quickstepswitcher.xml
  rm -rf $UNITY$SYS/etc/sysconfig/quickstepswitcher-hiddenapi-package-whitelist.xml
  rm -rf $$UNITY$SYS/priv-app/QuickstepSwitcher*
  rm -rf $SWITCHER_OUTPUT/output/*
  rm -rf $SWITCHER_OUTPUT/lastChange
  rm -rf $SWITCHER_OUTPUT/reset
  unmount_rw /product
fi

# Check if user wants to switch the Quickstep provider
if [ -f "$SWITCHER_OUTPUT/lastChange" ]; then
  # Assign $STEPDIR var
  if [ -f "$SWITCHER_OUTPUT/isProduct" ]; then
    STEPDIR=/product/overlay
    # Try to mount /product
    is_mounted /product || mount /product
    is_mounted_rw /product || mount_rw /product
  else
    if $MAGISK; then
      STEPDIR=$UNITY/system/vendor/overlay
      mkdir -p $STEPDIR
    else
      STEPDIR=$UNITY/$VEN/overlay
    fi
  fi

  # Assign misc variables
  PERMISSIONXML=$UNITY$SYS/etc/permissions/privapp-permissions-quickstepswitcher.xml
  WHITELISTXML=$UNITY$SYS/etc/sysconfig/quickstepswitcher-hiddenapi-package-whitelist.xml
  OVERLAY=$STEPDIR/QuickstepSwitcherOverlay.apk
  SYSTEMIZE_TARGET=$UNITY$SYS/priv-app

  # Create needed dirs
  mkdir -p $SYSTEMIZE_TARGET
  if $MAGISK; then
    mkdir -p $UNITY$SYS/etc/permissions
    mkdir -p $UNITY$SYS/etc/sysconfig
  fi

  # Delete old provider dir
  rm -rf $SYSTEMIZE_TARGET/QuickstepSwitcher*
  # Copy needed files to module dir
  cp -rf $SWITCHER_OUTPUT/output/privapp-permissions-quickstepswitcher.xml $PERMISSIONXML
  cp -rf $SWITCHER_OUTPUT/output/quickstepswitcher-hiddenapi-package-whitelist.xml $WHITELISTXML
  cp -rf $SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk $OVERLAY
  cp -rf $SWITCHER_OUTPUT/output/systemize/* $SYSTEMIZE_TARGET
  rm -rf $SWITCHER_DIR/shared_prefs/tmp.xml

  # Set perms
  if $MAGISK; then chmod -R a=r,u+w,a+X $UNITY$SYS; fi
  chmod 644 $OVERLAY
  if [ $STEPDIR == "$UNITY/system/vendor/overlay" ]; then chown 0:2000 $STEPDIR; fi

  unmount_rw /product

  # Delete possible bootloop causing file and QuickstepSwitcher created files
  rm /data/resource-cache/overlays.list
  if [ -f "$OVERLAY" ]; then
    rm -rf $SWITCHER_OUTPUT/lastChange
  fi

  # Logging for days
  cp -rf /cache/$MODID.log /cache/$MODID-old.log
  echo "---Device Info---" > /cache/$MODID-formatted.log
  grep "^ro.product.device[^#]" /system/build.prop | sed 's/ro.product.device/Device/g' >> /cache/$MODID-formatted.log
  grep "^ro.build.type[^#]" /system/build.prop | sed 's/ro.build.type/Buildtype/g' >> /cache/$MODID-formatted.log
  grep "^ro.build.version.security_patch[^#]" /system/build.prop | sed 's/ro.build.version.security_patch/SecurityPatch/g' >> /cache/$MODID-formatted.log
  grep "^ro.product.cpu.abilist[^#]" /system/build.prop | sed 's/ro.product.cpu.abilist/Arch/g' >> /cache/$MODID-formatted.log
  echo -e "\n---Variables---" >> /cache/$MODID-formatted.log
  ( set -o posix ; set ) >> /cache/$MODID-formatted.log
  echo -e "\n---Installed Files---" >> /cache/$MODID-formatted.log
  grep "^+ cp" /cache/$MODID.log | sed 's/.* //g' >> /cache/$MODID-formatted.log
  echo -e "\n---Errors---" >> /cache/$MODID-formatted.log
  grep "^[^+']" /cache/$MODID.log >> /cache/$MODID-formatted.log
  echo -e "\n---Magisk Version---" >> /cache/$MODID-formatted.log
  echo `grep "MAGISK_VER_CODE=" /data/adb/magisk/util_functions.sh | sed "s/MAGISK_VER_CODE=//"` >> /cache/$MODID-formatted.log
fi
