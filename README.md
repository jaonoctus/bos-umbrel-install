# bos-umbrel-install
Set up BOS on Umbrel

## Install

- Requires [Umbrel](https://github.com/getumbrel/umbrel) with `bitcoin` and `lightning` apps installed.

1. Download the script under Umbrel folder (usually `~/umbrel`)

```bash
curl -L https://github.com/jaonoctus/bos-umbrel-install/releases/download/v0.1.0/bos-umbrel-install.sh -o bos-umbrel-install.sh
```

2. Verify the script (optional)

```bash
# download checksum
curl -L https://github.com/jaonoctus/bos-umbrel-install/releases/download/v0.1.0/SHA256SUM -o SHA256SUM

# download signature
curl -L https://github.com/jaonoctus/bos-umbrel-install/releases/download/v0.1.0/SHA256SUM.asc -o SHA256SUM.asc

# import my key
gpg --keyserver keyserver.ubuntu.com --recv-keys 6B457D060ACE363C9D67D8E6782C165A293D6E18

# Verify if the checksum was not modified
gpg --verify SHA256SUM.asc

# Verify if the script was not modified
sha256sum --check SHA256SUM
```

2. Run the script

```bash
sudo bash bos-umbrel-install.sh
```

## Usage

```
sudo ./bin/bos
```
