# ledger-app-one
Ledger hardware wallet 




# Build Environment

## Docker toolchain image
In order to make compiling as eas as possible you can make use of a docker image containing all the necessary compilers and the [nanos-secure-sdk](https://github.com/LedgerHQ/nanos-secure-sdk).

Make sure you have [Docker](https://www.docker.com/community-edition) installed.

### Step 1 - Build the image:
> make sure to select the appropriate $BOLOS_SDK in Dockerfile
```bash
docker build -t ledger-chain:latest .
```
The `.` at the end is **important!**

 
### Step 2 - Use Docker image
```bash
docker run --rm -v "$(pwd)":/one-ledger -w /one-ledger ledger-chain make
```

## Build
```bash
make
```


# Load app onto Ledger Nano S

Before attempting to load the hex file, make sure your Ledger Nano S 
is connected and the firware is updated to the [latest version](https://support.ledgerwallet.com/hc/en-us/articles/360002731113-Update-the-firmware).

Enter your PIN and **make sure you're seeing the Dashboard app**.

## Using Docker image
### Step 1 - Install virtualenv
```bash
[sudo] pip install -U setuptools
[sudo] pip install virtualenv
```

### Step 2 - Create new virtualenv
#### linux dependencies for ledgerblue module
> libudev1 libudev-dev libusb-1.0-0-dev

```bash
virtualenv -p python3 ledger
source ledger/bin/activate
pip install ledgerblue
or pip install git+https://github.com/LedgerHQ/blue-loader-python.git 
```

If you run into errors here, make sure you have the required dependencies installed. See [Ledger - Loader Python](https://github.com/LedgerHQ/blue-loader-python).
