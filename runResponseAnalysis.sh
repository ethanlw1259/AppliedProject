#!/bin/bash

#SBATCH -N 1  # number of nodes
#SBATCH -c 1  # number of cores to allocate
#SBATCH -t 2-00:00:00   # time in d-hh:mm:ss
#SBATCH -p general       # partition 
#SBATCH -q public       # QOS
#SBATCH -o  /scratch/eleiterw/AppliedProject/outerr/runAnalysis.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e  /scratch/eleiterw/AppliedProject/outerr/runAnalysis.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

# Always purge modules to ensure consistent environments
module purge
module load bcftools-1.9-gcc-12.1.0 
module load plink/1.90

plink --logistic --bfile /scratch/eleiterw/AppliedProject/annotatedBCF/only_protein_all_filters --pheno /home/eleiterw/Thesis/dupeAnalysis/responsePheno.txt --covar /home/eleiterw/Thesis/dupeAnalysis/covariatesOldEigen.txt --hide-covar --out  /scratch/eleiterw/AppliedProject/results/TopMed.Response.OldEigen
