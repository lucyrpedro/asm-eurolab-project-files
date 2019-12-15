#!/usr/bin/env Rscript

# Options for the input parameters

# filter_op     passthrough passthrough_fh passthrough_hp passthrough_ll
# blocksize_op  100 128 1000 1024 8192 10000
# size_op       10000 100000 1000000

# Options for the output parameters

# time
# throughput

# ########################################################

pdf("figs-dd.pdf") # either save all files in one pdf or the files in specific pdfs; find an option to automatise the choice

d = read.csv("results-dd.csv")

blocksize_op = c(4, 16, 100, 128, 1000);
size_op = c(30000);

filter_op   = c("passthrough", "passthrough_ll", "passthrough_fh")

for (k in 1:length(filter_op)){

    d_filter    = subset(d,   filter == filter_op[k])

    # print(d_filter)

    read_tmpfs_time     = subset(d_filter, operation == 'read'  & dir_mem == 'tmpfs')
    read_fuse_time      = subset(d_filter, operation == 'read'  & dir_mem == 'fuse')
    write_tmpfs_time    = subset(d_filter, operation == 'write' & dir_mem == 'tmpfs')
    write_fuse_time     = subset(d_filter, operation == 'write' & dir_mem == 'fuse')

    for (j in 1:length(size_op)){

        x_read_tmpfs_time     = numeric(0)
        x_read_fuse_time      = numeric(0)
        x_write_tmpfs_time    = numeric(0)
        x_write_fuse_time     = numeric(0)

        x_read_tmpfs_tp       = numeric(0)
        x_read_fuse_tp        = numeric(0)
        x_write_tmpfs_tp      = numeric(0)
        x_write_fuse_tp       = numeric(0)

        for (i in 1:length(blocksize_op)){

            x_read_tmpfs      = subset(read_tmpfs_time,    size == size_op[j] & blocksize == blocksize_op[i])
            x_read_fuse       = subset(read_fuse_time,     size == size_op[j] & blocksize == blocksize_op[i])
            x_write_tmpfs     = subset(write_tmpfs_time,   size == size_op[j] & blocksize == blocksize_op[i])
            x_write_fuse      = subset(write_fuse_time,    size == size_op[j] & blocksize == blocksize_op[i])

            x_read_tmpfs_time       = c(x_read_tmpfs_time, x_read_tmpfs$time)
            x_read_fuse_time        = c(x_read_fuse_time, x_read_fuse$time)
            x_write_tmpfs_time      = c(x_write_tmpfs_time, x_write_tmpfs$time)
            x_write_fuse_time       = c(x_write_fuse_time, x_write_fuse$time)

            x_read_tmpfs_tp       = c(x_read_tmpfs_tp, x_read_tmpfs$tp)
            x_read_fuse_tp        = c(x_read_fuse_tp, x_read_fuse$tp)
            x_write_tmpfs_tp      = c(x_write_tmpfs_tp, x_write_tmpfs$tp)
            x_write_fuse_tp       = c(x_write_fuse_tp, x_write_fuse$tp)

        }

        # Plotting the results

        len_bs = length(blocksize_op)               # number of options for the blocksize
        len = length(x_read_tmpfs_time)/len_bs;     # number of run

        # #### TIME READ

        DF = data.frame(
        x = c(x_read_tmpfs_time, x_read_fuse_time),
        y = rep(c("READ TMP", "READ"), each = len_bs*len),
        z = rep(rep(1:len_bs, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
    #   str(DF)
    #   print(DF)

        filename = sprintf("%s_%d_time_%s.pdf", filter_op[k], size_op[j], "read");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(len_bs, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
                names = c("Read", "T", "M", "P", rep("", len_bs-4),"Read", rep("",len_bs-1)),
                xaxs = FALSE, main=title, ylab="Time")
        legend("topright", fill = cols, legend = blocksize_op, horiz = F, title="Blocksize")

        # #### TIME WRITE

        DF = data.frame(
        x = c(x_write_tmpfs_time, x_write_fuse_time),
        y = rep(c("READ TMP", "READ"), each = len_bs*len),
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
                names = c("Write", "T", "M", "P", rep("", len_bs-4),"Write", rep("",len_bs-1)),
                xaxs = FALSE, main=title, ylab="Time")
        legend("topright", fill = cols, legend = blocksize_op, horiz = F, title="Blocksize")

        # #### TP READ

        DF = data.frame(
        x = c(x_read_tmpfs_tp, x_read_fuse_tp),
        y = rep(c("READ TMP", "READ"), each = len_bs*len),
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
                names = c("Read", "T", "M", "P", rep("", len_bs-4),"Read", rep("",len_bs-1)),
                xaxs = FALSE, main=title, ylab="Throughput")
        legend("topleft", fill = cols, legend = blocksize_op, horiz = F, title="Blocksize")

        # #### TP WRITE

        DF = data.frame(
        x = c(x_write_tmpfs_tp, x_write_fuse_tp),
        y = rep(c("READ TMP", "READ"), each = len_bs*len),
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
                names = c("Write", "T", "M", "P", rep("", len_bs-4),"Write", rep("",len_bs-1)),
                xaxs = FALSE, main=title, ylab="Throughput")
        legend("topleft", fill = cols, legend = blocksize_op, horiz = F, title="Blocksize")

    }

}

# dev.off()
print("Graphics constructed with success!")
