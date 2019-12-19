# !/bin/bash

# Bash Script for cloning the files and run the tests

# Options: Parameter $1

# test      small parameters (short run)
# none      real parameters (long run)

git clone https://github.com/lucyrpedro/asm-eurolab-project-files.git

## Running the tests ###
cd asm-eurolab-project-files/

./prepare.sh

# cp src/ior ../asm-eurolab-project-files/benchmarks
# cp src/md-workbench ../../asm-eurolab-project-files/benchmarks (It's not working on the server!)
cp /home/pedro/ior-3.2.1/build/src/ior asm-eurolab-project-files/benchmarks
cp /home/pedro/md-workbench/build/src/md-workbench asm-eurolab-project-files/benchmarks

## Cleaning ###

# rm -rf ior*
# rm -rf md*

if [ $1 == 'test' ]
then
  ./run.sh clean $1
else
  ./run.sh clean none
fi
