#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future

MAGISK_VER_CODE=`grep MAGISK_VER_CODE /data/adb/magisk/util_functions.sh`
imageless_magisk() {
  [ $MAGISK_VER_CODE -gt 18100 ]
  return $?
}
if imageless_magisk; then
  MODDIR=/data/adb/modules/quickstepswitcher
else
  MODDIR=/sbin/.magisk/img/quickstepswitcher
fi

# This script will be executed in post-fs-data mode
# Start logging
MODID=quickstepswitcher
mkdir -p $MODDIR/logs && LOGDIR=$MODDIR/logs
mv -f $LOGDIR/$MODID.log $LOGDIR/$MODID-old.log 2>/dev/null
set -x 2>$LOGDIR/$MODID-tmp.log

# Assign vars
SWITCHER_DIR=/data/user_de/0/xyz.paphonb.quickstepswitcher
SWITCHER_OUTPUT=$SWITCHER_DIR/files
DID_MOUNT_RW=

# Delete lastBoot so QuickSwitch knows the script initiated.
rm $SWITCHER_OUTPUT/lastBoot

# Function to check if product is mounted
is_mounted() {
  grep " `readlink -f $1` " /proc/mounts 2>/dev/null
  return $?
}

is_mounted_rw() {
  grep " `readlink -f $1` " /proc/mounts | grep " rw," 2>/dev/null
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
  RESET=true
  # Assign $STEPDIR var
  if [ -f "$SWITCHER_OUTPUT/isProduct" ]; then
    PRODUCT=true
    # Yay, magisk supports bind mounting /product now
    if [ $MAGISK_VER_CODE -ge "19305" ]; then
      STEPDIR=$MODDIR/system/product/overlay
    else
      STEPDIR=/product/overlay
    fi
    # Try to mount /product
    if [ $STEPDIR = "/product/overlay" ]; then
      is_mounted " /product" || mount /product
      is_mounted_rw " /product" || mount_rw /product
    fi
  else
    PRODUCT=false
    STEPDIR=$MODDIR/system/vendor/overlay
  fi
  # Yeet all installed files into the void
  rm -rf $STEPDIR/QuickstepSwitcherOverlay.apk
  rm -rf $MODDIR/system/etc/permissions/privapp-permissions-quickstepswitcher.xml
  rm -rf $MODDIR/system/etc/sysconfig/quickstepswitcher-hiddenapi-package-whitelist.xml
  rm -rf $MODDIR/system/priv-app/QuickstepSwitcher*
  rm -rf $SWITCHER_OUTPUT/output/*
  rm -rf $SWITCHER_OUTPUT/lastChange
  rm -rf $SWITCHER_OUTPUT/reset
  rm -rf $SWITCHER_DIR/shared_prefs/tmp.xml
  rm /data/resource-cache/overlays.list
  [ $STEPDIR = "/product/overlay" ] && unmount_rw /product
fi

# Check if user wants to switch the Quickstep provider
if [ -f "$SWITCHER_OUTPUT/lastChange" ]; then
  CHANGE=true
  # Assign $STEPDIR var
  if [ -f "$SWITCHER_OUTPUT/isProduct" ]; then
    PRODUCT=true
    # Yay, magisk supports bind mounting /product now
    if [ $MAGISK_VER_CODE -ge "19305" ]; then
      STEPDIR=$MODDIR/system/product/overlay
    else
      STEPDIR=/product/overlay
    fi
    # Try to mount /product
    if [ $STEPDIR = "/product/overlay" ]; then
      is_mounted " /product" || mount /product
      is_mounted_rw " /product" || mount_rw /product
    fi
  else
    PRODUCT=false
    STEPDIR=$MODDIR/system/vendor/overlay
  fi

  # Assign misc variables
  PERMISSIONXML=$MODDIR/system/etc/permissions/privapp-permissions-quickstepswitcher.xml
  WHITELISTXML=$MODDIR/system/etc/sysconfig/quickstepswitcher-hiddenapi-package-whitelist.xml
  OVERLAY=$STEPDIR/QuickstepSwitcherOverlay.apk
  SYSTEMIZE_TARGET=$MODDIR/system/priv-app

  # Create needed dirs
  mkdir -p $STEPDIR
  mkdir -p $SYSTEMIZE_TARGET
  mkdir -p $MODDIR/system/etc/permissions
  mkdir -p $MODDIR/system/etc/sysconfig

  # Delete old provider dir
  rm -rf $MODDIR/system/priv-app/QuickstepSwitcher*
  # Copy needed files to module dir
  cp -rf $SWITCHER_OUTPUT/output/privapp-permissions-quickstepswitcher.xml $PERMISSIONXML
  cp -rf $SWITCHER_OUTPUT/output/quickstepswitcher-hiddenapi-package-whitelist.xml $WHITELISTXML
  cp -rf $SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk $OVERLAY
  cp -rf $SWITCHER_OUTPUT/output/systemize/* $SYSTEMIZE_TARGET/
  rm -rf $SWITCHER_DIR/shared_prefs/tmp.xml

  chmod 644 $OVERLAY; chmod 644 $PERMISSIONXML; chmod 644 $WHITELISTXML
  chmod 755 $SYSTEMIZE_TARGET/*; chmod 644 $SYSTEMIZE_TARGET/*/*
  [ $STEPDIR == "$MODDIR/system/vendor/overlay" ] && chown 0:2000 $STEPDIR

  [ $STEPDIR = "/product/overlay" ] && unmount_rw /product

  # Delete possible bootloop causing file and QuickstepSwitcher created files
  rm /data/resource-cache/overlays.list
  if [ -f "$OVERLAY" ]; then
    if ! grep -q "xyz.paphonb.quickstepswitcher.overlay" /data/system/overlays.xml; then
      sed -i 's|</overlays>|    <item packageName="xyz.paphonb.quickstepswitcher.overlay" userId="0" \
      targetPackageName="android" baseCodePath="/vendor/overlay/QuickstepSwitcherOverlay.apk" \
      state="6" isEnabled="true" isStatic="true" priority="99" />\n</overlays>|' /data/system/overlays.xml
    fi
    rm -rf $SWITCHER_OUTPUT/lastChange
  fi

  # Logging for days
  cp -f $LOGDIR/$MODID-tmp.log $LOGDIR/$MODID.log
  echo "---Device Info---" > $LOGDIR/$MODID-formatted.log
  grep "^ro.product.device[^#]" /system/build.prop | sed 's/ro.product.device/DeviceCode/g' >> $LOGDIR/$MODID-formatted.log
  grep "^ro.product.model[^#]" /system/build.prop | sed 's/ro.product.model/DeviceName/g' >> $LOGDIR/$MODID-formatted.log
  grep "^ro.build.type[^#]" /system/build.prop | sed 's/ro.build.type/BuildType/g' >> $LOGDIR/$MODID-formatted.log
  grep "^ro.build.version.security_patch[^#]" /system/build.prop | sed 's/ro.build.version.security_patch/SecurityPatch/g' >> $LOGDIR/$MODID-formatted.log
  grep "^ro.product.cpu.abilist[^#]" /system/build.prop | sed 's/ro.product.cpu.abilist/Arch/g' >> $LOGDIR/$MODID-formatted.log
  grep "^ro.build.version.sdk[^#]" /system/build.prop | sed 's/ro.build.version.sdk/APIVer/g' >> $LOGDIR/$MODID-formatted.log
  grep "^ro.build.flavor[^#]" /system/build.prop | sed 's/ro.build.flavor/BuildFlavor/g' >> $LOGDIR/$MODID-formatted.log
  echo "\n---ROM Info---" >> $LOGDIR/$MODID-formatted.log
  grep "^ro.build.host[^#]" /system/build.prop | sed 's/ro.build.host/Host/g' >> $LOGDIR/$MODID-formatted.log
  grep "^ro.*.device[^#]" /system/build.prop >> $LOGDIR/$MODID-formatted.log
  echo -e "\n---Variables---" >> $LOGDIR/$MODID-formatted.log
  ( set -o posix ; set ) >> $LOGDIR/$MODID-formatted.log
  echo -e "\n---Installed Files---" >> $LOGDIR/$MODID-formatted.log
  grep "^+ cp " $LOGDIR/$MODID.log | sed 's/.* //g' >> $LOGDIR/$MODID-formatted.log
  echo -e "\n---Errors---" >> $LOGDIR/$MODID-formatted.log
  grep "^[^+']" $LOGDIR/$MODID.log >> $LOGDIR/$MODID-formatted.log
  echo -e "\n---Magisk Version---" >> $LOGDIR/$MODID-formatted.log
  echo `grep "MAGISK_VER_CODE=" /data/adb/magisk/util_functions.sh | sed "s/MAGISK_VER_CODE/MagiskVersion/"` >> $LOGDIR/$MODID-formatted.log
  echo -e "\n---Module Version---" >> $LOGDIR/$MODID-formatted.log
  echo `grep "versionCode=" $MODDIR/module.prop` >> $LOGDIR/$MODID-formatted.log
fi
rm -f $LOGDIR/$MODID-tmp.log