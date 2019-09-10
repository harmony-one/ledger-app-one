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

#### Step 1 - Build the image:
> make sure to select the appropriate $BOLOS_SDK in Dockerfile
```bash
docker build -t ledger-chain:latest .
```
The `.` at the end is **important!**

 
#### Step 2 - Use Docker image
```bash
docker run --rm -v "$(pwd)":/one-ledger -w /one-ledger ledger-chain make
```

### Build
```bash
make
```


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

#### Step 3 - Load HEX file
This step requires sudo permission
```bash
./load_fw.sh
```

#### Step 4 - Leave virtualenv
To get out of your Python virtualenv again after everything is done.
```bash
deactivate
```

## Build host companion app
```
go build oneledger.go
```
