# !/bin/bash

if [ $1 == 'clean' ]
then
  rm -rf results-database
  rm -rf results-figures
  rm -rf out-files
  rm -rf ../libfuse/build/out*
  rm -f ../libfuse/build/*.sh
  rm -f ../libfuse/build/*.py
  rm -f ../libfuse/build/*.R
fi

## Creating the output directories ###

mkdir -p results-database/
mkdir -p results-figures/
mkdir -p out-files/

## Running DD ###

cp -f bash-scripts/run-dd.sh ../libfuse/build/
cd ../libfuse/build/

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running dd'
echo 'xxxxxxxxxxxxxxxxxx'

# Running the filters with a Bash script

./run-dd.sh tmpfs passthrough $2 $3
./run-dd.sh fuse passthrough $2 $3
./run-dd.sh tmpfs passthrough_ll $2 $3
./run-dd.sh fuse passthrough_ll $2 $3
./run-dd.sh tmpfs passthrough_fh $2 $3
./run-dd.sh fuse passthrough_fh $2 $3
./run-dd.sh tmpfs passthrough_hp $2 $3
./run-dd.sh fuse passthrough_hp $2 $3

cp -f ../../asm-eurolab-project-files/python-scripts/parse-dd.py out-dd
cp -f ../../asm-eurolab-project-files/r-scripts/plot-dd.R out-dd

cd out-dd

# Running the Python script to parse the results to a csv file

python3 parse-dd.py *.txt

# Running the R script to generate the graphics

./plot-dd.R 0

# Saving results and intermediate files

cp -f results-dd.csv ../../../asm-eurolab-project-files/results-database
cp -f figs-dd.pdf ../../../asm-eurolab-project-files/results-figures
cp -rf ../out-dd/ ../../../asm-eurolab-project-files/out-files/

# Cleaning the files

cd ..
rm -rf out-dd
rm run-dd.sh

##### Install ior and then copy the executable!!!

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running ior'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../../asm-eurolab-project-files
cp -f bash-scripts/run-ior-s-mpi.sh ../libfuse/build/
cp -f bash-scripts/run-ior-s-mpi-r.sh ../libfuse/build/
cp -f benchmarks/ior ../libfuse/build/

cd ../libfuse/build/

## Running IOR-s-mpi

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running ior-segments-mpi'
echo 'xxxxxxxxxxxxxxxxxx'

# Running the filters with a Bash script

./run-ior-s-mpi.sh tmpfs passthrough $2 $3
./run-ior-s-mpi.sh fuse passthrough $2 $3
./run-ior-s-mpi.sh tmpfs passthrough_ll $2 $3
./run-ior-s-mpi.sh fuse passthrough_ll $2 $3
./run-ior-s-mpi.sh tmpfs passthrough_fh $2 $3
./run-ior-s-mpi.sh fuse passthrough_fh $2 $3
./run-ior-s-mpi.sh tmpfs passthrough_hp $2 $3
./run-ior-s-mpi.sh fuse passthrough_hp $2 $3

cp -f ../../asm-eurolab-project-files/python-scripts/parse-ior-s-mpi.py out-ior-s-mpi
cp -f ../../asm-eurolab-project-files/r-scripts/plot-ior-s-mpi.R out-ior-s-mpi

cd out-ior-s-mpi

# Running the Python script to parse the results to a csv file

python3 parse-ior-s-mpi.py *.txt

# Running the R script to generate the graphics

./plot-ior-s-mpi.R 0

# Saving results and intermediate files

cp -f results-ior-s-mpi.csv ../../../asm-eurolab-project-files/results-database/
cp -f figs-ior-s-mpi.pdf ../../../asm-eurolab-project-files/results-figures/
cp -rf ../out-ior-s-mpi/ ../../../asm-eurolab-project-files/out-files/

## Running IOR-s-mpi-r

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running ior-segments-mpi-random'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../

# Running the filters with a Bash script

./run-ior-s-mpi-r.sh tmpfs passthrough $2 $3
./run-ior-s-mpi-r.sh fuse passthrough $2 $3
./run-ior-s-mpi-r.sh tmpfs passthrough_ll $2 $3
./run-ior-s-mpi-r.sh fuse passthrough_ll $2 $3
./run-ior-s-mpi-r.sh tmpfs passthrough_fh $2 $3
./run-ior-s-mpi-r.sh fuse passthrough_fh $2 $3
./run-ior-s-mpi-r.sh tmpfs passthrough_hp $2 $3
./run-ior-s-mpi-r.sh fuse passthrough_hp $2 $3

cp -f ../../asm-eurolab-project-files/python-scripts/parse-ior-s-mpi-r.py out-ior-s-mpi-r
cp -f ../../asm-eurolab-project-files/r-scripts/plot-ior-s-mpi-r.R out-ior-s-mpi-r

cd out-ior-s-mpi-r

# Running the Python script to parse the results to a csv file

python3 parse-ior-s-mpi-r.py *.txt

# Running the R script to generate the graphics

./plot-ior-s-mpi-r.R 0

# Saving results and intermediate files

cp -f results-ior-s-mpi-r.csv ../../../asm-eurolab-project-files/results-database/
cp -f figs-ior-s-mpi-r.pdf ../../../asm-eurolab-project-files/results-figures/
cp -rf ../out-ior-s-mpi-r/ ../../../asm-eurolab-project-files/out-files/

# Cleaning the files

cd ..
rm -rf out-ior-s-mpi
rm -rf out-ior-s-mpi-r
rm run-ior-s-mpi.sh
rm run-ior-s-mpi-r.sh
rm ior

## Running MD ###

echo 'xxxxxxxxxxxxxxxxxx'
echo 'Running md'
echo 'xxxxxxxxxxxxxxxxxx'

cd ../../asm-eurolab-project-files
cp -f bash-scripts/run-md.sh ../libfuse/build/
cp -f benchmarks/md-workbench ../libfuse/build/

cd ../libfuse/build/

# Running the filters with a Bash script

./run-md.sh tmpfs passthrough $2 $3
./run-md.sh fuse passthrough $2 $3
./run-md.sh tmpfs passthrough_ll $2 $3
./run-md.sh fuse passthrough_ll $2 $3
./run-md.sh tmpfs passthrough_fh $2 $3
./run-md.sh fuse passthrough_fh $2 $3
./run-md.sh tmpfs passthrough_hp $2 $3
./run-md.sh fuse passthrough_hp $2 $3

cp -f ../../asm-eurolab-project-files/python-scripts/parse-md.py out-md
cp -f ../../asm-eurolab-project-files/r-scripts/plot-md.R out-md

cd out-md

# Running the Python script to parse the results to a csv file

python3 parse-md.py *.txt

# Running the R script to generate the graphics

./plot-md.R 0

# Saving results and intermediate files

cp -f results-md.csv ../../../asm-eurolab-project-files/results-database
cp -f figs-md.pdf ../../../asm-eurolab-project-files/results-figures
cp -rf ../out-md/ ../../../asm-eurolab-project-files/out-files/

# Cleaning the files

cd ..
rm -rf out-md
rm run-md.sh
rm md-workbench
