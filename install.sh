# !/bin/bash

# Assuming libfuse is installed in the directory ../libfuse

if [ $1 == 'clean' ]
then
  rm -rf results-database/*
  rm -rf results-figures/*
  rm -rf out-files/*
fi

## Running DD ###

## DD needs to be update to run the last filter, passthrough_hp

cp bash-scripts/run-dd.sh ../libfuse/build/
cd ../libfuse/build/

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running dd'
echo 'xxxxxxxxxxxxxxxxxx'

# Running the filters with a Bash script

./run-dd.sh passthrough tmpfs clean
./run-dd.sh passthrough fuse none

cp ../../asm-eurolab-project-files/python-scripts/parse-dd.py out-dd
cp ../../asm-eurolab-project-files/r-scripts/plot-dd.R out-dd

cd out-dd

# Running the Python script to parse the results to a csv file

python3 parse-dd.py *.txt

# Running the R script to generate the graphics

./plot-dd.R

# Saving results and intermediate files

cp results-dd.csv ../../../asm-eurolab-project-files/results-database
cp figs-dd.pdf ../../../asm-eurolab-project-files/results-figures
cp -r ../out-dd ../../../asm-eurolab-project-files/out-files

# Cleaning the files

cd ..
rm -rf out-dd
rm run-dd.sh

##### Install ior and then copy the executable!!!

# IOR needs to be updated to include all filters

# IOR and IOR-r need the same parameters so that parse and plot will work

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running ior'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../../asm-eurolab-project-files
cp bash-scripts/run-ior.sh ../libfuse/build/
cp bash-scripts/run-ior-r.sh ../libfuse/build/
cp benchmarks/ior ../libfuse/build/

cd ../libfuse/build/

## Running IOR

# Running the filters with a Bash script

./run-ior.sh tmpfs clean
./run-ior.sh fuse none

cp ../../asm-eurolab-project-files/python-scripts/parse-ior.py out-ior
cp ../../asm-eurolab-project-files/r-scripts/plot-ior.R out-ior

cd out-ior

# Running the Python script to parse the results to a csv file

python3 parse-ior.py *.txt

# Running the R script to generate the graphics

./plot-ior.R

# Saving results and intermediate files

cp results-ior.csv ../../../asm-eurolab-project-files/results-database
cp figs-ior.pdf ../../../asm-eurolab-project-files/results-figures
cp -r ../out-ior ../../../asm-eurolab-project-files/out-files

## Running IOR-r

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running ior-random'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../

# Running the filters with a Bash script

./run-ior-r.sh tmpfs clean
./run-ior-r.sh fuse none

cp ../../asm-eurolab-project-files/python-scripts/parse-ior.py out-ior-r
cp ../../asm-eurolab-project-files/r-scripts/plot-ior.R out-ior-r

cd out-ior-r

# Running the Python script to parse the results to a csv file

python3 parse-ior.py *.txt

# Running the R script to generate the graphics

./plot-ior.R

# Saving results and intermediate files

cp results-ior.csv ../../../asm-eurolab-project-files/results-database/results-ior-r.csv
cp figs-ior.pdf ../../../asm-eurolab-project-files/results-figures/figs-ior-r.pdf
cp -r ../out-ior-r ../../../asm-eurolab-project-files/out-files

# Cleaning the files

cd ..
rm -rf out-ior
rm -rf out-ior-r
rm run-ior.sh
rm run-ior-r.sh

## Running MD ###

# MD needs to be update to run all filters

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running md'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../../asm-eurolab-project-files
cp bash-scripts/run-md.sh ../libfuse/build/
cp benchmarks/md-workbench ../libfuse/build/

cd ../libfuse/build/

# Running the filters with a Bash script

./run-md.sh tmpfs clean
./run-md.sh fuse none

cp ../../asm-eurolab-project-files/python-scripts/parse-md.py out-md
cp ../../asm-eurolab-project-files/r-scripts/plot-md.R out-md

cd out-md

# Running the Python script to parse the results to a csv file

python3 parse-md.py *.txt

# Running the R script to generate the graphics

./plot-md.R

# Saving results and intermediate files

cp results-md.csv ../../../asm-eurolab-project-files/results-database
cp figs-md.pdf ../../../asm-eurolab-project-files/results-figures
cp -r ../out-md ../../../asm-eurolab-project-files/out-files

# Cleaning the files

cd ..
rm -rf out-md
rm run-md.sh

# echo 'xxxxxxxxxxxxxxxxxx'
# echo 'Updating Git'
# echo 'xxxxxxxxxxxxxxxxxx'
#
# cd ../../../fuse/test-local
#
# git pull
# git add *
# git commit -m "Updating the results and the scripts"
# git push
