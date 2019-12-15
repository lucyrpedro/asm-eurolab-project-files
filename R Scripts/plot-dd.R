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

# filter_op = 'passthrough'
#filter_op   = c("passthrough", "passthrough_fh", "passthrough_hp", "passthrough_ll")
filter_op   = c("passthrough") #, "passthrough_ll", "passthrough_fh")

for (k in 1:length(filter_op)){

    d_filter    = subset(d,   filter == filter_op[k])

    # print(d_filter)

    read_ds     = subset(d_filter, operation == 'read'  & dir_mem == 'ds')
    read_mds    = subset(d_filter, operation == 'read'  & dir_mem == 'mds')
    write_ds    = subset(d_filter, operation == 'write' & dir_mem == 'ds')
    write_mds   = subset(d_filter, operation == 'write' & dir_mem == 'mds')

    for (j in 1:length(size_op)){

        x_sbrd_time      = numeric(0)
        x_sbrmd_time     = numeric(0)
        x_sbwd_time      = numeric(0)
        x_sbwmd_time     = numeric(0)

        x_sbrd_tp      = numeric(0)
        x_sbrmd_tp     = numeric(0)
        x_sbwd_tp      = numeric(0)
        x_sbwmd_tp     = numeric(0)

        for (i in 1:length(blocksize_op)){

            x_sbrd     = subset(read_ds,   size == size_op[j] & blocksize == blocksize_op[i])
            x_sbrmd    = subset(read_mds,  size == size_op[j] & blocksize == blocksize_op[i])
            x_sbwd     = subset(write_ds,  size == size_op[j] & blocksize == blocksize_op[i])
            x_sbwmd    = subset(write_mds, size == size_op[j] & blocksize == blocksize_op[i])

        # print(x_sbrd)

            x_sbrd_time      = c(x_sbrd_time, x_sbrd$time)
            x_sbrmd_time     = c(x_sbrmd_time, x_sbrmd$time)
            x_sbwd_time      = c(x_sbwd_time, x_sbwd$time)
            x_sbwmd_time     = c(x_sbwmd_time, x_sbwmd$time)

            x_sbrd_tp      = c(x_sbrd_tp, x_sbrd$tp)
            x_sbrmd_tp     = c(x_sbrmd_tp, x_sbrmd$tp)
            x_sbwd_tp      = c(x_sbwd_tp, x_sbwd$tp)
            x_sbwmd_tp     = c(x_sbwmd_tp, x_sbwmd$tp)

        # print(x_sbrd_all)

        }

        # print(x_sbrd_all)

        # Plotting the results

        len_bs = length(blocksize_op)       # number of options for the blocksize
        len = length(x_sbrd_time)/len_bs;   # number of run
        n_files = len_bs;                   # number of plots of each type

#        print(len)

        # #### TIME READ

        DF = data.frame(
        x = c(x_sbrd_time, x_sbrmd_time),
        y = rep(c("READ TMP", "READ"), each = n_files*len),
        z = rep(rep(1:n_files, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
    #   str(DF)
    #   print(DF)

        filename = sprintf("%s_%d_time_%s.pdf", filter_op[k], size_op[j], "read");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(n_files, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
        #        names = c(1:6),
        #        names = c("READ", rep("", len_bs-1),"READ TMP",rep("",len_bs-1)),
                names = c("Read", "T", "M", "P", rep("", len_bs-4),"Read", rep("",len_bs-1)),
                xaxs = FALSE, main=title, ylab="Time")
        legend("topright", fill = cols, legend = blocksize_op, horiz = F, title="Blocksize")

        # #### TIME WRITE

        DF = data.frame(
        x = c(x_sbwd_time, x_sbwmd_time),
        y = rep(c("READ TMP", "READ"), each = n_files*len),
        z = rep(rep(1:n_files, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
    #    str(DF)
    #    print(DF)

        filename = sprintf("%s_%d_time_%s.pdf", filter_op[k], size_op[j], "write");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(n_files, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
        #        names = c(1:6),
        #        names = c("READ", rep("", len_bs-1),"READ TMP",rep("",len_bs-1)),
                names = c("Write", "T", "M", "P", rep("", len_bs-4),"Write", rep("",len_bs-1)),
                xaxs = FALSE, main=title, ylab="Time")
        legend("topright", fill = cols, legend = blocksize_op, horiz = F, title="Blocksize")

        # #### TP READ

        DF = data.frame(
        x = c(x_sbrd_tp, x_sbrmd_tp),
        y = rep(c("READ TMP", "READ"), each = n_files*len),
        z = rep(rep(1:n_files, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
    #    str(DF)
    #    print(DF)

        filename = sprintf("%s_%d_tp_%s.pdf", filter_op[k], size_op[j], "read");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(n_files, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
        #        names = c(1:6),
        #        names = c("READ", rep("", len_bs-1),"READ TMP",rep("",len_bs-1)),
                names = c("Read", "T", "M", "P", rep("", len_bs-4),"Read", rep("",len_bs-1)),
                xaxs = FALSE, main=title, ylab="Throughput")
        legend("topleft", fill = cols, legend = blocksize_op, horiz = F, title="Blocksize")

        # #### TP WRITE

        DF = data.frame(
        x = c(x_sbwd_tp, x_sbwmd_tp),
        y = rep(c("READ TMP", "READ"), each = n_files*len),
        z = rep(rep(1:n_files, each=len), 2), # two categories, read and write
        stringsAsFactors = FALSE
        )
    #    str(DF)
    #    print(DF)

        filename = sprintf("%s_%d_tp_%s.pdf", filter_op[k], size_op[j], "write");
        title = sprintf("Filter %s - Size %d", filter_op[k], size_op[j]);

#        pdf(filename)
        cols = rainbow(n_files, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(2*len_bs)), col = cols,
        #        names = c(1:6),
        #        names = c("READ", rep("", len_bs-1),"READ TMP",rep("",len_bs-1)),
                names = c("Write", "T", "M", "P", rep("", len_bs-4),"Write", rep("",len_bs-1)),
                xaxs = FALSE, main=title, ylab="Throughput")
        legend("topleft", fill = cols, legend = blocksize_op, horiz = F, title="Blocksize")

    }

}

# dev.off()
print("Graphics constructed with success!")
