#!/usr/bin/env Rscript

# R Script for Running MD-WORKBENCH

# Options for the input parameters

# filter_op             only passthrough for now (passthrough_fh passthrough_hp passthrough_ll)
# isize_vec             (200 500 1000)
# psize_vec             (1000 3000 5000 10000)
# nproc                 (1 2 3 4 5 6 7 8 9 10)

# Options for the output parameters

# time

# ########################################################

pdf("figs-md.pdf") # either save all files in one pdf or the files in specific pdfs; find an option to automatise the choice

d = read.csv("results-md.csv")

# isize_op = c(200, 500)
# psize_op = c(1000)
# nproc_op = c(1, 2)

nproc_op = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
isize_op = c(200000, 500000, 1000000)
psize_op = c(1000000, 3000000, 5000000, 10000000)

legend_vet = numeric(0);

for (i in 1:length(isize_op)){
  for (j in 1:length(psize_op)){
    v = sprintf("isize_%d-psize_%d", isize_op[i], psize_op[j]);
    legend_vet = c(legend_vet, v);
  }
}

filter_op   = c("passthrough", "passthrough_ll", "passthrough_fh")

for (k in 1:length(filter_op)){

    data    = subset(d,   filter == filter_op[k])

    # print(d_filter)

    for (l in 1:length(nproc_op)){

        datap     = subset(data,   nproc == nproc_op[l])

        data_rtime        = numeric(0)
        data_wtime        = numeric(0)
        data_ttime        = numeric(0)
        data_rate_iops    = numeric(0)
        data_rate_objs    = numeric(0)

        for (j in 1:length(isize_op)){

            for (i in 1:length(psize_op)){

                dataip     = subset(datap,   isize == isize_op[j] & psize == psize_op[i])

                data_rtime          = c(data_rtime, dataip$read_time1)
                data_wtime          = c(data_wtime, dataip$write_time1)
                data_ttime          = c(data_ttime, dataip$total_time)
                data_rate_iops      = c(data_rate_iops, dataip$rate_iops)
                data_rate_objs      = c(data_rate_objs, dataip$rate_objs)

            }

        }

#        print(data_rtime)
#        print(length(data_rtime))

        # Plotting the results

        # TIME - READ

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_rtime)/len_class;                # number of run

        DF = data.frame(
        x = c(data_rtime),
        y = rep(c(1:1:len_class), each = len),
        z = rep(rep(1, each = len*len_class), 1), # read
        stringsAsFactors = FALSE
        )
#           str(DF)
#           print(DF)

        title = sprintf("MD-Workbench Time Read - Filter %s - %d Processors", filter_op[k], nproc_op[l]);

        cols = rainbow(len_class, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(len_class)), col = cols,
                names = c("Read", rep("", len_class-1)),
                xaxs = FALSE, main=title, ylab="Time Read")
#        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        if (nproc_op[l] == 1){

            plot.new();
            legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        }

        # TIME - WRITE

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_rtime)/len_class;                # number of run

        DF = data.frame(
        x = c(data_wtime),
        y = rep(c(1:1:len_class), each = len),
        z = rep(rep(1, each = len*len_class), 1), # write
        stringsAsFactors = FALSE
        )
#           str(DF)
#           print(DF)

        title = sprintf("MD-Workbench Time Write - Filter %s - %d Processors", filter_op[k], nproc_op[l]);

        cols = rainbow(len_class, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(len_class)), col = cols,
                names = c("Write", rep("", len_class-1)),
                xaxs = FALSE, main=title, ylab="Time Write")
#        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        # TOTAL TIME

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_ttime)/len_class;                # number of run

        DF = data.frame(
        x = c(data_ttime),
        y = rep(c(1:1:len_class), each = len),
        z = rep(rep(1, each = len*len_class), 1), # write
        stringsAsFactors = FALSE
        )
        #           str(DF)
        #           print(DF)

        title = sprintf("MD-Workbench Total Time - Filter %s - %d Processors", filter_op[k], nproc_op[l]);

        cols = rainbow(len_class, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(len_class)), col = cols,
                names = c("Time", rep("", len_class-1)),
                xaxs = FALSE, main=title, ylab="Total Time")
        #        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        # RATE - IOPS

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_rate_iops)/len_class;                # number of run

        DF = data.frame(
        x = c(data_rate_iops),
        y = rep(c(1:1:len_class), each = len),
        z = rep(rep(1, each = len*len_class), 1), # rate iops
        stringsAsFactors = FALSE
        )
#           str(DF)
#           print(DF)

        title = sprintf("MD-Workbench Rate iop/s - Filter %s - %d Processors", filter_op[k], nproc_op[l]);

        cols = rainbow(len_class, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(len_class)), col = cols,
                names = c("Rate iop/s", rep("", len_class-1)),
                xaxs = FALSE, main=title, ylab="Rate iop/s")
#        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        # RATE - OBJS

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_rate_objs)/len_class;                # number of run

        DF = data.frame(
        x = c(data_rate_objs),
        y = rep(c(1:1:len_class), each = len),
        z = rep(rep(1, each = len*len_class), 1), # rate objs
        stringsAsFactors = FALSE
        )
#           str(DF)
#           print(DF)

        title = sprintf("MD-Workbench Rate obj/s - Filter %s - %d Processors", filter_op[k], nproc_op[l]);

        cols = rainbow(len_class, s = 0.5)
        boxplot(x ~ z + y, data = DF,
                at = c(1:(len_class)), col = cols,
                names = c("Rate obj/s", rep("", len_class-1)),
                xaxs = FALSE, main=title, ylab="Rate obj/s")
#        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

    }

}

# dev.off()
print("Graphics constructed with success!")
