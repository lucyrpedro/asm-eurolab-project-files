#!/usr/bin/env Rscript

# R Script for Running IOR

# Options for the input parameters

# filter_op             only passthrough for now (passthrough_fh passthrough_hp passthrough_ll)
# nproc_vec         (1000000 2000000 5000000 10000000)
# size_vec      (200000 500000 1000000)
# nproc_vec         (1048576 2097152 5242880 10485760)
# size_vec      (262144 524288 1048576)

# Options for the output parameters

# time
# throughput

# ########################################################

pdf("figs-ior.pdf") # either save all files in one pdf or the files in specific pdfs; find an option to automatise the choice

d = read.csv("results-ior.csv")

nproc_op = c(1, 2)
size_op = c(2000, 5000)

filter_op   = c("passthrough", "passthrough_ll", "passthrough_fh")

for (k in 1:length(filter_op)){

    d_filter    = subset(d,   filter == filter_op[k])

    # print(d_filter)

    read_tmpfs      = subset(d_filter, operation == 'read'  & dir_mem == 'tmpfs')
    read_fuse       = subset(d_filter, operation == 'read'  & dir_mem == 'fuse')
    write_tmpfs     = subset(d_filter, operation == 'write' & dir_mem == 'tmpfs')
    write_fuse      = subset(d_filter, operation == 'write' & dir_mem == 'fuse')

    for (j in 1:length(size_op)){

        read_tmpfs_time    = numeric(0)
        read_fuse_time     = numeric(0)
        write_tmpfs_time   = numeric(0)
        write_fuse_time    = numeric(0)

        read_tmpfs_tp    = numeric(0)
        read_fuse_tp     = numeric(0)
        write_tmpfs_tp   = numeric(0)
        write_fuse_tp    = numeric(0)

        for (i in 1:length(nproc_op)){

            x_read_tmpfs      = subset(read_tmpfs,   size == size_op[j] & nproc == nproc_op[i])
            x_read_fuse       = subset(read_fuse,    size == size_op[j] & nproc == nproc_op[i])
            x_write_tmpfs     = subset(write_tmpfs,  size == size_op[j] & nproc == nproc_op[i])
            x_write_fuse      = subset(write_fuse,   size == size_op[j] & nproc == nproc_op[i])

            read_tmpfs_time       = c(read_tmpfs_time, x_read_tmpfs$time)
            read_fuse_time        = c(read_fuse_time, x_read_fuse$time)
            write_tmpfs_time      = c(write_tmpfs_time, x_write_tmpfs$time)
            write_fuse_time       = c(write_fuse_time, x_write_fuse$time)

            read_tmpfs_tp         = c(read_tmpfs_tp, x_read_tmpfs$tp)
            read_fuse_tp          = c(read_fuse_tp, x_read_fuse$tp)
            write_tmpfs_tp        = c(write_tmpfs_tp, x_write_tmpfs$tp)
            write_fuse_tp         = c(write_fuse_tp, x_write_fuse$tp)

        }

        # Plotting the results

        len_bs = length(nproc_op)       # number of options for the nproc
        len = length(read_tmpfs_time)/len_bs;   # number of run

        # #### TIME READ

        DF = data.frame(
        x = c(read_tmpfs_time, read_fuse_time),
        y = rep(c("READ TMPFS", "READ FUSE"), each = len_bs*len),
        z = rep(rep(1:len_bs, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
#        str(DF)
#        print(DF)

        filename = sprintf("%s_%d_time_%s.pdf", filter_op[k], size_op[j], "read");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(len_bs, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
                names = c("Read", "TMPFS", rep("", len_bs-2), "Read", "FUSE", rep("",len_bs-2)),
                xaxs = FALSE, main=title, ylab="Time")
        legend("topright", fill = cols, legend = nproc_op, horiz = F, title="nproc")

        # #### TIME WRITE

        DF = data.frame(
        x = c(write_tmpfs_time, write_fuse_time),
        y = rep(c("WRITE TMPFS", "WRITE FUSE"), each = len_bs*len),
        z = rep(rep(1:len_bs, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
    #    str(DF)
    #    print(DF)

        filename = sprintf("%s_%d_time_%s.pdf", filter_op[k], size_op[j], "write");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(len_bs, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
                names = c("Write", "TMPFS", rep("", len_bs-2), "Write", "FUSE", rep("",len_bs-2)),
                xaxs = FALSE, main=title, ylab="Time")
        legend("topright", fill = cols, legend = nproc_op, horiz = F, title="nproc")

        # #### TP READ

        DF = data.frame(
        x = c(read_tmpfs_tp, read_fuse_tp),
        y = rep(c("READ TMPFS", "READ FUSE"), each = len_bs*len),
        z = rep(rep(1:len_bs, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
    #    str(DF)
    #    print(DF)

        filename = sprintf("%s_%d_tp_%s.pdf", filter_op[k], size_op[j], "read");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(len_bs, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
                names = c("Read", "TMPFS", rep("", len_bs-2), "Read", "FUSE", rep("",len_bs-2)),
                xaxs = FALSE, main=title, ylab="Throughput")
        legend("topleft", fill = cols, legend = nproc_op, horiz = F, title="nproc")

        # #### TIME WRITE

        DF = data.frame(
        x = c(write_tmpfs_tp, write_fuse_tp),
        y = rep(c("WRITE TMPFS", "WRITE FUSE"), each = len_bs*len),
        z = rep(rep(1:len_bs, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
    #    str(DF)
    #    print(DF)

        filename = sprintf("%s_%d_tp_%s.pdf", filter_op[k], size_op[j], "write");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(len_bs, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
                names = c("Write", "TMPFS", rep("", len_bs-2), "Write", "FUSE", rep("",len_bs-2)),
                xaxs = FALSE, main=title, ylab="Throughput")
        legend("topleft", fill = cols, legend = nproc_op, horiz = F, title="nproc")

    }

}

# dev.off()
print("Graphics constructed with success!")