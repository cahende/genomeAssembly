#set library path location and load packages
.libPaths()
load.packages(dplyt)

#read in tables containing blast results
forward <- read.table(snakemake@input[[1]], 
                              col.names = c("qseqid", "sseqid", "pident", "qcovs", "qlen", "slen", "length", "bitscore", "evalue"))

reverse <- read.table(snakemake@input[[2]], 
                              col.names = c("qseqid", "sseqid", "pident", "qcovs", "qlen", "slen", "length", "bitscore", "evalue"))

#filter results based on percent identity, percent query coverage, and e value
forwardFilter <- filter(forward, forward$pident >= 80, forward$qcovs >= 80, forward$evalue <= .00001)

reverseFilter <- filter(reverse, reverse$pident >= 80, reverse$qcovs >= 80, reverse$evalue <= .00001)

#remove duplicate hits
forwardDup <- forwardFilter$qseqid[duplicated(forwardFilter$qseqid)]
forwardDup <- unique(forwardFilter)
forwardFilterNoDup <- forwardFilter[ ! forwardFilter$qseqid %in% forwardDup, ]

reverseDup <- reverseFilter$qseqid[duplicated(reverseFilter$qseqid)]
reverseDup <- unique(reverseFilter)
reverseFilterNoDup <- reverseFilter[ ! reverseFilter$qseqid %in% reverseDup, ]

#write and run function to compare two dataframes
compareDataframesFun <- function(forwardDF, reverseDF) {
  newDF <- data.frame()
  for (x in 1:nrow(forwardDF)) {
    for (y in 1:nrow(reverseDF)) {
      if (forwardDF$qseqid[x] == reverseDF$sseqid[y] && forwardDF$sseqid[x] == reverseDF$qseqid[y]) {
        newDF <- rbind(newDF, forwardDF[1,])
      }
    }
  }
  newDF <- data.frame(query, known)
  return(newDF) 
}

combinedOutput <- compareDataFramesFun(forwardFilterNoDup, reverseFilterNoDup)

#write combined output to file
write.table(combinedOutput, file=snakemake@output, quote=FALSE, sep="\t", row.names=TRUE, col.names=TRUE)

