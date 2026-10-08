#!/usr/bin/env bash
set -euo pipefail

SCRCPY_HOME="${SCRCPY_HOME:-$HOME/.local/opt/scrcpy}"
WAIT_TIMEOUT="${WAIT_TIMEOUT:-60}"

# Binary lookup: PATH first, then custom directory
find_tool() {
    local tool="$1"
    if command -v "$tool" >/dev/null 2>&1; then
        command -v "$tool"
    elif [[ -x "$SCRCPY_HOME/$tool" ]]; then
        echo "$SCRCPY_HOME/$tool"
    else
        return 1
    fi
}

ADB="$(find_tool adb)" || { echo "Error: adb not found" >&2; exit 1; }
SCRCPY="$(find_tool scrcpy)" || { echo "Error: scrcpy not found" >&2; exit 1; }

# Serials of devices that passed authorization
get_authorized_devices() {
    "$ADB" devices | awk '$2 == "device" { print $1 }'
}

has_unauthorized_device() {
    "$ADB" devices | awk '$2 == "unauthorized" { found = 1 } END { exit !found }'
}

mapfile -t devices < <(get_authorized_devices)

# Wait for authorization via the adb daemon instead of polling
if (( ${#devices[@]} == 0 )); then
    echo "Waiting for device (timeout: ${WAIT_TIMEOUT} seconds)..."
    if has_unauthorized_device; then
        echo "Device detected but unauthorized. Please confirm USB debugging on your phone."
    fi
    if ! timeout "${WAIT_TIMEOUT}" "$ADB" wait-for-device; then
        echo "Error: no authorized device found within ${WAIT_TIMEOUT} seconds." >&2
        exit 1
    fi
    mapfile -t devices < <(get_authorized_devices)
fi

serial="${ANDROID_SERIAL:-}"

if [[ -z "$serial" ]]; then
    case ${#devices[@]} in
        0)
            echo "Error: device disappeared or is unauthorized." >&2
            exit 1
            ;;
        1)
            serial="${devices[0]}"
            ;;
        *)
            echo "Multiple devices found:"
            PS3="Select a device [1-${#devices[@]}]: "
            select choice in "${devices[@]}"; do
                if [[ -n "$choice" ]]; then
                    serial="$choice"
                    break
                fi
                echo "Invalid selection, try again."
            done
            ;;
    esac
fi

echo "Launching scrcpy for $serial..."
exec "$SCRCPY" -s "$serial" "$@"
