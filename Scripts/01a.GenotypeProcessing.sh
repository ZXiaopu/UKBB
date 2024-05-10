#!/bin/bash

chr=${1}
/opt/notebooks/software/plink2/plink2 \
    --bgen /mnt/project/Bulk/Imputation/UKB_imputation_from_genotype/ukb22828_c${chr}_b0_v3.bgen ref-first \
    --sample /mnt/project/Bulk/Imputation/UKB_imputation_from_genotype/ukb22828_c${chr}_b0_v3.sample \
    --extract /mnt/project/Bulk/Imputation/UKB_imputation_from_genotype/chr${chr}_INFO0.8.snplist \
    --keep /mnt/project/DataAnalysis/01.GenotypeProcessing/PostQC/UKB.postQC.EUR.keep \
    --maf 0.05 \
    --hwe 1e-6 \
    --make-bed \
    --out ukb22828_c${chr}_EUR_INFO0.8_MAF0.05_HWE1e-6
