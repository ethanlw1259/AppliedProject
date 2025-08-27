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

while getopts 'r:s:o:' OPTION; do
        case "$OPTION" in
                r)  
                        geneResults="$OPTARG"
                        ;;  

                s)  
                        geneSet="$OPTARG"
                        ;;  

                o)  
                        outputFile="$OPTARG"
                        ;;  

                ?)  
                        echo "script usage: -r <geneResults> -s <geneSet> -o <outputFile>"
                        exit 1
                        ;;  
                esac
        done
shift "$(($OPTIND -1))"

# Always purge modules to ensure consistent environments
module purge

/scratch/eleiterw/AppliedProject/scripts/magma/magma --gene-results ${geneResults} --set-annot ${geneSet} --out ${outputFile}
