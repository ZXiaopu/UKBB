library(tidyr)
library(dplyr)
library(readr)

args <- commandArgs(T)
trait <- args[1]

GWAS <- read_delim(paste0("/mnt/project/DataAnalysis/04.Regenie/", trait, "/", trait, "_regenie_result_allchr.gz")) %>%
    mutate(genotype1=paste0(CHROM,":",GENPOS,"_",ALLELE1,"_",ALLELE0)) %>%
    mutate(genotype2=paste0(CHROM,":",GENPOS,"_",ALLELE0,"_",ALLELE1))
snplist <- read_delim(paste0(trait, ".snplist"), col_names=F, delim="\t")

GWAS.geno1 <- GWAS %>% filter(genotype1 %in% snplist$X1) %>% mutate(ID=genotype1) %>% select(-genotype1, -genotype2)
GWAS.geno2 <- GWAS %>% filter(genotype2 %in% snplist$X1) %>% mutate(ID=genotype2) %>% select(-genotype1, -genotype2)

GWASres <- rbind(GWAS.geno1, GWAS.geno2) %>% mutate(P=10**(-LOG10P))
GWASres1 <- GWASres %>% filter(P<5e-8)

write.table(GWASres1, file = paste0(trait, "_GWAS_filterRes_5e-8.txt"), col=T, row=F, sep="\t", quote=F)
