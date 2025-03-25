#!/bin/bash
#SBATCH --job-name=align
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=15G
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-24]

hostname
date

#################################################################
# Align reads to genome
#################################################################
module load hisat2/2.2.1
module load samtools/1.20

INDIR=../../results/02_QC/trimmed_fastq
OUTDIR=../../results/03_align/alignments
mkdir -p ${OUTDIR}

# this is an array job. 
	# one task will be spawned for each sample
	# for each task, we specify the sample as below
	# use the task ID to pull a single line, containing a single accession number from the accession list
	# then construct the file names in the call to hisat2 as below

INDEX=../../genome/hisat2_index/rnorvegicus

ACCLIST=../../metadata/accessionlist.txt

SAMPLE=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${ACCLIST})

# run hisat2
hisat2 \
	-p 4 \
	-x ${INDEX} \
	-1 ${INDIR}/${SAMPLE}_trim_1.fastq.gz \
	-2 ${INDIR}/${SAMPLE}_trim_2.fastq.gz | \
samtools sort -@ 1 -T ${OUTDIR}/${SAMPLE} - >${OUTDIR}/${SAMPLE}.bam

# index bam files
samtools index ${OUTDIR}/${SAMPLE}.bam