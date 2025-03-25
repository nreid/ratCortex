#!/bin/bash
#SBATCH --job-name=htseqCount
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 10
#SBATCH --mem=20G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

echo `hostname`
date

#################################################################
# Generate Counts 
#################################################################
module load htseq/0.13.5
module load parallel/20180122

INDIR=../../results/03_align/alignments
OUTDIR=../../results/04_counts/counts
mkdir -p $OUTDIR

# accession list
ACCLIST=../../metadata/accessionlist.txt

# gtf formatted annotation file
GTF=../../genome/Rattus_norvegicus.mRatBN7.2.113.gtf

# run htseq-count on each sample, up to 5 in parallel
cat $ACCLIST | \
parallel -j 10 \
    "htseq-count \
        -s no \
        -r pos \
        -f bam $INDIR/{}.bam \
        $GTF \
        > $OUTDIR/{}.counts"