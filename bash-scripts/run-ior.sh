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
mkdir -p out-ior

function run_file(){
  run=$1
  blocksize=$2
  transfersize=$3

  file=out-ior/${filter}-${dir}-${run}-${blocksize}-${transfersize}.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
  then ./ior -t ${transfersize} -b ${blocksize} -w -r -o ${test_dir} > out-ior/${filter}-${dir}-${run}-${blocksize}-${transfersize}.txt 2>&1
  fi

}

# blocksize_vec=(1048576 2097152)
# transfersize_vec=(262144 524288)

blocksize_vec=(1048576 2097152 5242880 10485760)
transfersize_vec=(262144 524288 1048576)

for i in {1..10}; do
  for j in "${blocksize_vec[@]}"; do
    for k in "${transfersize_vec[@]}"; do
      run_file $i $j $k
    done
  done
done

fusermount -u mnt
