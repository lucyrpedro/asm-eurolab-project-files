#!/bin/bash

# Bash Script for Running DD

# Options: Parameter $1

# tmpfs (/dev/shm/)
# fuse (mnt/dev/shm/)

# Options: Parameter $2

# passthrough
# passthrough_ll
# passthrough_fh
# passthrough_hp

# lucy@lucy-GS70-2PC-Stealth:~/esiwace/libfuse/build$ ./example/passthrough_hp --help
# Usage: ./example/passthrough_hp --help
#        ./example/passthrough_hp [options] <source> <mountpoint>
# What's source?

# Options: Parameter $3

# Number of executions -- NOT WORKING

# Options: Parameter $4

# Size of the file -- NOT WORKING

# Options: Parameter $5

# Number of processors -- NOT WORKING

###############################################################################

# Insert something to run only when necessary

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
mkdir -p out-dd

function run_file(){
  run=$1
  blocksize=$2
  filesize=$3

  let blocks=$3/$2

  file=out-dd/${filter}-${dir}-${run}-${blocksize}-${filesize}-write.txt
  if [[ ! -e $file ]]  # this option is not good as it sounds; when a parameter is changed, the file is not replaced
  then dd if=/dev/zero of=${test_dir} bs=${blocksize}k count=$blocks > out-dd/${filter}-${dir}-${run}-${blocksize}-${filesize}-write.txt 2>&1
  fi
  file=out-dd/${filter}-${dir}-${run}-${blocksize}-${filesize}-read.txt
  if [[ ! -e $file ]]
  then dd of=/dev/null if=${test_dir} bs=${blocksize}k count=$blocks > out-dd/${filter}-${dir}-${run}-${blocksize}-${filesize}-read.txt 2>&1
  fi
}

blocksize_vec=(4 16 100 128 1000)
filesize_vec=(30000)

for i in {1..3}; do      # 10
  for j in "${blocksize_vec[@]}"; do     # 7
    for k in "${filesize_vec[@]}"; do   # 2
      run_file $i $j $k
    done
  done
done

fusermount -u mnt
