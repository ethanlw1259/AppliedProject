#!/bin/bash
#SBATCH -N 1  # number of nodes
#SBATCH -c 1  # number of cores to allocate
#SBATCH -t 30   # time in d-hh:mm:ss
#SBATCH --mem=8G
#SBATCH -p general       # partition
#SBATCH -q public       # QOS
#SBATCH -o  /scratch/eleiterw/AppliedProject/outerr/ml_format.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e  /scratch/eleiterw/AppliedProject/outerr/ml_format.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

while getopts 'i:r:o:' OPTION; do
        case "$OPTION" in
                i)
                        inputBed="$OPTARG"
                        ;;
                r)
                        regionsFile="$OPTARG"
                        ;;
		o)
			outputFile="$OPTARG"
			;;
                ?)
                        echo "script usage: -i <bedFile> -r <regionsFile>"
                        exit 1
                        ;;
                esac
        done
shift "$(($OPTIND -1))"

echo "Input Parameters:\nInput bed: ${inputBed}\nRegions file: ${regionsFile}\nOutput file: ${outputFile}\n"

# Always purge modules to ensure consistent environments
module purge

#Load plink 1.90
module load plink/1.90

domOut=`dirname $outputFile``echo '/dominant.'``basename $outputFile`
addOut=`dirname $outputFile``echo '/additive.'``basename $outputFile`



plink --bfile ${inputBed} --extract ${regionsFile} --recode A --out "${addOut}"
plink --bfile ${inputBed} --extract ${regionsFile} --recode AD --out "${domOut}"
