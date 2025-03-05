#!/bin/bash
#SBATCH --job-name=trimmomatic
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=15G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-24]

hostname
date

#################################################################
# Trimmomatic
#################################################################

module load Trimmomatic/0.39
module load parallel/20180122

# set input/output directory variables
INDIR=../../rawData/
TRIMDIR=../../results/02_QC/trimmed_fastq
mkdir -p $TRIMDIR

# adapters to trim out
ADAPTERS=/isg/shared/apps/Trimmomatic/0.39/adapters/NexteraPE-PE.fa

# accession list
ACCLIST=../../metadata/accessionlist.txt

# run trimmomatic

SAMPLE=$( sed -n ${SLURM_ARRAY_TASK_ID}p ${ACCLIST} )

java -jar $Trimmomatic PE -threads 4 \
        ${INDIR}/${SAMPLE}*R1*fastq.gz \
        ${INDIR}/${SAMPLE}*R2*fastq.gz \
        ${TRIMDIR}/${SAMPLE}_trim_1.fastq.gz ${TRIMDIR}/${SAMPLE}_trim_orphans_1.fastq.gz \
        ${TRIMDIR}/${SAMPLE}_trim_2.fastq.gz ${TRIMDIR}/${SAMPLE}_trim_orphans_2.fastq.gz \
        ILLUMINACLIP:"${ADAPTERS}":2:30:10 \
        SLIDINGWINDOW:4:15 MINLEN:45