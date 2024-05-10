#!/bin/bash

trait=$1
threshold=$2

if [ -f /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_regenie_${threshold}_allchr.jma.cojo ] &&
   [ -f /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_BF_${threshold}_allchr.jma.cojo ];
then
    cp title ${trait}_${threshold}_regenie_BF_LD_input_SNPs
    awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,$8,"regenie"}' /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_regenie_${threshold}_allchr.jma.cojo | grep -v SNP >> ${trait}_${threshold}_regenie_BF_LD_input_SNPs
    awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,$8,"BF"}' /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_BF_${threshold}_allchr.jma.cojo | grep -v SNP >> ${trait}_${threshold}_regenie_BF_LD_input_SNPs
fi


if [ -f /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_regenie_${threshold}_allchr.jma.cojo ] &&
   [ -f /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_DRM_${threshold}_allchr.jma.cojo ];
then
    cp title ${trait}_${threshold}_regenie_DRM_LD_input_SNPs
    awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,$8,"regenie"}' /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_regenie_${threshold}_allchr.jma.cojo | grep -v SNP >> ${trait}_${threshold}_regenie_DRM_LD_input_SNPs
    awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,$8,"DRM"}' /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_DRM_${threshold}_allchr.jma.cojo | grep -v SNP >> ${trait}_${threshold}_regenie_DRM_LD_input_SNPs
fi


if [ -f /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_regenie_${threshold}_allchr.jma.cojo ] &&
   [ -f /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_SVLM_${threshold}_allchr.jma.cojo ];
then
    cp title ${trait}_${threshold}_regenie_SVLM_LD_input_SNPs
    awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,$8,"regenie"}' /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_regenie_${threshold}_allchr.jma.cojo | grep -v SNP >> ${trait}_${threshold}_regenie_SVLM_LD_input_SNPs
    awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,$8,"SVLM"}' /mnt/project/DataAnalysis/06.SNPresult_QC/COJO/${trait}_SVLM_${threshold}_allchr.jma.cojo | grep -v SNP >> ${trait}_${threshold}_regenie_SVLM_LD_input_SNPs
fi
