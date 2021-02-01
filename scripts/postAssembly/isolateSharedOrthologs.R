#Load samples
COL_albi1 <- read.table("COL_albi-1-combinedFiltered 2.bed")
COL_albi2 <- read.table("COL_albi-2-combinedFiltered.bed")
COL_quad3 <- read.table("COL_quad-3-combinedFiltered.bed")
COL_quad4 <- read.table("COL_quad-4-combinedFiltered.bed")
NC_crucians2 <- read.table("NC_crucians-2-combinedFiltered.bed")
NC_crucians3 <- read.table("NC_crucians-3-combinedFiltered.bed")
NC_crucians4 <- read.table("NC_crucians-4-combinedFiltered.bed")
NC_punctipennis1 <- read.table("NC_punctipennis-1-combinedFiltered.bed")
NC_punctipennis2 <- read.table("NC_punctipennis-2-combinedFiltered.bed")
NC_punctipennis4 <- read.table("NC_punctipennis-4-combinedFiltered.bed")
WA_freeborni1 <- read.table("WA_freeborni-1-combinedFiltered.bed")
WA_freeborni2 <- read.table("WA_freeborni-2-combinedFiltered.bed")

#Isolate IDs
COL_albi1IDs <- unique(COL_albi1$V4)
COL_albi2IDs <- unique(COL_albi2$V4)
COL_quad3IDs <- unique(COL_quad3$V4)
COL_quad4IDs <- unique(COL_quad4$V4)
NC_crucians2IDs <- unique(NC_crucians2$V4)
NC_crucians3IDs <- unique(NC_crucians3$V4)
NC_crucians4IDs <- unique(NC_crucians4$V4)
NC_punctipennis1IDs <- unique(NC_punctipennis1$V4)
NC_punctipennis2IDs <- unique(NC_punctipennis2$V4)
NC_punctipennis4IDs <- unique(NC_punctipennis4$V4)
WA_freeborni1IDs <- unique(WA_freeborni1$V4)
WA_freeborni2IDs <- unique(WA_freeborni2$V4)

#Find shared othrologs between all samples
orthologs1 <- c()
for (a in 1:length(COL_albi1IDs)) {
  for (b in 1:length(COL_albi2IDs)) {
    if (COL_albi1IDs[a]  == COL_albi2IDs[b]) {
      orthologs1 <- rbind(orthologs1, as.character(COL_albi1IDs[a]))
}}}

orthologs2 <- c()
for (a in 1:length(orthologs1)) {
  for (b in 1:length(COL_quad3IDs)) {
    if (orthologs1[a] == COL_quad3IDs[b]) {
      orthologs2 <- rbind(orthologs2, as.character(orthologs1[a]))
    }}}

orthologs3 <- c()
for (a in 1:length(orthologs2)) {
  for (b in 1:length(COL_quad4IDs)) {
    if (orthologs2[a] == COL_quad4IDs[b]) {
      orthologs3 <- rbind(orthologs3, as.character(orthologs2[a]))
    }}}

orthologs4 <- c()
for (a in 1:length(orthologs3)) {
  for (b in 1:length(NC_crucians2IDs)) {
    if (orthologs3[a] == NC_crucians2IDs[b]) {
      orthologs4 <- rbind(orthologs4, as.character(orthologs3[a]))
    }}}

orthologs5 <- c()
for (a in 1:length(orthologs4)) {
  for (b in 1:length(NC_crucians3IDs)) {
    if (orthologs4[a] == NC_crucians3IDs[b]) {
      orthologs5 <- rbind(orthologs5, as.character(orthologs4[a]))
    }}}

orthologs6 <- c()
for (a in 1:length(orthologs5)) {
  for (b in 1:length(NC_crucians4IDs)) {
    if (orthologs5[a] == NC_crucians4IDs[b]) {
      orthologs6 <- rbind(orthologs6, as.character(orthologs5[a]))
    }}}

orthologs7 <- c()
for (a in 1:length(orthologs6)) {
  for (b in 1:length(NC_punctipennis1IDs)) {
    if (orthologs6[a] == NC_punctipennis1IDs[b]) {
      orthologs7 <- rbind(orthologs7, as.character(orthologs6[a]))
    }}}

orthologs8 <- c()
for (a in 1:length(orthologs7)) {
  for (b in 1:length(NC_punctipennis2IDs)) {
    if (orthologs7[a] == NC_punctipennis2IDs[b]) {
      orthologs8 <- rbind(orthologs8, as.character(orthologs7[a]))
    }}}

orthologs9 <- c()
for (a in 1:length(orthologs8)) {
  for (b in 1:length(NC_punctipennis4IDs)) {
    if (orthologs8[a] == NC_punctipennis4IDs[b]) {
      orthologs9 <- rbind(orthologs9, as.character(orthologs8[a]))
    }}}

orthologs10 <- c()
for (a in 1:length(orthologs9)) {
  for (b in 1:length(WA_freeborni1IDs)) {
    if (orthologs9[a] == WA_freeborni1IDs[b]) {
      orthologs10 <- rbind(orthologs10, as.character(orthologs9[a]))
    }}}

orthologs11 <- c()
for (a in 1:length(orthologs10)) {
  for (b in 1:length(WA_freeborni2IDs)) {
    if (orthologs10[a] == WA_freeborni2IDs[b]) {
      orthologs11 <- rbind(orthologs11, as.character(orthologs10[a]))
    }}}
