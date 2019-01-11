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
DID_MOUNT_RW=
if [ -f "$SWITCHER_OUTPUT/isProduct" ]; then
  if [ -f "$SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk" ]; then
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
    while [ ! -f /product/overlay/QuickstepSwitcherOverlay.apk ]; do
      sleep 1
      is_mounted /product || mount /product
      is_mounted_rw /product || mount_rw /product
      cp -rf $SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk /product/overlay/QuickstepSwitcherOverlay.apk
    done
    chmod 644 /product/overlay/QuickstepSwitcherOverlay.apk
    unmount_rw /product
    if [ -f "/product/overlay/QuickstepSwitcherOverlay.apk" ]; then
      rm -rf $SWITCHER_OUTPUT/lastChange
    fi
  fi
fi
if [ -f "$SWITCHER_OUTPUT/gridRecents" ]; then GRID=true; fi
#grid_enable(){ if $MAGISK; then resetprop ro.recents.grid true; else setprop ro.recents.grid true; fi }
#grid_disable(){ if $MAGISK; then resetprop ro.recents.grid false; else setprop ro.recents.grid false; fi }
#[ "$GRID" ] && grid_enable || grid_disable
[ -d /storage/emulated/0 ] && SDCARD=/storage/emulated/0 || SDCARD=/data/media/0
mkdir -p $SDCARD/Documents/$MODID
cp -rf /cache/$MODID* $SDCARD/Documents/$MODID/
