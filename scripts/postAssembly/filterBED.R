testBed <- read.table("WA_freeborni-2-combined.bed")
geneLengths <- read.table("data/UP000007062_seqLengths.tab", sep=";")
filterBed <- data.frame(testBed$V4, testBed$V6)
testBed$V7 <- geneLengths$V2[match(testBed$V4, geneLengths$V1)]
testBed$V8 = nchar(as.character(testBed$V5))/testBed$V7
testBed <- testBed[testBed$V8 >= 0.8,]
filterBedUnique <- unique(filterBed)
colnames(filterBedUnique) <- c("V1", "V2")
filterBedUnique <- filterBedUnique[!(duplicated(filterBedUnique$V1) | duplicated(filterBedUnique$V1, fromLast = TRUE)), ]
filterBedUnique <- filterBedUnique[!(duplicated(filterBedUnique$V2) | duplicated(filterBedUnique$V2, fromLast = TRUE)), ]
testBed <- testBed[testBed$V4 %in% filterBedUnique$V1,]
testBed <- testBed[testBed$V6 %in% filterBedUnique$V2,]
testBed <- testBed[!(duplicated(testBed$V6) | duplicated(testBed$V6, fromLast = TRUE)), ]
#testBed <- testBed[- grep("N", testBed$V5),]
write.table(testBed, "WA_freeborni-2-combinedFiltered.bed", sep="\t", col.names=F, row.names=F)
