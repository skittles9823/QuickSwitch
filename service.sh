#!/system/bin/sh

# Late props which must be set after boot_completed
{
    until [[ "$(getprop sys.boot_completed)" == "1" ]]; do
        sleep 1
    done

    # avoid breaking OnePlus display modes/fingerprint scanners
    resetprop vendor.boot.verifiedbootstate green
}&
