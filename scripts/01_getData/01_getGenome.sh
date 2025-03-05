#!/bin/bash
#SBATCH --job-name=getGenome
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=2G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

echo `hostname`
date

#################################################################
# Download genome and annotation from ENSEMBL
#################################################################

# load software
module load samtools/1.20

# output directory
GENOMEDIR=../../genome
mkdir -p $GENOMEDIR

# resources
    # we'll download the genome, GTF annotation and transcript fasta
    # https://useast.ensembl.org/Rattus_norvegicus/Info/Index

# note that in these URLs we are downloading v112 specifically. 

# download the genome
wget -P ${GENOMEDIR} https://ftp.ensembl.org/pub/release-113/fasta/rattus_norvegicus/dna/Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz

# download the GTF annotation
wget -P ${GENOMEDIR} https://ftp.ensembl.org/pub/release-113/gtf/rattus_norvegicus/Rattus_norvegicus.mRatBN7.2.113.gtf.gz

# decompress files
gunzip ${GENOMEDIR}/*gz

# generate simple samtools fai indexes 
samtools faidx ${GENOMEDIR}/Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa
