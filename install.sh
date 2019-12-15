# !/bin/bash

if [ $1 == 'clean' ]
then
  rm -rf figs*
  rm -rf results*
fi

if [ $1 == 'cleanfuse' ]
then
  rm -rf figs*
  rm -rf results*
  fusermount -u libfuse/build/mnt
  rm -rf libfuse
fi

# git clone git@github.com:libfuse/libfuse.git
# cd libfuse
# mkdir build
# cd build
# meson ..
# ninja
# cd ../../

# sudo python3 -m pytest test/
# sudo ninja install
# sudo chown root:root util/fusermount3
# sudo chmod 4755 util/fusermount3
# python3 -m pytest test/
# mkdir -p out
# cd ../../

## Running DD ###

## DD needs to be update to run the last filter, passthrough_hp

## when this part returns, the next comments have to be adjusted

cp run-dd.sh libfuse/build/
cd libfuse/build/             ### adjust me!

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running dd'
echo 'xxxxxxxxxxxxxxxxxx'

./run-dd.sh passthrough mds clean
./run-dd.sh passthrough ds none

# wait

cp ../../parse-dd.py out-dd   ### adjust me!
cp ../../plot-dd.R out-dd     ### adjust me!

cd out-dd                     ### adjust me!

python3 parse-dd.py *.txt

# wait

./plot-dd.R

cp results-dd.csv ../../../
cp figs-dd.pdf ../../../

##### Install ior and then copy the executable!!!

# IOR needs to be updated to include all filters

# IOR and IOR-r need the same parameters so that parse and plot will work

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running ior'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../../../
cp run-ior.sh libfuse/build/
cp run-ior-r.sh libfuse/build/
cp ior libfuse/build/

cd libfuse/build/             ### adjust me!

## Running IOR

./run-ior.sh tmpfs clean
./run-ior.sh fuse none

cp ../../parse-ior.py out-ior   ### adjust me!
cp ../../plot-ior.R out-ior     ### adjust me!

cd out-ior                     ### adjust me!

python3 parse-ior.py *.txt

./plot-ior.R

cp results-ior.csv ../../../
cp figs-ior.pdf ../../../

## Running IOR-r

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running ior-random'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../

./run-ior-r.sh tmpfs clean
./run-ior-r.sh fuse none

cp ../../parse-ior.py out-ior-r   ### adjust me!
cp ../../plot-ior.R out-ior-r     ### adjust me!

cd out-ior-r                     ### adjust me!

python3 parse-ior.py *.txt

./plot-ior.R

cp results-ior.csv ../../../results-ior-r.csv
cp figs-ior.pdf ../../../figs-ior-r.pdf

## Running MD ###

# MD needs to be update to run all filters

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running md'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../../../
cp run-md.sh libfuse/build/
cp md-workbench libfuse/build/
cd libfuse/build/             ### adjust me!

./run-md.sh tmpfs clean
./run-md.sh fuse none

# wait

cp ../../parse-md.py out-md   ### adjust me!
cp ../../plot-md.R out-md     ### adjust me!

cd out-md                     ### adjust me!

python3 parse-md.py *.txt

# wait

./plot-md.R

cp results-md.csv ../../../
cp figs-md.pdf ../../../

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Updating Git'
echo 'xxxxxxxxxxxxxxxxxx'

git pull
git add -f figs* results*
git commit -m "Updating the results"
git push
