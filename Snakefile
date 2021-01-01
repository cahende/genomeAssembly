#!/opt/acci i/sw/adf/2019.103/bin/python3.6/bin/python3
shell.prefix("set -o pipefail; ")
shell.executable("/bin/bash")
shell.prefix("source ~/.bashrc; ")
configfile: "config.yaml"

rule all:
    input:
        expand("data/velvetAssemblyAll/{sample}/genomeAlignment/{sample}-reciprocalBlastCombined.tab", sample=config["SAMPLES"])

rule trim_reads_all:
    input:
        expand("data/{{sample}}_{read}.fastq.gz", read=["R1", "R2"])
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

rule velvet_assembly_all:
    input:
        "data/trimmed_reads_all/{sample}_R1_paired.fastq.gz",
        "data/trimmed_reads_all/{sample}_R2_paired.fastq.gz"
    output:
        "data/velvetAssemblyAll/{sample}/{sample}.fa"
    shell:
        "conda activate bioinfo;"
        "rm -R {output};"
        "velveth data/velvetAssemblyAll/{wildcards.sample}/ 85 -shortPaired -fastq.gz -separate {input[0]} {input[1]};"
        "velvetg data/velvetAssemblyAll/{wildcards.sample}/ -cov_cutoff 5 -exp_cov 30 -read_trkg yes;"
        "mv data/velvetAssemblyAll/{wildcards.sample}/contigs.fa {output}"

rule velvet_assembly_species:
    input:
        "data/trimmed_reads_species/{species}_R1_paired.fastq.gz",
        "data/trimmed_reads_species/{species}_R2_paired.fastq.gz"
    output:
        "data/velvetAssemblySpecies/{species}/{species}.fa"
    shell:
        "conda activate bioinfo;"
        "rm -R {output};"
        "velveth data/velvetAssemblySpecies/{wildcards.species}/ 85 -shortPaired -fastq.gz -separate {input[0]} {input[1]};"
        "velvetg data/velvetAssemblySpecies/{wildcards.species}/ -cov_cutoff 5 -exp_cov 30 -read_trkg yes;"
        "mv data/velvetAssemblySpecies/{wildcards.species}/contigs.fa {output}"

rule repeatMaskingAll:
    input:
        "data/velvetAssemblyAll/{sample}/{sample}.fa"
    output:
        directory("data/velvetAssemblyAll/{sample}/repeatMasking/"),
	"data/velvetAssemblyAll/{sample}/{sample}-repeatMasked.fa"
    shell:
        "conda activate bioinfo;"
        "{config[REPEATMASKER]} -species Anophelinae -dir {output[0]} {input};"
	"cp {output[0]}*.fa.masked {output[1]}"

rule augustus_Gene_ID_species:
    input:
        "data/velvetAssemblySpecies/{species}/{species}.fa"
    output:
        "data/velvetAssemblySpecies/{species}/{species}-genePredictions.gff"
    shell:
        "conda activate bioinfo;"
        "augustus {input}/*.fa --species=anophelesGambiae --outfile={output}"

rule augustus_Gene_ID_all:
    input:
        "data/velvetAssemblyAll/{sample}/{sample}-repeatMasked.fa"
    output:
        "data/velvetAssemblyAll/{sample}/{sample}-genePredictions.gff"
    shell:
        "conda activate bioinfo;"
        "augustus {input} --species=anopheles --outfile={output}"

rule busco_all:
    input:
        "data/velvetAssemblyAll/{sample}/{sample}.fa",
        "data/velvetAssemblyAll/{sample}/{sample}-genePredictions.gff"
    output:
        directory("data/velvetAssemblyAll/{sample}/buscoGenome"),
        directory("data/velvetAssemblyAll/{sample}/buscoProteins"),
        "data/velvetAssemblyAll/{sample}/{sample}-genePredictions.fa"
    shell:
        "conda activate bioinfo;"
        "busco -i {input[0]} -m genome -l insecta --out {wildcards.sample} --out_path {output[0]};"
        "gffread {input[1]} -g {input[0]} -w {output[2]};"
        "busco -i {output[2]} -m transcriptome -l insecta --out {wildcards.sample} --out_path {output[1]}"

rule reciprocal_blast:
	input:
		"data/velvetAssemblyAll/{sample}/{sample}-genePredictions.fa"
	output:
		"data/velvetAssemblyAll/{sample}/{sample}-genePredictions-aminoAcid.fa",
		"data/velvetAssemblyAll/{sample}/genomeAlignment/{sample}-forwardBlast-anGambiaeDB-UP000007062.tab",
		"data/velvetAssemblyAll/{sample}/genomeAlignment/{sample}-reverseBlast-anGambiaeDB-UP000007062.tab"
	shell:
		"conda activate bioinfo;"
		"transeq -clean -sequence {input} -outseq {output[0]};"
		"blastp -query {output[0]} -subject {config[GENES]} -out {output[1]} -outfmt '6 qseqid sseqid pident qcovs qlen slen length bitscore evalue';"
		"blastp -query {config[GENES]} -subject {output[0]} -out {output[2]} -outfmt '6 qseqid sseqid pident qcovs qlen slen length bitscore evalue'" 

rule combine_forward_and_reverse_blast:
	input:
		"data/velvetAssemblyAll/{sample}/genomeAlignment/{sample}-forwardBlast-anGambiaeDB-UP000007062.tab",
		"data/velvetAssemblyAll/{sample}/genomeAlignment/{sample}-reverseBlast-anGambiaeDB-UP000007062.tab"
	output:
		"data/velvetAssemblyAll/{sample}/genomeAlignment/{sample}-reciprocalBlastCombined.tab"
	shell:
		"conda activate bioinfo;"
		"module load r;"
		"Rscript scripts/combineReciprocalBlastHits.R"

rule interProScan_all:
    input:
        "data/velvetAssemblyAll/{sample}/{sample}.fa",
        "data/velvetAssemblyAll/{sample}/{sample}-genePredictions.gff"
    output:
        "data/velvetAssemblyAll/{sample}/{sample}-genePredictions-aminoAcid.fa"
    shell:
        "conda activate bioinfo;"
        "module use /gpfs/group/dml129/default/sw/modules;"
        "module load jdk;"
        "rm -R data/velvetAssemblyAll/{wildcards.sample}/functionalPredictions;"
        "mkdir data/velvetAssemblyAll/{wildcards.sample}/functionalPredictions;"
        "gffread {input[1]} -g {input[0]} -w data/velvetAssemblyAll/{wildcards.sample}/{wildcards.sample}-genePredictions.fa;"
        "transeq -clean -sequence data/velvetAssemblyAll/{wildcards.sample}/{wildcards.sample}-genePredictions.fa -outseq {output};"
        "{config[INTERPROSCAN]} -T tempInterproScan/{wildcards.sample}/ -i {output} -goterms -d data/velvetAssemblyAll/{wildcards.sample}/functionalPredictions"
