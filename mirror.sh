#!/usr/bin/env bash
set -euo pipefail

SCRCPY_HOME="${SCRCPY_HOME:-$HOME/.local/opt/scrcpy}"
WAIT_TIMEOUT="${WAIT_TIMEOUT:-60}"

find_tool() {
    local name="$1"
    if command -v "$name" >/dev/null 2>&1; then
        command -v "$name"
    elif [[ -x "$SCRCPY_HOME/$name" ]]; then
        echo "$SCRCPY_HOME/$name"
    else
        return 1
    fi
}

ADB="$(find_tool adb)" || { echo "Помилка: adb не знайдено" >&2; exit 1; }
SCRCPY="$(find_tool scrcpy)" || { echo "Помилка: scrcpy не знайдено" >&2; exit 1; }

"$ADB" start-server >/dev/null

echo "Чекаю на підключення телефону..."
deadline=$((SECONDS + WAIT_TIMEOUT))
while (( SECONDS < deadline )); do
    mapfile -t lines < <("$ADB" devices | tail -n +2 | grep -P '\tdevice$' || true)
    if (( ${#lines[@]} > 0 )); then
        break
    fi
    unauthorized=$("$ADB" devices | grep -c $'\tunauthorized' || true)
    if (( unauthorized > 0 )); then
        echo "Телефон знайдено, але не авторизовано — підтвердіть запит на екрані телефону"
    fi
    sleep 1
done

if (( ${#lines[@]} == 0 )); then
    echo "Помилка: жоден пристрій не підключений протягом ${WAIT_TIMEOUT} с" >&2
    exit 1
fi

if [[ -n "${ANDROID_SERIAL:-}" ]]; then
    serial="$ANDROID_SERIAL"
elif (( ${#lines[@]} == 1 )); then
    serial="${lines[0]%%$'\t'*}"
else
    echo "Знайдено кілька пристроїв:"
    for i in "${!lines[@]}"; do
        echo "  $((i + 1))) ${lines[i]%%$'\t'*}"
    done
    read -rp "Виберіть номер: " choice
    serial="${lines[choice - 1]%%$'\t'*}"
fi

echo "Запуск scrcpy для пристрою $serial"
exec "$SCRCPY" -s "$serial" "$@"
