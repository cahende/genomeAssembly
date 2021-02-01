#read in tables containing blast results
forward <- read.table(snakemake@input[[1]], 
                              col.names = c("qseqid", "sseqid", "pident", "qcovs", "qlen", "slen", "length", "bitscore", "evalue"))

reverse <- read.table(snakemake@input[[2]], 
                              col.names = c("qseqid", "sseqid", "pident", "qcovs", "qlen", "slen", "length", "bitscore", "evalue"))

#filter results based on percent identity, percent query coverage, and e value
forwardFilter <- forward[forward$qcovs >= 80,]
forwardFilter <- forwardFilter[forwardFilter$pident >= 80,]
forwardFilter <- forwardFilter[forwardFilter$evalue <= .00001,]

reverseFilter <- reverse[reverse$qcovs >= 80,]
reverseFilter <- reverseFilter[reverseFilter$pident >= 80,]
reverseFilter <- reverseFilter[reverseFilter$evalue <= .00001,]

#isolate IDs
forwardIDs <- data.frame(forwardFilter$qseqid, forwardFilter$sseqid)
colnames(forwardIDs) <- c("qseqid", "sseqid")
forwardIDs <- unique(forwardIDs)
reverseIDs <- data.frame(reverseFilter$qseqid, reverseFilter$sseqid)
colnames(reverseIDs) <- c("qseqid", "sseqid")
reverseIDs <- unique(reverseIDs)

#remove duplicate hits
forwardDupQuery <- forwardIDs$qseqid[duplicated(forwardIDs$qseqid)]
forwardDupQuery <- unique(forwardDupQuery)
forwardFilterNoDupQuery <- forwardIDs[ ! forwardIDs$qseqid %in% forwardDupQuery, ]
forwardDupSub <- forwardIDs$sseqid[duplicated(forwardIDs$sseqid)]
forwardDupSub <- unique(forwardDupSub)
forwardFilterNoDup <- forwardIDs[ ! forwardIDs$sseqid %in% forwardDupSub, ]

reverseDupQuery <- reverseIDs$qseqid[duplicated(reverseIDs$qseqid)]
reverseDupQuery <- unique(reverseDupQuery)
reverseFilterNoDupQuery <- reverseIDs[ ! reverseIDs$qseqid %in% reverseDupQuery, ]
reverseDupSub <- reverseIDs$sseqid[duplicated(reverseIDs$sseqid)]
reverseDupSub <- unique(reverseDupSub)
reverseFilterNoDup <- reverseIDs[ ! reverseIDs$sseqid %in% reverseDupSub, ]

#write and run function to compare two dataframes
compareDataFramesFun <- function(forwardDF, reverseDF) {
  newDF <- data.frame()
  for (x in 1:nrow(forwardDF)) {
    for (y in 1:nrow(reverseDF)) {
      if ((forwardDF$qseqid[x] == reverseDF$sseqid[y]) && (forwardDF$sseqid[x] == reverseDF$qseqid[y])) {
        newDF <- rbind(newDF, forwardDF[x,])
      }
    }
  }
  return(newDF) 
}

combinedOutput <- compareDataFramesFun(forwardFilterNoDup, reverseFilterNoDup)

#write combined output to file
write.table(combinedOutput, file=snakemake@output)
