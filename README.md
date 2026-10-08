# scrcpy-mirror

Bash-скрипт, який чекає на підключення Android-смартфона через USB і запускає [scrcpy](https://github.com/Genymobile/scrcpy) для трансляції екрана на комп'ютер.

## Вимоги

- `adb` у PATH (або в `~/.local/opt/scrcpy`)
- `scrcpy` у PATH (або в `~/.local/opt/scrcpy`, звідти можна завантажити [офіційний бінарник](https://github.com/Genymobile/scrcpy/releases))
- Увімкнене налагодження USB на телефоні

## Використання

```bash
./mirror.sh                       # автовибір пристрою
./mirror.sh --capture-orientation=@90   # будь-які аргументи scrcpy передаються далі
ANDROID_SERIAL=serial ./mirror.sh # конкретний пристрій
```

Скрипт чекає на авторизацію пристрою (запит на екрані телефону) до 60 секунд
(`WAIT_TIMEOUT`), а за наявності кількох підключених телефонів пропонує вибір.
