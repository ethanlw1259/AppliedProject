
library(dplyr)
library(ggplot2)

# Empty lists to store results
combined_results <- list()
significant_results <- list()

# List of phenotype names
phenotypes <- c('response','remission','wk8Remission','wk8Response','seasonal')

# Loop through phenotypes
for (pheno in phenotypes) {
  # Read MAGMA results
  c2 <- read.table(paste0('/scratch/eleiterw/AppliedProject/scripts/magma/results/', pheno, '.c2.results.gsa.out'), header = TRUE)
  c5 <- read.table(paste0('/scratch/eleiterw/AppliedProject/scripts/magma/results/', pheno, '.c5.results.gsa.out'), header = TRUE)
  c7 <- read.table(paste0('/scratch/eleiterw/AppliedProject/scripts/magma/results/', pheno, '.c7.results.gsa.out'), header = TRUE)
  
  # Add source collection labels
  c2$collection <- "C2"
  c5$collection <- "C5"
  c7$collection <- "C7"
  
  # Combine all gene sets
  all_sets <- dplyr::bind_rows(c2, c5, c7)
  
  # Add FDR-corrected p-values
  all_sets$FDR <- p.adjust(all_sets$P, method = "BH")
  
  # Filter and sort by FDR
  sig_sets <- all_sets %>%
    dplyr::filter(FDR < 0.05) %>%
    dplyr::arrange(FDR)
  
  # Save results
  combined_results[[pheno]] <- all_sets
  significant_results[[pheno]] <- sig_sets
  
  # Clean up
  rm(c2, c5, c7)
  
  p <- ggplot(all_sets, aes(x = reorder(VARIABLE, -FDR), y = -log10(FDR))) +
    geom_col(fill = "darkred") +
    coord_flip() +
    labs(title = paste0("Significant Gene Sets: Seasonal Pattern ",pheno), x = "Gene Set", y = "-log10(FDR)") +
    theme_minimal(base_size = 12)
  
  print(p)
}
