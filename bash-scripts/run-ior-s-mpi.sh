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
mkdir -p out-ior-s-mpi

function run_file(){
  run=$1
  size=$2
  nproc=$3
  segments=50000/${blocksize}

  file=out-ior-s-mpi/${filter}-${dir}-${run}-${size}-${nproc}.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
   then mpiexec -n ${nproc} ./ior -t ${size} -b ${size} -w -r -s ${segments} -o ${test_dir} > out-ior-s-mpi/${filter}-${dir}-${run}-${size}-${nproc}.txt 2>&1
  fi

}

nproc_vec=(1 2)
size_vec=(2000 5000)

for i in {1..2}; do
  for j in "${size_vec[@]}"; do
    for k in "${nproc_vec[@]}"; do
      run_file $i $j $k
    done
  done
done

fusermount -u mnt
