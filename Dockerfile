FROM zondax/ledger-docker-bolos

ENV BOLOS_ENV=/opt/bolos
ENV BOLOS_SDK=$BOLOS_ENV/nanos-secure-sdk
#ENV BOLOS_SDK=$BOLOS_ENV/blue-secure-sdk

RUN sudo git clone https://github.com/LedgerHQ/nanos-secure-sdk.git $BOLOS_ENV/nanos-secure-sdk
RUN sudo git clone https://github.com/ledgerhq/blue-secure-sdk $BOLOS_ENV/blue-secure-sdk
RUN sudo apt-get update && sudo apt-get install -y python3-pip


USER test
