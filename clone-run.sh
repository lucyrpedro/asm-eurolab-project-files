# !/bin/bash

git clone https://github.com/lucyrpedro/asm-eurolab-project-files.git

## Running the tests ###
cd asm-eurolab-project-files/

./prepare.sh

cp src/ior ../asm-eurolab-project-files/benchmarks
cp src/md-workbench ../../asm-eurolab-project-files/benchmarks

## Cleaning ###
rm -rf ior*
rm -rf md*

./install.sh clean
