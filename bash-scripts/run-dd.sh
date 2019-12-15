#!/bin/bash

# Bash Script for Running DD

# Options: Parameter $1

# passthrough
# passthrough_ll
# passthrough_fh
# passthrough_hp

# lucy@lucy-GS70-2PC-Stealth:~/esiwace/libfuse/build$ ./example/passthrough_hp --help
# Usage: ./example/passthrough_hp --help
#        ./example/passthrough_hp [options] <source> <mountpoint>
# What's source?

# Options: Parameter $2

# tmpfs (/dev/shm/)
# fuse (mnt/dev/shm/)

# Options: Parameter $3

# clean   remove all the tests inside directory out
# none    preserve the files and run only the ones that were not run before

# Options: Parameter $4

# Number of executions -- NOT WORKING

# Options: Parameter $5

# Size of the file -- NOT WORKING

# Options: Parameter $6

# Number of executions -- NOT WORKING

###############################################################################

spack load -r openmpi
spack load gcc

filter=$1
dir=$2

if [ $dir == 'tmpfs' ]
then test_dir=/dev/shm/testfile
fi

if [ $dir == 'fuse' ]
then test_dir=mnt/dev/shm/testfile
fi

rm -rf /dev/shm/testfile
rm -rf out
mkdir -p mnt
./example/$filter mnt/

if [ $3 == 'clean' ]
then rm -rf out-dd
fi

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
