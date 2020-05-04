#!/usr/bin/env/ python
shell.prefix("set -o pipefail; ")
shell.executable("/bin/bash")
shell.prefix("source ~/.bashrc; ")
configfile: "config.yaml"

rule all:
    input:
        expand("data/velvetAssemblySpecies/{species}/{species}-genePredictions.txt", species=config["SPECIES"])

rule trim_reads_all:
    input:
        expand("data/{sample}_{read}.fastq.gz", sample=config["SAMPLES"], read=["R1", "R2"])
    output:
        "data/trimmed_reads_all/{sample}_R1_paired.fastq.gz",
        "data/trimmed_reads_all/{sample}_R1_unpaired.fastq.gz",
        "data/trimmed_reads_all/{sample}_R2_paired.fastq.gz",
        "data/trimmed_reads_all/{sample}_R2_unpaired.fastq.gz"
    log: "logs/trimAll/{sample}.trim.log"
    shell:
        "conda activate bioinfo;"
        "fastqc {input};"
        "trimmomatic PE -phred33 -trimlog {log} {input} {output} ILLUMINACLIP:{config[ADAPTERS]}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36;"
        "fastqc {output}"

rule trim_reads_species:
    input:
        expand("data/{{species}}_{read}.fastq.gz", read=["R1", "R2"])
    output:
        "data/trimmed_reads_species/{species}_R1_paired.fastq.gz",
        "data/trimmed_reads_species/{species}_R1_unpaired.fastq.gz",
        "data/trimmed_reads_species/{species}_R2_paired.fastq.gz",
        "data/trimmed_reads_species/{species}_R2_unpaired.fastq.gz"
    log: "logs/trimSpecies/{species}.trim.log"
    shell:
        "conda activate bioinfo;"
        "fastqc {input};"
        "trimmomatic PE -phred33 -trimlog {log} {input} {output} ILLUMINACLIP:{config[ADAPTERS]}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36;"
        "fastqc {output}"

rule velvetAssemblySpecies:
    input:
        "data/trimmed_reads_species/{species}_R1_paired.fastq.gz",
        "data/trimmed_reads_species/{species}_R2_paired.fastq.gz"
    output:
        "data/velvetAssemblySpecies/{species}/{species}.fa"
    shell:
        "conda activate bioinfo;"
        "rm -R {output};"
        "velveth data/velvetAssemblySpecies/{species}/ 85 -shortPaired -fastq.gz -separate {input[0]} {input[1]};"
        "velvetg data/velvetAssemblySpecies/{species}/ -cov_cutoff 5 -exp_cov 30 -read_trkg yes;"
        "mv data/velvetAssemblySpecies/{species}/contigs.fa {output[1]}"

rule augustusGeneID:
    input:
        "data/velvetAssemblySpecies/{species}/{species}.fa"
    output:
        "data/velvetAssemblySpecies/{species}/{species}-genePredictions.txt"
    shell:
        "conda activate bioinfo;"
        "augustus {input} --species=aedes --outfile={output}"
