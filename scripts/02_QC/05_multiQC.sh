#!/bin/bash
#SBATCH --job-name=multiqcTrim
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 12
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
# Aggregate reports using MultiQC
#################################################################

module load MultiQC/1.15

# run on fastqc output
multiqc -f -o ../../results/02_QC/multiqc_trim ../../results/02_QC/fastqc_trimmed_reports