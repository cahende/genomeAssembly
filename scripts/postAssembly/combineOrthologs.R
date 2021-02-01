#read in tables containing blast results
COL_albi1 <- read.table("COL_albi-1-combinedRBH.tab", header=T, sep=",") 

COL_albi2 <- read.table("COL_albi-2-combinedRBH.tab", header=T, sep=",")

COL_quad3 <- read.table("COL_quad-3-combinedRBH.tab", header=T, sep=",")

COL_quad4 <- read.table("COL_quad-4-combinedRBH.tab", header=T, sep=",")

NC_crucians2 <- read.table("NC_crucians-2-combinedRBH.tab", header=T, sep=",")

NC_crucians3 <- read.table("NC_crucians-3-combinedRBH.tab", header=T, sep=",")

NC_crucians4 <- read.table("NC_crucians-4-combinedRBH.tab", header=T, sep=",")

NC_punctipennis1 <- read.table("NC_punctipennis-1-combinedRBH.tab", header=T, sep=",")

NC_punctipennis2 <- read.table("NC_punctipennis-2-combinedRBH.tab", header=T, sep=",")

NC_punctipennis4 <- read.table("NC_punctipennis-4-combinedRBH.tab", header=T, sep=",")

WA_freeborni1 <- read.table("WA_freeborni-1-combinedRBH.tab", header=T, sep=",")  

WA_freeborni2 <- read.table("WA_freeborni-2-combinedRBH.tab", header=T, sep=",")

#combine RBH into vector containing ortholog ID in An. gamb
COL_albi1ID <- c()
COL_albi2ID <- c()
COL_quad3ID <- c()
COL_quad4ID <- c()
NC_crucians2ID <- c()
NC_crucians3ID <- c()
NC_crucians4ID <- c()
NC_punctipennis1ID <- c()
NC_punctipennis2ID <- c()
NC_punctipennis4ID <- c()
WA_freeborni1ID <- c()
WA_freeborni2ID <- c()

orthologs1 <- data.frame()
for (a in 1:nrow(COL_albi1)) {
	for (b in 1:nrow(COL_albi2)) {
		if (as.character(COL_albi1$sseqid[a]) == as.character(COL_albi2$sseqid[b])) {
			orthologs1 <- rbind(orthologs1, COL_albi1[a,])
}}}

orthologs2 <- data.frame()
for (a in 1:nrow(orthologs1)) {
    for (b in 1:nrow(COL_quad3)) {
        if (as.character(orthologs1$sseqid[a]) == as.character(COL_quad3$sseqid[b])) {
            orthologs2 <- rbind(orthologs2, orthologs1[a,])
}}}		

orthologs3 <- data.frame()
for (a in 1:nrow(orthologs2)) {
    for (b in 1:nrow(COL_quad4)) {
        if (as.character(orthologs2$sseqid[a]) == as.character(COL_quad4$sseqid[b])) {
            orthologs3 <- rbind(orthologs3, orthologs2[a,])
}}}

orthologs4 <- data.frame()
for (a in 1:nrow(orthologs3)) {
    for (b in 1:nrow(NC_crucians2)) {
        if (as.character(orthologs3$sseqid[a]) == as.character(NC_crucians2$sseqid[b])) {
            orthologs4 <- rbind(orthologs4, orthologs3[a,])
}}}

orthologs5 <- data.frame()
for (a in 1:nrow(orthologs4)) {
    for (b in 1:nrow(NC_crucians3)) {
        if (as.character(orthologs4$sseqid[a]) == as.character(NC_crucians3$sseqid[b])) {
            orthologs5 <- rbind(orthologs5, orthologs4[a,])
}}}

orthologs6 <- data.frame()
for (a in 1:nrow(orthologs5)) {
    for (b in 1:nrow(NC_crucians4)) {
        if (as.character(orthologs5$sseqid[a]) == as.character(NC_crucians4$sseqid[b])) {
            orthologs6 <- rbind(orthologs6, orthologs5[a,])
}}}

orthologs7 <- data.frame()
for (a in 1:nrow(orthologs6)) {
    for (b in 1:nrow(NC_punctipennis1)) {
        if (as.character(orthologs6$sseqid[a]) == as.character(NC_punctipennis1$sseqid[b])) {
            orthologs7 <- rbind(orthologs7, orthologs6[a,])
}}}

orthologs8 <- data.frame()
for (a in 1:nrow(orthologs7)) {
    for (b in 1:nrow(NC_punctipennis2)) {
        if (as.character(orthologs7$sseqid[a]) == as.character(NC_punctipennis2$sseqid[b])) {
            orthologs8 <- rbind(orthologs8, orthologs7[a,])
}}}	

orthologs9 <- data.frame()
for (a in 1:nrow(orthologs8)) {
    for (b in 1:nrow(NC_punctipennis4)) {
        if (as.character(orthologs8$sseqid[a]) == as.character(NC_punctipennis4$sseqid[b])) {
            orthologs9 <- rbind(orthologs9, orthologs8[a,])
}}}

orthologs10 <- data.frame()
for (a in 1:nrow(orthologs9)) {
    for (b in 1:nrow(WA_freeborni1)) {
        if (as.character(orthologs9$sseqid[a]) == as.character(WA_freeborni1$sseqid[b])) {
            orthologs10 <- rbind(orthologs10, orthologs9[a,])
}}}

orthologs11 <- data.frame()
for (a in 1:nrow(orthologs10)) {
    for (b in 1:nrow(WA_freeborni2)) {
        if (as.character(orthologs10$sseqid[a]) == as.character(WA_freeborni2$sseqid[b])) {
            orthologs11 <- rbind(orthologs11, orthologs10[a,])
}}}


for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(COL_albi1)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(COL_albi1$sseqid[b])) {
            COL_albi1ID <- c(COL_albi1ID, COL_albi1$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(COL_albi2)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(COL_albi2$sseqid[b])) {
            COL_albi2ID <- c(COL_albi2ID, COL_albi2$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(COL_quad3)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(COL_quad3$sseqid[b])) {
            COL_quad3ID <- c(COL_quad3ID, COL_quad3$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(COL_quad4)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(COL_quad4$sseqid[b])) {
            COL_quad4ID <- c(COL_quad4ID, COL_quad4$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(NC_crucians2)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(NC_crucians2$sseqid[b])) {
            NC_crucians2ID <- c(NC_crucians2ID, NC_crucians2$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(NC_crucians3)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(NC_crucians3$sseqid[b])) {
            NC_crucians3ID <- c(NC_crucians3ID, NC_crucians3$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(NC_crucians4)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(NC_crucians4$sseqid[b])) {
            NC_crucians4ID <- c(NC_crucians4ID, NC_crucians4$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(NC_punctipenis1)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(NC_punctipennis1$sseqid[b])) {
            NC_punctipennis1ID <- c(NC_punctipennis1ID, NC_punctipennis1$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(NC_punctipenis2)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(NC_punctipennis2$sseqid[b])) {
            NC_punctipennis2ID <- c(NC_punctipennis2ID, NC_punctipennis2$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(NC_punctipenis4)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(NC_punctipennis4$sseqid[b])) {
            NC_punctipennis4ID <- c(NC_punctipennis4ID, NC_punctipennis4$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(WA_freeborni1)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(WA_freeborni1$sseqid[b])) {
            WA_freeborni1ID <- c(WA_freeborni1ID, WA_freeborni1$qseqid[b])
}}}

for (a in 1:nrow(orthologs11)) {
    for (b in 1:nrow(WA_freeborni2)) {
        if (as.character(orthologs11$sseqid[a]) == as.character(WA_freeborni2$sseqid[b])) {
            WA_freeborni2ID <- c(WA_freeborni2ID, WA_freeborni2$qseqid[b])
}}}


orthologsCombined <- data.frame(orthologs11$sseqid, COL_albi1ID, COL_albi2ID, COL_quad3ID, COL_quad4ID, NC_crucians2ID, NC_crucians3ID, NC_crucians4ID, NC_punctipennis1ID, NC_punctipennis2ID, NC_punctipennis4ID, WA_freeborni1ID, WA_freeborni2ID)

#write out results
write.table(orthologsCombined, file="orthologsCombined.tab")
