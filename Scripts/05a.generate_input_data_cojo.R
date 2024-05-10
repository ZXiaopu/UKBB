library(readr)
library(tidyr)
library(dplyr)

args <- commandArgs(T)

trait=args[1]
threshold=as.character(args[2])

sample.regenie <- system(paste0("wc -l /mnt/project/DataAnalysis/04.Regenie/", trait, "/", trait, ".keep.sampleid | cut -f1 -d ' '"), intern=TRUE)
sample.osca <- system(paste0("wc -l /mnt/project/DataAnalysis/05.OSCA/", trait, "/", trait, "_remove_related_oscainput.oii | cut -f1 -d ' '"), intern=TRUE)

if(sample.regenie == sample.osca){
    samples <- sample.regenie

    res.regenie <- read_delim(paste0("/mnt/project/DataAnalysis/04.Regenie/", trait, "/", trait, "_GWAS_filterRes_", threshold, ".txt")) %>% 
            mutate(pval=P, N=samples) %>% select(ID, ALLELE0, ALLELE1, A1FREQ, BETA, SE, pval, N)
    colnames(res.regenie) <- c("SNP", "A1", "A2", "freq", "b", "se", "p", "N")
    if(nrow(res.regenie)>1){
        write.table(res.regenie, paste0(trait,"_",threshold, "_regenie.cojo.ma"), col=T, row=F, sep="\t", quote=F)
    }

    res.osca.BF <- read_delim(paste0(trait, "_BF_vGWAS_filterRes_", threshold, ".txt")) %>%
        mutate(N=samples) %>% select(ID, A1, A2, Freq, b, SE, p, N)
    colnames(res.osca.BF) <- c("SNP", "A1", "A2", "freq", "b", "se", "p", "N")
    if(nrow(res.osca.BF)>1){
        write.table(res.osca.BF, paste0(trait, "_", threshold, "_BF.cojo.ma"), col=T, row=F, sep="\t", quote=F)
    }

    res.osca.SVLM<- read_delim(paste0(trait, "_SVLM_vGWAS_filterRes_", threshold, ".txt")) %>%
        mutate(N=samples) %>% select(ID, A1, A2, Freq, b, SE, p, N)
    colnames(res.osca.SVLM) <- c("SNP", "A1", "A2", "freq", "b", "se", "p", "N")
    if(nrow(res.osca.SVLM)>1){
        write.table(res.osca.SVLM, paste0(trait, "_", threshold, "_SVLM.cojo.ma"), col=T, row=F, sep="\t", quote=F)
    }

    res.osca.DRM <- read_delim(paste0(trait, "_DRM_vGWAS_filterRes_", threshold, ".txt")) %>%
        mutate(N=samples) %>% select(ID, A1, A2, Freq, b, SE, p, N)
    colnames(res.osca.DRM) <- c("SNP", "A1", "A2", "freq", "b", "se", "p", "N")
    if(nrow(res.osca.DRM)>1){
        write.table(res.osca.DRM, paste0(trait, "_", threshold, "_DRM.cojo.ma"), col=T, row=F, sep="\t", quote=F)
    }
}

system(paste0("dx upload ",trait,"*ma --path vQTL:/DataAnalysis/06.SNPresult_QC/ --brief"))
