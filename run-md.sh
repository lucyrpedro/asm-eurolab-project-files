#!/bin/bash

# Bash Script for Running MD-WORKBENCH

# Options: Parameter $1

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

#test_dir=/tmp/test
#dir=tmp

rm -rf /dev/shm/testfile
rm -rf out
mkdir -p mnt
./example/passthrough mnt/   # All tests with passthrough

if [ $2 == 'clean' ]
then rm -rf out-md
fi

mkdir -p out-md

function run_file(){
  run=$1
  isize=$2
  psize=$3
  nproc=$4

  file=out-md/${filter}-${dir}-${run}-${nproc}.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
  then mpiexec -n ${nproc} ./md-workbench -R=1 -D=1 -I=${isize} -P=${psize} -- -D ${test_dir} > out-md/${filter}-${dir}-${run}-${isize}-${psize}-${nproc}.txt 2>&1
  fi

}

nproc_vec=(1 2 3 4)
isize_vec=(200 500)
psize_vec=(1000)

for i in {1..3}; do
  for j in "${isize_vec[@]}"; do
    for k in "${psize_vec[@]}"; do
      for l in "${nproc_vec[@]}"; do
      run_file $i $j $k $l
      done
    done
  done
done

fusermount -u mnt
