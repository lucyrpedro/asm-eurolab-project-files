# !/bin/bash

## Installing libfuse ###

# git clone git@github.com:libfuse/libfuse.git
# cd libfuse
# mkdir build
# cd build
# meson ..
# ninja
# cd ../../

## Copying files ###

git clone https://github.com/lucyrpedro/asm-eurolab-project-files.git

## Installing ior ###

# wget https://github.com/hpc/ior/releases/download/3.2.1/ior-3.2.1.tar.gz
# tar xvzf ior-3.2.1.tar.gz
# cd ior-3.2.1
# ./configure
# make
# cp src/ior ../asm-eurolab-project-files/benchmarks
# cd ../

echo 'Copying ior'
cp /home/pedro/ior-3.2.1/build/src/ior asm-eurolab-project-files/benchmarks

## Installing md-workbench ###

# git clone https://github.com/JulianKunkel/md-workbench.git
# cd md-workbench
# ./configure
# cd build
# make
# cp src/md-workbench ../../asm-eurolab-project-files/benchmarks
# cd ../../

echo 'Copying md-benchwork'
cp /home/pedro/md-workbench/build/src/md-workbench asm-eurolab-project-files/benchmarks

## Cleaning ###

# rm -rf ior*
# rm -rf md*

## Running the tests ###

echo 'Copying Fuse2 Filters'
cp fusexmp libfuse/build/example/
cp fusexmp_fh libfuse/build/example/

cd asm-eurolab-project-files/

./run-fuse2.sh clean test
