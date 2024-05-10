library(tidyr)
library(dplyr)
library(ukbtools)
library(lme4)

args <- commandArgs(trailingOnly = T)
class <- args[1]
trait <- args[2]
instance <- args[3]

post.qc.sample <- read.table("/mnt/project/DataAnalysis/01.GenotypeProcessing/PostQC/UKB.postQC.EUR.keep") # removed samples with "minus eid" 
relatedness <- read.table("/mnt/project/Bulk/Genotype Results/Genotype_calls/ukb_rel.dat", header = T)
covariates1 <- read.csv("/mnt/project/DataAnalysis/03.Covariates/Covariates_age_sex_pc.csv", header = T) 
covariates2 <- read.csv("/mnt/project/DataAnalysis/03.Covariates/Covariates_center.csv", header = T)
covariates3 <- read.csv("/mnt/project/DataAnalysis/QTLs_PositiveControl/BMI_instance2/BMI_instance2.csv", header = T)
covariates_noBMI <- merge(covariates1, covariates2, by.x="eid") %>% separate(p22000, sep="_", into=c("array","array_id"))
covariates_withBMI <- merge(covariates3, covariates_noBMI, by.x="eid") 

trait.df <- read.csv(paste0(trait, "_raw.csv")) %>% 
                    filter(eid %in% post.qc.sample$V1) %>% na.omit()

colnames(trait.df) <- c("eid", "trait")
trait.df <- trait.df %>% filter(trait > (mean(trait) - 5*sd(trait)) | 
                                trait < (mean(trait) + 5*sd(trait)))

remove.id <- ukb_gen_samples_to_remove(relatedness, trait.df$eid, cutoff=0.044)
trait.keep <- trait.df %>% filter(!(eid %in% remove.id))

message(paste0(length(remove.id), " samples are removed of trait ", trait))

trait.keep1 <- merge(trait.keep, covariates_noBMI, by.x="eid")
trait.keep2 <- merge(trait.keep, covariates_withBMI, by.x="eid")

model <- paste0("trait ~ (1|array) + (1|array_id) + p31 + p21003_i", instance, " + (1|p54_i", instance,") + ", paste0("p22009_a", c(1:20), collapse=" + "))
model.adjBMI <- paste0("trait ~ (1|array) + (1|array_id) + p31 + p21003_i", instance, " + p21001_i", instance, " + (1|p54_i", instance,") + ", paste0("p22009_a", c(1:20), collapse=" + "))
trait.keep1$trait.res <- residuals(lmer(model, data = trait.keep1))
trait.keep2$trait.res.adjBMI <- residuals(lmer(model.adjBMI, data = trait.keep2))

trait.keep <- trait.keep1 %>% mutate(FID = eid, IID = eid) %>% select(FID, IID, trait.res)
trait.keep.adjBMI <- trait.keep2 %>% mutate(FID = eid, IID = eid) %>% select(FID, IID, trait.res.adjBMI)
keep.id <- trait.keep$IID
keep.id.adjBMI <- trait.keep.adjBMI$IID

write.table(trait.keep, file = paste0(trait, ".remove.related.txt"), col=T, row=F, sep="\t", quote=F)
write.table(trait.keep.adjBMI, file = paste0(trait, ".adjBMI.remove.related.txt"), col=T, row=F, sep="\t", quote=F)
write.table(keep.id, file = paste0(trait, ".keep.sampleid"), col=F, row=F, sep=",", quote=F)
write.table(keep.id.adjBMI, file = paste0(trait, ".adjBMI.keep.sampleid"), col=F, row=F, sep=",", quote=F)

system(paste0("dx upload ", trait, ".remove.related.txt --path vQTL:/DataAnalysis/02.PhenotypeProcessing/", class, "/ --brief"))
system(paste0("dx upload ", trait, ".adjBMI.remove.related.txt --path vQTL:/DataAnalysis/02.PhenotypeProcessing/", class, "/ --brief"))
system(paste0("dx upload ", trait, ".keep.sampleid --path vQTL:/DataAnalysis/02.PhenotypeProcessing/", class, "/ --brief"))
system(paste0("dx upload ", trait, ".adjBMI.keep.sampleid --path vQTL:/DataAnalysis/02.PhenotypeProcessing/", class, "/ --brief"))
