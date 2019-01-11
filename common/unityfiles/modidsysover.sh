#!/system/bin/sh
MODPATH=${0%/*}

if [ ! -f $INFO ]; then
  rm -rf $MOUNTPATH/$MODID
  rm -f $0
  exit 0
elif [ -d $MOUNTPATH/$MODID ]; then
  exit 0
fi

mount -o rw,remount /system
[ -L /system/vendor ] && mount -o rw,remount /vendor
if [ -f $INFO ]; then
  while read LINE; do
    if [ "$(echo -n $LINE | tail -c 4)" == ".bak" ]; then
      continue
    elif [ -f "$LINE.bak" ]; then
      mv -f $LINE.bak $LINE
    else
      rm -f $LINE
      while true; do
        LINE=$(dirname $LINE)
        if [ "$(ls $LINE)" ]; then
          break 1
        else
          rm -rf $LINE
        fi
      done
    fi
  done < $INFO
  rm -f $INFO
fi
rm -rf $MOUNTPATH/$MODID
# CUSTOM USER SCRIPT
rm -f $0
mount -o ro,remount /system
[ -L /system/vendor ] && mount -o ro,remount /vendor
  