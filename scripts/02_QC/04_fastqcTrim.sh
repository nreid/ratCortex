#!/bin/bash
#SBATCH --job-name=fastqcTrim
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --mem=20G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

#################################################################
# FastQC trimmed data
#################################################################
module load fastqc/0.12.1
module load parallel/20180122

# set input/output directory variables
INDIR=../../results/02_QC/trimmed_fastq
REPORTDIR=../../results/02_QC/fastqc_trimmed_reports
mkdir -p $REPORTDIR

ACCLIST=../../metadata/accessionlist.txt
# run fastp in parallel, 10 samples at a time
cat $ACCLIST | parallel -j 16 \
    "fastqc --outdir $REPORTDIR $INDIR/{}_trim_{1..2}.fastq.gz"