#!/usr/bin/env python3
import sys
import re
import csv

# Python Script for Running MD-WORKBENCH

# Command Line: python3 parse-file-md.py *.txt

# # # # All data in MBs

# Create the output filename

filename = "results-md.csv"

# Open the output file

fd = open(filename, "w")
fields = ["file", "bytes", "MB", "MiB", "time", "tp", "filter", "dir_mem", "iter", "blocksize", "transfersize", "isize", "psize", "size", "options", "read_time1", "write_time1", "read_time2", "write_time2", "read_time3", "write_time3", "read_time4", "write_time4", "read_time5", "write_time5", "read_time6", "write_time6", "read_time7", "write_time7", "read_tp", "write_tp", "prefix", "n", "ppn", "config", "timesteps", "sync_t", "nproc", "rate_iops", "rate_objs", "total_time"]
out = csv.DictWriter(fd, fieldnames=fields, delimiter=',', quoting=csv.QUOTE_MINIMAL)
out.writeheader()

# "file"        filename
# "bytes"       number of bytes (information inside the result file)
# "MB"          number of bytes in MB (information inside the result file)
# "MiB"         number of bytes in MiB (information inside the result file)
# "time"        time to process the operation (information inside the result file)
# "tp"          throughput to process the operation (information inside the result file)

# "filter"      chosen filter (information inside the filename)
# "dir_mem"     directory where the memory is allocated (dev/shm/ or /mnt/dev/shm/) (information inside the filename)
# "iter"        iteration for the run with the same parameters (information inside the filename)
# "blocksize"   size of the block (information inside the filename)
# "transfersize"size (in bytes) of a single data buffer to be transferred in a single I/O call
# "size"        size of the file that is being write and read (information inside the filename)
# "operation"   type of operation (read/write) (information inside the filename)

# "options"     extra options for the benchmarks
# "read_time"   not filled on purpose
# "write_time"  not filled on purpose
# "read_tp"     not filled on purpose
# "write_tp"    not filled on purpose
# "sync_t"      ???
# "prefix"      ???
# "n"           ???
# "ppn"         ???
# "config"      ???
# "timesteps"   ???

# "nproc"       number of processors
# "rate_iops"   rate iops/s
# "rate_objs"   rate objs/s

data_M = {}
f_in = 0
f_out = 0

files = sys.argv[1:]
for file in files:
    f_in += 1
#    print(file)
    data_M["file"] = file
    data_M["options"] = 'md'

    # Parse the data for the information inside the filename

    n = re.match("(?P<filter>[a-z\_]*)-(?P<dir_mem>[a-z\_]*)-(?P<iter>[0-9]*)-(?P<isize>[0-9]*)-(?P<psize>[0-9]*)-(?P<nproc>[0-9]*).txt", file)

    if n:
        data_M.update(n.groupdict())

    # Parse the data for the information inside the result file

    f = open(file, "r")
    for l in f:

#benchmark process max:14.44s min:14.4s mean: 14.4s balance:100.0 stddev:-nan rate:27695.4 iops/s objects:100000 rate:6923.9 obj/s tp:51.5 MiB/s op-max:4.9339e-02s (0 errs) read(3.0695e-05s, 4.1175e-05s, 4.6717e-05s, 7.5383e-05s, 1.0939e-04s, 2.4943e-04s, 4.9339e-02s) stat(4.1300e-06s, 6.6200e-06s, 8.0460e-06s, 1.0173e-05s, 1.4507e-05s, 2.9337e-05s, 5.6222e-04s) create(1.4245e-05s, 1.8403e-05s, 2.2669e-05s, 2.7534e-05s, 3.4044e-05s, 7.6474e-05s, 2.5162e-03s) delete(1.3131e-05s, 1.5514e-05s, 1.9098e-05s, 2.3236e-05s, 2.8676e-05s, 6.4129e-05s, 1.2412e-02s)

        m = re.match(".*benchmark process.*rate:(?P<rate_iops>[0-9.]*) iops/s.*rate:(?P<rate_objs>[0-9.]*) obj/s.*op-max:([0-9e.\-+]*)s.*read\((?P<read_time1>[0-9e.\-+]*)s, (?P<read_time2>[0-9e.\-+]*)s, (?P<read_time3>[0-9e.\-+]*)s, (?P<read_time4>[0-9e.\-+]*)s, (?P<read_time5>[0-9e.\-+]*)s, (?P<read_time6>[0-9e.\-+]*)s, (?P<read_time7>[0-9e.\-+]*)s\).*stat\(([0-9e.\-+]*)s.*create\((?P<write_time1>[0-9e.\-+]*)s, (?P<write_time2>[0-9e.\-+]*)s, (?P<write_time3>[0-9e.\-+]*)s, (?P<write_time4>[0-9e.\-+]*)s, (?P<write_time5>[0-9e.\-+]*)s, (?P<write_time6>[0-9e.\-+]*)s, (?P<write_time7>[0-9e.\-+]*)s\).*delete\(([0-9e.\-+]*)s.*", l)

        if m:
            data_M.update(m.groupdict())
            out.writerow(data_M)
            f_out += 1

        m2 = re.match(".*Total runtime: (?P<total_time>[0-9]*)s.*", l)

        if m2:
            data_M.update(m2.groupdict())
            out.writerow(data_M)
            f_out += 1

    f.close()

fd.close()

# print(f_in)
# print(f_out/2)

if f_in != f_out/2:
    print("Some files were not properly processed!")
else:
    print("Parsing completed with success!")
