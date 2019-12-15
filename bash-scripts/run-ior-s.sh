#!/bin/bash

# Bash Script for Running IOR

# Options: Parameter $1

# tmpfs (/dev/shm/)
# fuse (mnt/dev/shm/)

# Options: Parameter $2

# passthrough
# passthrough_ll
# passthrough_fh
# passthrough_hp

###############################################################################

spack load -r openmpi
spack load gcc

dir=$1

if [ $dir == 'tmpfs' ]
then test_dir=/dev/shm/testfile
fi

if [ $dir == 'fuse' ]
then test_dir=mnt/dev/shm/testfile
fi

filter=$2

rm -rf /dev/shm/testfile
rm -rf out
mkdir -p mnt
./example/$filter mnt/
mkdir -p out-ior-s

function run_file(){
  run=$1
  blocksize=$2
  transfersize=$3
  segments=50000/${blocksize}

  file=out-ior-s/${filter}-${dir}-${run}-${blocksize}-${transfersize}.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
   then ./ior -t ${transfersize} -b ${blocksize} -w -r -s ${segments} -o ${test_dir} > out-ior-s/${filter}-${dir}-${run}-${blocksize}-${transfersize}.txt 2>&1
  fi

}

size_vec=(2000 5000)

for i in {1..2}; do
  for j in "${size_vec[@]}"; do
      run_file $i $j $j
  done
done

fusermount -u mnt
