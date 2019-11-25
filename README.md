# ledger-app-one 
Ledger hardware wallet support for Harmony ONE.  
This repository contains software and firmware source code for Harmony hardware wallet using Ledger Nano S.  
An example of Ledger Nano S running Harmony ONE app (LED UI) and companion app manual can be found  [here](https://docs.harmony.one/sdk-wiki/wallet-developers-guide/ledger).  

 

## Code List
```
  oneledger.go   simple companion host side app for testing Ledger Nano S firmware
  src/           firmware source code for Ledger Nano S
  wallet/        harmony-one hardware wallet main application code
  icos/          gif files for Ledger Nano S app icon and Ledger Live icon
  glyphs/        icon files used in firmware GUI
```

## Build Environment

### Docker toolchain image
In order to make compiling as early as possible you can make use of a docker image containing all the necessary compilers and the [nanos-secure-sdk](https://github.com/LedgerHQ/nanos-secure-sdk).

Make sure you have [Docker](https://www.docker.com/community-edition) installed.
#### Step 0 - Updated your ledger NanoS firmware to version 1.6.0
https://support.ledger.com/hc/en-us/articles/360002731113-Update-device-firmware


#### Step 1 - Pull docker image from docker.io:

```bash
docker pull coolcottontail/harmony:ledger-chain
```
Go to Step 2 if you can pull the image succesfully. 

Otherwise, you can build docker image from scratch locally using :

```bash
docker build -t ledger-chain:latest .
```

The `.` at the end is **important!**

 
#### Step 2 - Use Docker image
if you pull the image from docker.io, then use the following command:
```bash
docker run --rm -v "$(pwd)":/one-ledger -w /one-ledger coolcottontail/harmony:ledger-chain make
```

if you build image locally, then use the following command:
```bash
docker run --rm -v "$(pwd)":/one-ledger -w /one-ledger ledger-chain make
```

After the build, the firmware created as bin/app.hex 



## Load app onto Ledger Nano S

Before attempting to load the hex file, make sure your Ledger Nano S 
is connected and the firware is updated to the [latest version](https://support.ledgerwallet.com/hc/en-us/articles/360002731113-Update-the-firmware).

Enter your PIN and **make sure you're seeing the Dashboard app**.

### Using Docker image
#### Step 1 - Install virtualenv
```bash
[sudo] pip install -U setuptools
[sudo] pip install virtualenv
```

#### Step 2 - Create new virtualenv
#### linux dependencies for ledgerblue module
> libudev1 libudev-dev libusb-1.0-0-dev

```bash
virtualenv -p python3 venv
source venv/bin/activate
pip install ledgerblue
or pip install git+https://github.com/LedgerHQ/blue-loader-python.git 
```

If you run into errors here, make sure you have the required dependencies installed. See [Ledger - Loader Python](https://github.com/LedgerHQ/blue-loader-python).

This step will create a directory venv and put all python related modules there.

#### Step 3 - Load HEX file
This step requires sudo permission
```bash
./load_fw.sh
```

this bash actually execute the following:
```bash
sudo ./venv/bin/python -m ledgerblue.loadApp --appFlags 0x40 --path 44/1023  --curve secp256k1 --tlv --targetId 0x31100004 --delete --fileName bin/app.hex --appName One --appVersion 0.0.1 --dataSize 0 --icon 01ffffff00ffffff00ffffffffffffc7e1bbcdbbddbbcdbbc50bd8a3ddbbddbbddb3edc7e3ffffffff
```


## Build host companion app
This is only for testing the ledger firmware. If you use javascript, then don't need to do this step.
```
go build oneledger.go
```
