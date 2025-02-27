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

while getopts 'i:p:c:o:' OPTION; do
	case "$OPTION" in
		i)
			inputBed="$OPTARG"
			;;
		p)
			phenoFile="$OPTARG"
			;;
		c)
			covarFile="$OPTARG"
			;;
		o)
			outputFile="$OPTARG"
			;;
		?)
			echo "script usage: -i <bedFile> -p <phenoFile> -c <covarFile> -o <outputFile>"
			exit 1
			;;
		esac
	done
shift "$(($OPTIND -1))"


# Always purge modules to ensure consistent environments
module purge
module load bcftools-1.9-gcc-12.1.0 
module load plink/1.90

plink --logistic --bfile ${inputBed} --pheno ${phenoFile} --covar ${covarFile} --hide-covar --out  ${outputFile}
