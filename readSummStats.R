setwd('/scratch/eleiterw/AppliedProject/results')
library(qqman)

response = read.table(file='TopMed.Response.OldEigen.assoc.logistic', header = T)
remission = read.table(file='TopMed.Remission.OldEigen.assoc.logistic', header = T)
wk8remission=read.table(file='TopMed.Wk8Remission.OldEigen.assoc.logistic', header = T)
wk8response=read.table(file='TopMed.Wk8Response.OldEigen.assoc.logistic', header = T)
seasonal=read.table(file= 'TopMed.Seasonal.OldEigen.assoc.logistic', header=T)


response = na.omit(response)
remission = na.omit(remission)
wk8remission = na.omit(wk8remission)
wk8response = na.omit(wk8response)
seasonal=na.omit(seasonal)

responseFiltered = response[response$P<0.00009,]
remissionFiltered = remission[remission$P<0.00009,]
wk8RemissionFiltered = wk8remission[wk8remission$P<0.00009,]
wk8ResponseFiltered = wk8response[wk8response$P<0.00009,]
seasonal = wk8response[seasonal$P<0.00009,]


responseFiltered$Analysis = 'Response'
remissionFiltered$Analysis = 'Remission'
wk8RemissionFiltered$Analysis = 'Wk 8 Remission'
wk8ResponseFiltered$Analysis = 'Wk 8 Response'

allCombined = rbind(rbind(responseFiltered, remissionFiltered), rbind(wk8RemissionFiltered, wk8ResponseFiltered))

sigRegionsList = c()
sigRegionsList = c(sigRegionsList, paste0('chr',responseFiltered$CHR, ':', responseFiltered$BP,'-',responseFiltered$BP))
sigRegionsList = c(sigRegionsList, paste0('chr',remissionFiltered$CHR, ':', remissionFiltered$BP,'-',remissionFiltered$BP))
sigRegionsList = c(sigRegionsList, paste0('chr',wk8ResponseFiltered$CHR, ':', wk8ResponseFiltered$BP,'-',wk8ResponseFiltered$BP))
sigRegionsList = c(sigRegionsList, paste0('chr',wk8RemissionFiltered$CHR, ':', wk8RemissionFiltered$BP,'-',wk8RemissionFiltered$BP))

write.table(sigRegionsList, file = "../Imputation/impFilesRsq30/sigRegionsList.txt", row.names = F, col.names = F)

overlapResponseRemission = intersect(responseFiltered$SNP, remissionFiltered$SNP)
overlapWk8ResponseRemission = intersect(wk8ResponseFiltered$SNP, wk8RemissionFiltered$SNP)


#par(mfrow = c(2,2))
manhattan(droppedNA, chr = 'CHR', bp = 'BP', snp = 'SNP', p = 'P')
manhattan(remission, chr = 'CHR', bp = 'BP', snp = 'SNP', p = 'P')
manhattan(wk8remission, chr = 'CHR', bp = 'BP', snp = 'SNP', p = 'P')
manhattan(wk8response, chr = 'CHR', bp = 'BP', snp = 'SNP', p = 'P')
manhattan(seasonal, chr='CHR', bp = 'BP', snp = 'SNP', p = 'P')
