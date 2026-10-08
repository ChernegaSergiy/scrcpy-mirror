# scrcpy-mirror

A Bash script that waits for an Android smartphone to be connected over USB and launches [scrcpy](https://github.com/Genymobile/scrcpy) to mirror its screen on the computer.

## Requirements

- `adb` in PATH (or in `~/.local/opt/scrcpy`)
- `scrcpy` in PATH (or in `~/.local/opt/scrcpy`, where the [official binary](https://github.com/Genymobile/scrcpy/releases) can be downloaded)
- USB debugging enabled on the phone

## Usage

```bash
./mirror.sh                             # auto-select the device
./mirror.sh --capture-orientation=@90   # any scrcpy arguments are passed through
ANDROID_SERIAL=serial ./mirror.sh       # target a specific device
```

The script waits up to 60 seconds for the device to be authorized (confirm the prompt on the phone screen) and, if several phones are connected, lets you pick one (`WAIT_TIMEOUT` overrides the timeout).

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
