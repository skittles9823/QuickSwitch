#!/sbin/sh
. /tmp/backuptool.functions
list_files() {
cat <<EOF
$(cat /tmp/addon.d/$MODID-files2)
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$REPLACEMENT"
      [ -f "$C/$FILE" ] && restore_file $FILE $R
    done
  ;;
  pre-backup)
    cp -f /tmp/addon.d/$MODID-files /tmp/addon.d/$MODID-files2
    sed -i "s/NORESTORE//g" /tmp/addon.d/$MODID-files2
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    rm -f /tmp/addon.d/$MODID-files2
  ;;
esac
