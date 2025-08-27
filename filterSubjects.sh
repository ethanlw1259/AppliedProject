#!/bin/bash

#SBATCH -N 1  # number of nodes
#SBATCH -c 1  # number of cores to allocate
#SBATCH -t 8:00:00   # time in d-hh:mm:ss
#SBATCH -p general       # partition 
#SBATCH -q public       # QOS
#SBATCH -o /scratch/eleiterw/AppliedProject/outerr/slurm.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e /scratch/eleiterw/AppliedProject/outerr/slurm.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

# Always purge modules to ensure consistent environments
module purge
module load bcftools-1.14-gcc-11.2.0

bcftools view -S subjects.txt -O b -o /scratch/eleiterw/AppliedProject/annotatedBCF/annotated_only_protein_subjFiltered.bcf.gz /scratch/eleiterw/AppliedProject/annotatedBCF/annotated_only_protein.bcf.gz
