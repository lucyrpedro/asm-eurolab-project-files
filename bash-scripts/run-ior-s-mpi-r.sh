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
fusermount -u mnt || /bin/true
./example/$filter mnt/
echo 'CREATING DIR'
ls
mkdir -p out-ior-s-mpi-r

function run_file(){
  run=$1
  size=$2
  nproc=$3
  filesize=$4

  div=$((1024*1024*${size}*${nproc}))
  segments=$((${filesize}/${div}))

  file=out-ior-s-mpi-r/${filter}-${dir}-${run}-${size}-${nproc}.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
   then mpiexec -n ${nproc} ./ior -t ${size} -b ${size} -w -r -z -s ${segments} -o ${test_dir} > out-ior-s-mpi-r/${filter}-${dir}-${run}-${size}-${nproc}.txt 2>&1
  fi

}

nproc_vec=(1 2)
size_vec=(2000 5000)

# nproc_vec=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
# size_vec=(1048576 2097152 5242880 10485760)

for i in {1..2}; do
  for j in "${size_vec[@]}"; do
    for k in "${nproc_vec[@]}"; do
      run_file $i $j $k 50000
    done
  done
done

fusermount -u mnt
