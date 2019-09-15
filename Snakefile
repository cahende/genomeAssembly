#!/usr/bin/env/ python
shell.prefix("set -o pipefail; ")
shell.executable("/bin/bash")
shell.prefix("source ~/.bashrc; ")
configfile: "config.yaml"

rule all:
    input:
        expand(directory("data/velvetAssembly/{sample}/"), sample=config["SAMPLES"])

rule trim_reads:
    input:
        expand("data/{{sample}}_{read}.fastq.gz", read=["R1", "R2"])
    output:
        "data/trimmed_reads/{sample}_R1_paired.fastq.gz",
        "data/trimmed_reads/{sample}_R1_unpaired.fastq.gz",
        "data/trimmed_reads/{sample}_R2_paired.fastq.gz",
        "data/trimmed_reads/{sample}_R2_unpaired.fastq.gz"
    log: "logs/trim/{sample}.trim.log"
    shell:
        "conda activate bioinfo;"
        "fastqc {input};"
        "trimmomatic PE -phred33 -trimlog {log} {input} {output} ILLUMINACLIP:{config[ADAPTERS]}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36;"
        "fastqc {output}"

rule velvetAssembly:
    input:
        "data/trimmed_reads/{sample}_R1_paired.fastq.gz",
        "data/trimmed_reads/{sample}_R2_paired.fastq.gz"
    output:
        directory("data/velvetAssembly/{sample}/")
    shell:
        "conda activate bioinfo;"
        "rm -R {output};"
        "velveth {output} 85 -shortPaired -fastq.gz -separate {input[0]} {input[1]};"
        "velvetg {output} -cov_cutoff 5 -exp_cov 30 -read_trkg yes"

