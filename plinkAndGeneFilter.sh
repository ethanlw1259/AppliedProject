#!/bin/bash

#SBATCH -N 1  # number of nodes
#SBATCH -c 1  # number of cores to allocate
#SBATCH -t 4-00:00:00   # time in d-hh:mm:ss
#SBATCH -p general       # partition 
#SBATCH -q public       # QOS
#SBATCH -o /scratch/eleiterw/AppliedProject/outerr/slurm.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e /scratch/eleiterw/AppliedProject/outerr/slurm.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

module purge
module load bcftools-1.14-gcc-11.2.o
module load plink/1.90

plink --bcf /scratch/eleiterw/AppliedProject/annotatedBCF/annotated_only_protein_subjFiltered.bcf.gz --make-bed --genome --maf 0.05 --geno 0.05 --min 0.1 --mind 0.1 --out /scratch/eleiterw/AppliedProject/annotatedBCF/only_protein_all_filters

