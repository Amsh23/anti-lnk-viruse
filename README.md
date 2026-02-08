# Anti-LNK Viruse (USB Shortcut Fix)

**Anti‑LNK** is a simple PowerShell script to clean USB drives infected by shortcut (LNK) malware. With explicit user confirmation, it removes malicious shortcut files, deletes `autorun.inf`, and restores hidden files.

> ⚠️ Warning: This tool modifies files on your USB drive. Back up important data before running it.

## Features

- Disables Windows AutoPlay/AutoRun system-wide.
- Automatically detects removable USB drives.
- Deletes `.lnk` files with user confirmation.
- Deletes `autorun.inf` with user confirmation.
- Restores hidden/system file attributes.

## Requirements

- Windows 10/11
- PowerShell (the script sets the execution policy for the current session only)

## Usage

1. Download `anti-lnk.ps1`.
2. Right‑click PowerShell and choose **Run as Administrator**.
3. Run the script:

```powershell
./anti-lnk.ps1
```

4. Select the target USB drive and answer the prompts.

## Quick run with `run.cmd`

`run.cmd` is included for quick execution on Windows. Right‑click it and choose **Run as Administrator**.

## Zenodo upload (release publishing)

A helper script is included to upload a release to Zenodo. The script **reads the token from the environment** so no token is stored in the repo.

- Set the token (PowerShell):

```powershell
$env:ZENODO_TOKEN = "your-token"
```

- Run the upload:

```powershell
./zenodo-upload.ps1 -FilePath .\anti-lnk.ps1 -Title "Anti-LNK Viruse" -Description "USB shortcut fix" -Creators "Your Name"
```

## Security notes

- The tool **never** changes files without your confirmation.
- Always back up data before cleaning.
- Use isolated/sandboxed systems for untrusted USB drives.

## Contributing

Pull requests and suggestions are welcome. Please include clear descriptions of your changes.

## License

Released under the license in [LICENSE](./LICENSE).
