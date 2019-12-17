# !/bin/bash

git clone https://github.com/lucyrpedro/asm-eurolab-project-files.git

## Running the tests ###
cd asm-eurolab-project-files/

./prepare.sh

cp src/ior ../asm-eurolab-project-files/benchmarks
# cp src/md-workbench ../../asm-eurolab-project-files/benchmarks (It's not working on the server!)
cp /home/pedro/md-workbench/build/src/md-workbench asm-eurolab-project-files/benchmarks

## Cleaning ###
rm -rf ior*
rm -rf md*

./run.sh clean
