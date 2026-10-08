# scrcpy-mirror

A Bash script that waits for an Android device to be authorized over USB and launches [scrcpy](https://github.com/Genymobile/scrcpy) to mirror its screen on the computer.

## Requirements

- `adb` in PATH (or in `~/.local/opt/scrcpy`)
- `scrcpy` in PATH (or in `~/.local/opt/scrcpy`, where the [official binary](https://github.com/Genymobile/scrcpy/releases) can be downloaded)
- USB debugging enabled on the phone

## Usage

```bash
./mirror.sh                             # auto-select the device
./mirror.sh --capture-orientation=@90   # any scrcpy arguments are passed through
```

When several devices are connected, the script shows a numbered menu. The serial number is passed to scrcpy automatically via `-s <serial>`.

## Environment variables

| Variable | Default | Description |
| --- | --- | --- |
| `SCRCPY_HOME` | `$HOME/.local/opt/scrcpy` | Directory used to look for `adb` and `scrcpy` when they are not in PATH |
| `WAIT_TIMEOUT` | `60` | Seconds to wait for an authorized device before giving up |
| `ANDROID_SERIAL` | — | Target a specific device by serial number (e.g. `ANDROID_SERIAL=serial ./mirror.sh`) |

## Contributing

Contributions are welcome and appreciated! Here's how you can contribute:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please make sure to update tests as appropriate and adhere to the existing coding style.

## License

This project is licensed under the CSSM Unlimited License v2.0 (CSSM-ULv2). See the [LICENSE](LICENSE) file for details.