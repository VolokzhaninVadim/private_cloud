#!/bin/sh

# Create variables
GPG_KEY=634064C6


# Decrypt
for i in *tgz.gpg;
do
gpg --decrypt \
    --batch \
    --passphrase $GPG_PASSPHRASE \
    --recipient $GPG_KEY \
    "$i" > "$i".tgz;
done;

# Unzip
for i in *.tgz;
do
tar --preserve-permissions \
    --extract \
    --gzip \
    --file "$i";

rm $i;
done;
