#!/bin/bash
#SBATCH --job-name=symlinkData
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=10G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


#####################
# symlink data
#####################

# this script symlinks the raw data pools to the working directory
	# instead of copying the raw data, we create pointers to it. 

# input, output directories
DATAPATH="/seqdata/CGI/Fastq_Files/ELombardo_24mRNA_Feb2025/"

RAWDATADIR=../../rawData/
mkdir -p $RAWDATADIR

# using a for loop, create a symlink for each fastq.gz file
for f in ${DATAPATH}/*fastq.gz; do
        # write filename and file base name to standard out
        echo $f
        echo $(basename ${f})

        # symlink file	
        ln -s ${f} $RAWDATADIR/$(basename ${f})
done