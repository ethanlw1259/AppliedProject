# Pharmacogenomics of SSRI Treatment for MDD — MS Applied Project

GWAS and machine learning analysis to identify genomic predictors of SSRI treatment 
response in Major Depressive Disorder. Developed as an MS Applied Project at Arizona 
State University (May 2025).

## Pipeline Overview
A multi-stage workflow combining genotype QC, GWAS, pathway analysis, and ML prediction:

1. **QC & Filtering** — `QC_Filtering_Analysis.sh`, `filterSubjects.sh`, `filterForML.sh`
2. **Genotype Processing** — `plinkAndGeneFilter.sh`, `sortAndIndex.sh`, `calcLD.sh`
3. **Summary Statistics** — `readSummStats.R`, `formatSummStats.ipynb`
4. **MAGMA Gene Analysis** — `formatForMagma.ipynb`, `runAnalysis.sh`, `readMagmaResults.R`
5. **GSEA Pathway Analysis** — `runGSEA.sh`, `reformatBED.ipynb`
6. **ML Data Preparation** — `createMLData.py`, `createMLData.ipynb`, `formatML.R`
7. **ML Training & Tuning** — `runML.ipynb`, `runHyperparam.sh`
8. **Response Analysis** — `runResponseAnalysis.sh`

## Key Results
- Up to 70% accuracy predicting seasonal depression pattern
- 66% accuracy predicting citalopram treatment response

## Tools & Languages
- PLINK, MAGMA, GSEA
- Python, R, Bash | Jupyter Notebooks
- Linux HPC | Conda
