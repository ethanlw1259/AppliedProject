#!/bin/bash
#SBATCH -J hyperparam # job_name
#SBATCH -N 1  # number of nodes
#SBATCH -c 1  # number of cores to allocate
#SBATCH --mem=128G
#SBATCH -t 03:59:59   # time in d-hh:mm:ss
#SBATCH -p highmem       # partition 
#SBATCH -q public       # QOS
#SBATCH -o /scratch/eleiterw/AppliedProject/results/hyperparam.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e /scratch/eleiterw/AppliedProject/outerr/hyperparam.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

module purge
module load mamba/latest

source activate deepNullEnv

python /scratch/eleiterw/AppliedProject/scripts/runDeepNull.py
