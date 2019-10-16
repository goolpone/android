#!/bin/bash

DEVICE=a5y17lte
URL=$(curl -s https://download.lineageos.org/$DEVICE | grep -m 1 "href.*lineage-" | sed 's/^.*href="//' | sed 's/\.zip.*$/\.zip/')
currentPath=$PWD

sudo apt-get install brotli

mkdir -p $currentPath/system_dump/ && cd $currentPath/system_dump/
wget $URL
unzip lineage-*.zip system.transfer.list system.new.dat*
brotli --decompress system.new.dat.br --output=system.new.dat
wget https://raw.githubusercontent.com/xpirt/sdat2img/master/sdat2img.py
python sdat2img.py system.transfer.list system.new.dat system.img
mkdir system && sudo mount system.img system/
rm -rf $currentPath/crDroid/vendor/samsung/*
cd $currentPath/crDroid/device/samsung/$DEVICE && ./extract-files.sh $currentPath/system_dump/
cd $currentPath/crDroid/device/samsung/universal7880-common && ./extract-files.sh $currentPath/system_dump/
sudo umount $currentPath/system_dump/system
rm -rf $currentPath/system_dump

