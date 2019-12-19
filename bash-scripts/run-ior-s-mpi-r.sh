#!/bin/bash

# Bash Script for Running IOR

# Options: Parameter $1

# tmpfs (/dev/shm/)
# fuse (mnt-fuse/dev/shm/)

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
then test_dir=mnt-fuse/dev/shm/testfile
fi

filter=$2

rm -rf /dev/shm/testfile
rm -rf out
rm -rf out-ior-s-mpi-r # This option is inconsistent with the file check during the runs
mkdir -p out-ior-s-mpi-r
mkdir -p mnt-fuse

mount="mnt-fuse"

if grep -qs "$mount" /proc/mounts; then
  echo "The system was not supposed to be mounted! Unmounting and mounting again!"
  fusermount -u mnt-fuse
  ./example/$filter mnt-fuse/
else
  ./example/$filter mnt-fuse/
fi

function run_file(){
  run=$1
  size=$2
  nproc=$3
  filesize=$4

  segments=$(( ${filesize}/((${size}/1024/1024)*${nproc}) ))

  file=out-ior-s-mpi-r/${filter}-${dir}-${run}-${size}-${nproc}.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
   then
     echo mpiexec -n ${nproc} ./ior -t ${size} -b ${size} -w -r -s ${segments} -o ${test_dir} > out-ior-s-mpi-r/${filter}-${dir}-${run}-${size}-${nproc}.txt 2>&1
     mpiexec -n ${nproc} ./ior -t ${size} -b ${size} -w -r -s ${segments} -o ${test_dir} >> out-ior-s-mpi-r/${filter}-${dir}-${run}-${size}-${nproc}.txt 2>&1
  fi

}

# nproc_vec=(1 2)
# size_vec=(2000 5000)

# nproc_vec=(1)
# size_vec=(1048576)

nproc_vec=(1 5 8 12 16)
nproc_vec=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
size_vec=(1048576 2097152 5242880 10485760)

for i in {1..1}; do
  for j in "${size_vec[@]}"; do
    for k in "${nproc_vec[@]}"; do
      run_file $i $j $k 50000
    done
  done
done

if grep -qs "$mount" /proc/mounts; then
  fusermount -u mnt-fuse
fi
