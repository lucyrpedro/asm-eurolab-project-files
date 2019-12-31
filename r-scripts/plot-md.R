#!/usr/bin/env Rscript

# R Script for Running MD-WORKBENCH

# Options for the output parameters

# time
# tp
# total time

# ########################################################

options(scipen = 999) # disable scientific notation

args = commandArgs(trailingOnly=TRUE)

pdf("figs-md.pdf") # either save all files in one pdf or the files in specific pdfs; find an option to automatise the choice

d = read.csv("results-md.csv")

filter_op       = levels(as.factor(d$filter))
isize_op        = levels(as.factor(d$isize))
psize_op        = levels(as.factor(d$psize))
nproc_op        = levels(as.factor(d$nproc))

legend_vet = numeric(0);

for (i in 1:length(isize_op)){
  for (j in 1:length(psize_op)){
    v = sprintf("isize_%s-psize_%s", isize_op[i], psize_op[j]);
    legend_vet = c(legend_vet, v);
  }
}

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

        if (length(data_rtime) == len_class){

            DF = data.frame(
            x = c(data_rtime),
            y = rep(c(1:1:len_class), each = len),
            z = rep(rep(1, each = len*len_class), 1), # read
            stringsAsFactors = FALSE
            )
    #           str(DF)
    #           print(DF)

            title = sprintf("MD-Workbench Time Read - Filter %s - %s Processors", filter_op[k], nproc_op[l]);

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

        } else {
        print (length(data_rtime))
        print (len_class)
        }

        # TIME - WRITE

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_rtime)/len_class;                # number of run

        if (length(data_wtime) == len_class){

            DF = data.frame(
            x = c(data_wtime),
            y = rep(c(1:1:len_class), each = len),
            z = rep(rep(1, each = len*len_class), 1), # write
            stringsAsFactors = FALSE
            )
    #           str(DF)
    #           print(DF)

            title = sprintf("MD-Workbench Time Write - Filter %s - %s Processors", filter_op[k], nproc_op[l]);

            cols = rainbow(len_class, s = 0.5)
            boxplot(x ~ z + y, data = DF,
                    at = c(1:(len_class)), col = cols,
                    names = c("Write", rep("", len_class-1)),
                    xaxs = FALSE, main=title, ylab="Time Write")
    #        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        } else {
        print (length(data_wtime))
        print (len_class)
        }

        # TOTAL TIME

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_ttime)/len_class;                # number of run

        if (length(data_ttime) == len_class){

            DF = data.frame(
            x = c(data_ttime),
            y = rep(c(1:1:len_class), each = len),
            z = rep(rep(1, each = len*len_class), 1), # write
            stringsAsFactors = FALSE
            )
            #           str(DF)
            #           print(DF)

            title = sprintf("MD-Workbench Total Time - Filter %s - %s Processors", filter_op[k], nproc_op[l]);

            cols = rainbow(len_class, s = 0.5)
            boxplot(x ~ z + y, data = DF,
                    at = c(1:(len_class)), col = cols,
                    names = c("Time", rep("", len_class-1)),
                    xaxs = FALSE, main=title, ylab="Total Time")
            #        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        } else {
        print (length(data_ttime))
        print (len_class)
        }

        # RATE - IOPS

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_rate_iops)/len_class;                # number of run

        if (length(data_rate_iops) == len_class){

            DF = data.frame(
            x = c(data_rate_iops),
            y = rep(c(1:1:len_class), each = len),
            z = rep(rep(1, each = len*len_class), 1), # rate iops
            stringsAsFactors = FALSE
            )
    #           str(DF)
    #           print(DF)

            title = sprintf("MD-Workbench Rate iop/s - Filter %s - %s Processors", filter_op[k], nproc_op[l]);

            cols = rainbow(len_class, s = 0.5)
            boxplot(x ~ z + y, data = DF,
                    at = c(1:(len_class)), col = cols,
                    names = c("Rate iop/s", rep("", len_class-1)),
                    xaxs = FALSE, main=title, ylab="Rate iop/s")
    #        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        } else {
        print (length(data_rate_iops))
        print (len_class)
        }

        # RATE - OBJS

        len_class = length(isize_op)*length(psize_op);     # number of options for the classes
        len = length(data_rate_objs)/len_class;                # number of run

        if (length(data_rate_objs) == len_class){

            DF = data.frame(
            x = c(data_rate_objs),
            y = rep(c(1:1:len_class), each = len),
            z = rep(rep(1, each = len*len_class), 1), # rate objs
            stringsAsFactors = FALSE
            )
    #           str(DF)
    #           print(DF)

            title = sprintf("MD-Workbench Rate obj/s - Filter %s - %s Processors", filter_op[k], nproc_op[l]);

            cols = rainbow(len_class, s = 0.5)
            boxplot(x ~ z + y, data = DF,
                    at = c(1:(len_class)), col = cols,
                    names = c("Rate obj/s", rep("", len_class-1)),
                    xaxs = FALSE, main=title, ylab="Rate obj/s")
    #        legend("center", fill = cols, legend = legend_vet, horiz = F, title="Class")

        } else {
        print (length(data_rate_objs))
        print (len_class)
        }

    }

}

# dev.off()
print("Graphics constructed with success!")
