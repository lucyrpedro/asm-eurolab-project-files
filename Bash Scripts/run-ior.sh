#!/bin/bash

# Bash Script for Running IOR

# Options: Parameter $1

# ds (/dev/shm/)
# mds (mnt/dev/shm/)

# Options: Parameter $2

# clean   remove all the tests inside directory out
# none    preserve the files and run only the ones that were not run before

###############################################################################

spack load -r openmpi
spack load gcc

filter='passthrough'

dir=$1

if [ $dir == 'tmpfs' ]
then test_dir=/dev/shm/testfile
fi

if [ $dir == 'fuse' ]
then test_dir=mnt/dev/shm/testfile
fi

rm -rf /dev/shm/testfile
rm -rf out
mkdir -p mnt
./example/passthrough mnt/   # All tests with passthrough

if [ $2 == 'clean' ]
then rm -rf out-ior
fi

mkdir -p out-ior

function run_file(){
  run=$1
  blocksize=$2
  transfersize=$3
#  segments=50000/${blocksize}

  file=out-ior/${filter}-${dir}-${run}-${blocksize}-${transfersize}.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
#  then ./ior -t ${transfersize} -b ${blocksize} -w -r -o ${test_dir} -s ${segments} > out-ior/${filter}-${dir}-${run}-${blocksize}-${transfersize}.txt 2>&1
  then ./ior -t ${transfersize} -b ${blocksize} -w -r -o ${test_dir} > out-ior/${filter}-${dir}-${run}-${blocksize}-${transfersize}.txt 2>&1
  fi

}

blocksize_vec=(1048576 2097152)
transfersize_vec=(262144 524288)

for i in {1..2}; do
  for j in "${blocksize_vec[@]}"; do
    for k in "${transfersize_vec[@]}"; do
      run_file $i $j $k
    done
  done
done

fusermount -u mnt
