# make sure library ggplot2 is loaded
#  install.packages("ggplot2")
#  library(ggplot2)
# this script assumes the existence of file named 'FisherToRchart.txt'
# in the R working directory.  The file is tab delimted and includes
# columnd named 'FindingID' 'CSet' 'Int' 'Comp' 'Tissue' 'Lesion' 'F_Greater'
# also colunms for finding counts, F_Less, etc.  
# probably want to clear workspace before running script
# rm(list = ls())

# get data
FisherToRchart <- read.delim("FisherToRchart.txt")

# set group table for building intervals
grp_table<-table(FisherToRchart$Int)

# get names for building intervals
grp_levels<-names(grp_table)[order(grp_table)]

# set levels order
FisherToRchart$Interval<-factor(FisherToRchart$Int, levels = c("21 day", "42 day", "84 day", "126 day"))

# now the data is set.  need to split and evaluate
#  (1) subset all 'over time' data
#  (1a) create graph for each lesion
#  (1b) I will need to check how Tissue works out as
#       some lesions have 3 tissues (bone) and some have 1 (LN)
UQlesion<-unique(FisherToRchart$Lesion)
UQcomp<-unique(FisherToRchart$Comp)
for (h in 1:length(UQcomp)){
  for (i in 1:length(UQlesion)){
    FisherSub <- FisherToRchart[FisherToRchart$Lesion == UQlesion[i] & FisherToRchart$Comp == UQcomp[h],]
    # pplot<-ggplot(data=FisherSub,aes(Interval, FISHER, fill=factor(Tissue)))+geom_bar(stat="identity",position="dodge")+ geom_hline(aes(yintercept=0.05))+ggtitle(FisherSub[1,5])
    pplot<-ggplot(data=FisherSub,aes(Interval, FISHER, fill=factor(Tissue)))+geom_bar(stat="identity",position="dodge")+ geom_hline(aes(yintercept=0.05))+ggtitle(FisherSub[1,5])+labs(x = FisherSub[1,3],y="FISHER EXACT RESULTS (ONE-SIDED)")
    fname <-gsub("/", "-", FisherSub[1,5])
    ggsave(pplot,filename=paste(FisherSub[1,3], "--", fname, ".jpg",sep=""))
  }
}

#