test <- read.csv("WA_freeborni-2-exonerateOutputFixed-scoreFiltered.tab", header = F, sep = ",")
testNew <- data.frame(test$V4, test$V5, test$V6, test$V1, test$V10)
colnames(testNew) <- c("V1", "V2", "V3", "V4", "V5")
start <- c()
end <- c()
for (n in 1:nrow(testNew)) {
  if (testNew$V2[n] < testNew$V3[n]) {
    start <- c(start, testNew$V2[n])
    end <- c(end, testNew$V3[n])
  } else {
    start <- c(start, testNew$V3[n])
    end <- c(end, testNew$V2[n])
  }
}
testFinal <- data.frame(testNew$V1, start, end, testNew$V4, testNew$V5)
write.table(testFinal, file="WA_freeborni-2.bed", sep="\t", col.names=F, row.names=F)

