#!/bin/bash

#SBATCH -N 1  # number of nodes
#SBATCH -c 1  # number of cores to allocate
#SBATCH -t 30   # time in d-hh:mm:ss
#SBATCH --mem=8G
#SBATCH -p general       # partition 
#SBATCH -q public       # QOS
#SBATCH -o  /scratch/eleiterw/AppliedProject/outerr/qc_filter_run.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e  /scratch/eleiterw/AppliedProject/outerr/qc_filter_run.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

while getopts 'i:s:p:c:o:r:v:t:' OPTION; do
	case "$OPTION" in
		i)
			imputedBed="$OPTARG"
			;;
		s)
			subjectsList="$OPTARG"
			;;
		p)
			phenoFile="$OPTARG"
			;;
		v)
			inversionRegion="$OPTARG"
			;;
		c)
			covarFile="$OPTARG"
			;;
		o)
			outputFile="$OPTARG"
			;;
		r)
			outputResults="$OPTARG"
			;;
		t)
			tempDir="$OPTARG"
			;;
		?)
			echo "script usage: -i <bedFile> -p <phenoFile> -c <covarFile> -o <outputFile>"
			exit 1
			;;
		esac
	done
shift "$(($OPTIND -1))"

echo "Input Parameters:\nImputed bed: ${imputedBed}\nSubjects list: ${subjectsList}\nPhenotype file: ${phenoFile}\nInversion region: ${inversionRegion}\nCovariate file: ${covarFile}\nOutput file: ${outputFile}\nOutput results: ${outputResults}\nTemporary directory: ${tempDir}\n"

# Always purge modules to ensure consistent environments
module purge

#Load plink 1.90
module load plink/1.90

#Set working directory to a temp directory
echo "Setting dir to ${tempDir}/$SLURM_JOB_ID\n"
cd ${tempDir}
mkdir $SLURM_JOB_ID
cd $SLURM_JOB_ID

#Create new bed set with phenotype information from input bed and phenotype files
echo "Creating phenotype bed\n"
plink --bfile ${imputedBed} --allow-no-sex --pheno ${phenoFile} --make-bed --out imputedWithPheno

#Start filtering of phenotype file
#Filters subjects by subjectsList
#Starts with a genotype missingness by SNP (--geno) then by individual (--mind) filter at 0.2, perform sex check, filter by milar allele freq at 0.01
echo "filtering genootype missingness at 0.2 and MAF at 0.01\n"
plink --bfile imputedWithPheno  --allow-no-sex --keep ${subjectsList} --geno 0.2 --mind 0.2 --maf 0.01 --make-bed --out filtered_temp
#Repeats both  genotype missingness at 0.02
echo "filtering genotype missingness at 0.02\n"
plink --bfile filtered_temp --allow-no-sex  --geno 0.02 --mind 0.02 --make-bed --out filtered_temp_2
#Delete temporary bed set b/t 0.2 and 0.02
echo "deleting bed files\n"
rm filtered_temp.bed
rm filtered_temp.bim
rm filtered_temp.fam
#Filter controls by SNP at HWE p < 1e-6
echo "controls HWE by SNP at p < 1e-6\n"
plink --bfile filtered_temp_2  --allow-no-sex --hwe 1e-6 midp --filter-controls --make-bed --out filtered-controls
#Filter cases by SNP at HWE p < 1e-10	
echo "case HWE by SNP at p < 1e-10\n"
plink --bfile filtered_temp_2  --allow-no-sex --hwe 1e-10 midp --filter-cases --make-bed --out filtered-cases
#Remove the temporary set 2
echo "deleting temp bed files\n"
rm filtered_temp_2.bed
rm filtered_temp_2.bim
rm filtered_temp_2.fam
#Merge the case and controls into one
echo "merging separated cases and controls\n"
plink --bfile filtered-controls  --allow-no-sex --bmerge filtered-cases.bed filtered-cases.bim filtered-cases.fam --out hwe_filtered
#remove the filtered controls and cases
echo "deleting temp bed files"
rm filtered-controls.bed
rm filtered-controls.bim
rm filtered-controls.fam
rm filtered-cases.bed
rm filtered-cases.bim
rm filtered-cases.fam

#This prunes highly correlated SNPs and filters out regions with high inversion rates
echo "excluding highly inverted region and pruning highly correlated SNPs\n"
plink --bfile hwe_filtered --allow-no-sex  --exclude ${inversionRegion} --range --indep-pairwise 50 5 0.2 --out indepSNP

#Keep the independent SNPs, getting rid of highly correlated ones
echo "filtering and making updated bed file from prune output\n"
plink --bfile hwe_filtered --allow-no-sex  --exclude indepSNP.prune.out --make-bed -out ${outputFile} 

#Save minor allele frequencies of final set of variants
echo "saving minor allele frequencies of final set"
plink --bfile ${outputFile}  --allow-no-sex --freq --out alleleFreq

#Run the logistic regression model on the previous output file after filtering, with the covariate file input and covariate information hidden
echo "running general modeling command\n"
plink  --bfile ${outputFile}  --allow-no-sex --model  --ci 0.95 --allow-no-sex --pheno ${phenoFile} --covar ${covarFile} --hide-covar --out ${outputResults}
echo "running lofistic regression model\n"
plink  --bfile ${outputFile}  --allow-no-sex --logistic  --ci 0.95 --allow-no-sex --pheno ${phenoFile} --covar ${covarFile} --hide-covar --out ${outputResults}
