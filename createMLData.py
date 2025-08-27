import pandas as pd
import re
import numpy as np

def import_summary_stats(filepath):
    sumStats = pd.read_csv(filepath, delim_whitespace=True)
    split = sumStats['SNP'].str.split(':', expand=True)
    sumStats.dropna(subset=['OR', 'STAT', 'P'], inplace=True)
    sumStats['A1'] = split[2]
    sumStats['A2'] = split[3]
    sumStats['ID'] = split[4]
    sumStats["CHR"] = sumStats["CHR"].astype(str)
    sumStats["BP"] = sumStats["BP"].astype(int)
    return sumStats

def import_imputation_stats(filepath):
    imputationStats = pd.read_table(filepath, sep = '|', low_memory=False)
    imputationStats["CHROM"] = imputationStats["CHROM"].astype(str)
    imputationStats["POS"] = imputationStats["POS"].astype(int)
    imputationStats = imputationStats.sort_values(by=['CHROM','POS'])
    imputationStats['ID'] = imputationStats['ID'].map(lambda x: '.' if x == '0' else x)
    return imputationStats

def import_geno_matrix(filepath):
    matrix = pd.read_table(filepath, sep = " ")
    pattern = '_[TCGA]+$'
    columns = matrix.axes[1]
    columns_fixed = columns.str.replace(pat=pattern, repl="", regex = True)
    matrix.columns = columns_fixed
    return matrix

def import_covars(filepath):
    covars=pd.read_csv(filepath, sep = '\t').dropna(axis=1)
    covars['IID'] = covars['IID'].astype(int)
    covars['FID'] = covars['FID'].astype(int)
    return covars
    
def merge_summary_imputation(sumStats, imputationStats):
    merged_df_A1 = sumStats.merge(imputationStats, how="left", left_on=["BP", "A2", "A1", "ID"], right_on=["POS", "REF", "ALT", "ID"])
    merged_df_A1 = merged_df_A1.dropna()
    merged_df_A2 = sumStats.merge(imputationStats, how="left", left_on=["BP", "A1", "A2", "ID"], right_on=["POS", "REF", "ALT", "ID"])
    merged_df_A2 = merged_df_A2.dropna()
    merged_df = pd.concat([merged_df_A2, merged_df_A1])
    merged_df = merged_df.drop_duplicates(subset=["SNP"])
    merged_df = merged_df.sort_values(by=["CHR", "BP"])
    merged_df = merged_df.rename(columns={"NMISS": "N", "R2":"INFO"})
    return merged_df

def merge_matrix_sumimp(matrix, sumimp):
    transposed_df = sumimp[['OR', 'SE', 'STAT', 'P', 'MAF']].transpose()
    transposed_df.columns = transposed_df.iloc[0]
    transposed_df = transposed_df.drop(transposed_df.index[0])
    matching_columns = list(set(matrix.columns) & set(transposed_df.columns))  # The matching columns
    non_matching_columns_a = list(set(matrix.columns) - set(transposed_df.columns))  # The unique columns from 'a'
    # Merge only on matching columns, keeping all rows from 'a' and adding the 9 rows from 'b'
    final_df = pd.concat([matrix, transposed_df[matching_columns]], ignore_index=True)
    # Fill missing values in 'a'-specific columns with 0
    final_df[non_matching_columns_a] = final_df[non_matching_columns_a]
    final_df['IID'] = final_df['IID'].astype(int)
    final_df['FID'] = final_df['FID'].astype(int)
    return final_df

def merge_matsumimp_covars(matsumimp, covars):
    df = matsumimp.merge(covars, how = 'left')
    return df

phenotypes = ['remission', 'response', 'wk8Remission', 'wk8Response', 'seasonal']
final_dfs = {}  # Create a dictionary to store results
#sumStats = import_summary_stats('/scratch/eleiterw/AppliedProject/results/remission_betterAge_oldEigen_complete.assoc.logistic')
#impStats = import_imputation_stats('/scratch/eleiterw/AppliedProject/annotatedBCF/imputationStatistics0.txt')
covars = import_covars('/home/eleiterw/Thesis/analysisFiles/filteredCovarAndPheno.tsv')
wk8remission=pd.read_csv('/home/eleiterw/Thesis/analysisFiles/wk8RemissionPheno.txt', sep = ' ', names = ['IID','FID','wk8remission'])
wk8response=pd.read_csv('/home/eleiterw/Thesis/analysisFiles/wk8ResponsePheno.txt', sep = ' ', names = ['IID','FID','wk8response'])
wk8remission['IID'] = wk8remission['IID'].astype(int)
wk8remission['FID'] = wk8remission['FID'].astype(int)
wk8response['IID'] = wk8response['IID'].astype(int)
wk8response['FID'] = wk8response['FID'].astype(int)
wk8remission['wk8remission'] = wk8remission['wk8remission'].astype(int) - 1
wk8response['wk8response'] = wk8response['wk8response'].astype(int) - 1
covars = covars.merge(wk8remission, on = 'IID', how = 'left')
covars = covars.merge(wk8response, on = 'IID', how = 'left')
#sumimp = merge_summary_imputation(sumStats, impStats)
for pheno in phenotypes:
    matrix = import_geno_matrix(f"/scratch/eleiterw/AppliedProject/results/mlFiles/dominant.{pheno}.topmed.rsq30.interesting.raw")
#    matsumimp = merge_matrix_sumimp(matrix, sumimp)
    final_df= merge_matsumimp_covars(matrix, covars)
    final_dfs[pheno] = final_df
    final_df.to_csv(f'/home/eleiterw/Thesis/analysisFiles/{pheno}.interesting.csv', index=False)