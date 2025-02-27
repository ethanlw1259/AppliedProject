#!/bin/bash
#SBATCH -J uniq_biotypes # job_name
#SBATCH -N 1  # number of nodes
#SBATCH -c 1  # number of cores to allocate
#SBATCH -t 07:59:59   # time in d-hh:mm:ss
#SBATCH -p general       # partition 
#SBATCH -q public       # QOS
#SBATCH -o unique_transcript_biotypes.txt # file to save job's STDOUT (%j = JobId)
#SBATCH -e get_uniq_biotype.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

module purge

grep -v '^#' annotated.vcf | cut -d '|' -f8 | sort -u 
