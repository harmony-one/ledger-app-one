docker run  -it  --rm --privileged -v /run/udev:/run/udev -v /dev:/dev:ro   -v .:/one-ledger -w /one-ledger ledger-chain 
