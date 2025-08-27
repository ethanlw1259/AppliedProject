library(dplyr)

setwd('/scratch/eleiterw/AppliedProject/results/mlFiles')

responseAdditiveMatrix = read.table("additive.response.topmed.rsq30.top1k.raw", header = T)
remissionAdditiveMatrix = read.table("additive.remission.topmed.rsq30.top1k.raw", header = T)
wk8ResponseAdditiveMatrix = read.table("additive.wk8Response.topmed.rsq30.top1k.raw", header = T)
wk8RemissionAdditiveMatrix = read.table("additive.wk8Remission.topmed.rsq30.top1k.raw", header = T)
seasonalAdditiveMatrix = read.table("additive.seasonal.topmed.rsq30.top1k.raw", header = T)

responseDominantMatrix = read.table("dominant.response.topmed.rsq30.top1k.raw", header = T)
remissionDominantMatrix = read.table("dominant.remission.topmed.rsq30.top1k.raw", header = T)
wk8ResponseDominantMatrix = read.table("dominant.wk8Response.topmed.rsq30.top1k.raw", header = T)
wk8RemissionDominantMatrix = read.table("dominant.wk8Remission.topmed.rsq30.top1k.raw", header = T)
seasonalDominantMatrix = read.table("dominant.seasonal.topmed.rsq30.top1k.raw", header = T)

phenoAndCovar=read.table("~/Thesis/OGFiles/phs000670.v1.pht003556.v1.p1.c1.PGRN_AMPS_Subject_Phenotypes.HMB.txt", skip = 10, header = T, sep = '\t')

remissionAdditiveJoined = left_join(remissionAdditiveMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))
responseAdditiveJoined = left_join(responseAdditiveMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))
wk8RemissionAdditiveJoined = left_join(wk8RemissionAdditiveMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))
wk8ResponseAdditiveJoined = left_join(wk8ResponseAdditiveMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))
seasonalAdditiveJoined = left_join(seasonalAdditiveMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))

remissionDominantJoined = left_join(remissionDominantMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))
responseDominantJoined = left_join(responseDominantMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))
wk8RemissionDominantJoined = left_join(wk8RemissionDominantMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))
wk8ResponseDominantJoined = left_join(wk8ResponseDominantMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))
seasonalDominantJoined = left_join(seasonalDominantMatrix, phenoAndCovar, by = c('IID' = 'SUBJID')) %>% select_if(~ !any(is.na(.)))

