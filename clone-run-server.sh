# !/bin/bash

# Bash Script for cloning the files and run the tests

# Options: Parameter $1

# test      small parameters (short run)
# none      real parameters (long run)

# Options: Parameter $2

# run      Number of runs

git clone https://github.com/lucyrpedro/asm-eurolab-project-files.git

cd asm-eurolab-project-files/

./prepare.sh

cp /home/pedro/ior-3.2.1/build/src/ior benchmarks/
cp /home/pedro/md-workbench/build/src/md-workbench benchmarks/

## Running the tests ###

if [ $1 == 'test' ]
then
  ./run-server.sh clean $1 $2
else
  ./run-server.sh clean none $2
fi
