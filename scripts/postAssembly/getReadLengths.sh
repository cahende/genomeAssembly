#!/bin/bash
conda activate bioinfo
sed 's/\s.*$//' data/UP000007062_7165.fasta > data/UP000007062_namesFixed.fasta
backtranseq -sformat pearson -sequence data/UP000007062_namesFixed.fasta -outfile data/UP000007062_nucleotide.fasta
sed '/^>/ s/$/;/' data/UP000007062_nucleotide.fasta > data/UP000007062_nucleotide2.fasta
awk '/^>/ {if (seqlen) print seqlen;print;seqlen=0;next} {seqlen+=length($0)}END{print seqlen}' data/UP000007062_nucleotide2.fasta > data/UP000007062_seqLengths.fasta
awk 'NR>1 && /^>/{printf "%s"," \n"$0;next}{printf "%s",$0}END{print}' data/UP000007062_seqLengths.fasta > data/UP000007062_seqLengths.tab

exit;
