docker pull nbasim/ledger-blue-sdk
docker run -t -i nbasim/ledger-blue-sdk /bin/bash
cd home
git clone https://github.com/LedgerHQ/nanos-secure-sdk.git
apt-get update
apt-get install libc6-dev-i386
