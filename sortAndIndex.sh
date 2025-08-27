#!/bin/bash

#SBATCH -N 1  # number of nodes
#SBATCH -c 8  # number of cores to allocate
#SBATCH --mem=128g # specifies memory requested
#SBATCH -t 2-00:00:00   # time in d-hh:mm:ss
#SBATCH -p general       # partition 
#SBATCH -q public       # QOS
#SBATCH -o /scratch/eleiterw/AppliedProject/outerr/sortAndIndex.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e /scratch/eleiterw/AppliedProject/outerr/sortAndIndex.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

module purge
module load bcftools-1.14-gcc-11.2.0

bcftools sort -m 120GB -T ./tmp -O b -o /scratch/eleiterw/AppliedProject/annotatedBCF/annotated_only_protein_sorted.bcf.gz  /scratch/eleiterw/AppliedProject/annotatedBCF/annotated_only_protein.bcf.gz
bcftools index annotated_only_protein_sorted.bcf.gz

