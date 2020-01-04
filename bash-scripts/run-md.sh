#!/bin/bash

# Bash Script for Running MD-WORKBENCH

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
filter=$2

if [ $dir == 'tmpfs' ]
then test_dir=/dev/shm/testfile
fi

if [ $dir == 'fuse' ]; then
  if [ $filter == 'passthrough_hp' ]; then
    test_dir=mnt-fuse/testfile
  else test_dir=mnt-fuse/dev/shm/testfile
  fi
fi

rm -rf /dev/shm/testfile
rm -rf out
mkdir -p out-md
mkdir -p mnt-fuse

mount="mnt-fuse"

if grep -qs "$mount" /proc/mounts; then
  echo "The system was not supposed to be mounted! Unmounting and mounting again!"
  fusermount -u mnt-fuse
  if [ $filter == 'passthrough_hp' ]; then
    ./example/$filter /dev/shm mnt-fuse/ &
  else ./example/$filter mnt-fuse/
  fi
else
  if [ $filter == 'passthrough_hp' ]; then
    ./example/$filter /dev/shm mnt-fuse/ &
  else ./example/$filter mnt-fuse/
  fi
fi

if [ $3 == 'test' ]
then
  nproc_vec=(1 2)
  isize_vec=(200 500)
  psize_vec=(1000)
  conv=(1)
else
  nproc_vec=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
  # isize_vec=(200000 500000 1000000)
  # psize_vec=(1000000 3000000 5000000 10000000)
  # isize_vec=(20000 50000 100000)
  # psize_vec=(100000 300000 500000 1000000)
  isize_vec=(2000 5000 10000)
  psize_vec=(10000 30000 50000 100000)
fi

function run_file(){
  run=$1
  isize=$2
  psize=$3
  nproc=$4

  isizeproc=$(($2/$4))
  psizeproc=$(($3/$4))

  file=out-md/${filter}-${dir}-${run}-${isize}-${psize}-${nproc}.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
  then
    echo mpiexec -n ${nproc} ./md-workbench -R=1 -D=1 -I=${isizeproc} -P=${psizeproc} -- -D ${test_dir} > out-md/${filter}-${dir}-${run}-${isize}-${psize}-${nproc}.txt 2>&1
    mpiexec -n ${nproc} ./md-workbench -R=1 -D=1 -I=${isizeproc} -P=${psizeproc} -- -D ${test_dir} >> out-md/${filter}-${dir}-${run}-${isize}-${psize}-${nproc}.txt 2>&1
  fi

}

for i in {1..1}; do
  for j in "${isize_vec[@]}"; do
    for k in "${psize_vec[@]}"; do
      for l in "${nproc_vec[@]}"; do
        run_file $i $j $k $l
        rm -rf /dev/shm/testfile
      done
    done
  done
done

if grep -qs "$mount" /proc/mounts
then
  fusermount -u mnt-fuse
else
  echo "The system was supposed to be mounted!"
fi
