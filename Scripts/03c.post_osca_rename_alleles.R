library(tidyr)
library(dplyr)
library(readr)

args <- commandArgs(T)
trait <- args[1]

process <- function(method){
    vGWAS <- rbind(read_delim(paste0("/mnt/project/DataAnalysis/05.OSCA/", trait, "/", trait, "_", method, "_arrayedSNPs")),
                   read_delim(paste0("/mnt/project/DataAnalysis/05.OSCA/", trait, "/", trait, "_", method, "_genotypedSNPs"))) %>%
        mutate(genotype1=paste0(Chr,":",BP,"_",A1,"_",A2)) %>%
        mutate(genotype2=paste0(Chr,":",BP,"_",A2,"_",A1))
    snplist <- rbind(read_delim("ukb22418_imputed_postQC_EUR_MAF0.05_HWE1e-6_INFO.8.recode.snplist"), col_names=F, delim="\t"),
                     read_delim("ukb22418_genotyped_postQC_EUR_MAF0.05_HWE1e-6_GENO0.05.recode.snplist"), col_names=F, delim="\t"))

    vGWAS.geno1 <- vGWAS %>% filter(genotype1 %in% snplist$X2) %>% mutate(ID=genotype1) %>% select(-genotype1, -genotype2)
    vGWAS.geno2 <- vGWAS %>% filter(genotype2 %in% snplist$X2) %>% mutate(ID=genotype2) %>% select(-genotype1, -genotype2)

    vGWASres <- rbind(vGWAS.geno1, vGWAS.geno2)
    
    vGWASres1 <- vGWASres %>% filter(p<5e-8)

    write.table(vGWASres1, file = paste0(trait, "_", method, "_vGWAS_filterRes_5e-8.txt"), col=T, row=F, sep="\t", quote=F)
    system(paste0("dx upload ", trait,"_",method, "* --path vQTL:/DataAnalysis/05.OSCA/", trait, "/"))
}

process("BF")
process("SVLM")
process("DRM")
