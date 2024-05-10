#!/bin/bash

trait=${1}
LDinput=`ls ${trait}*_LD_input_SNPs`

for file in ${LDinput}
do
    chrlist=`awk 'BEGIN{FS="\t"}{print $1}' ${file} | grep -v CHR | sort | uniq -c | awk 'BEGIN{FS=" "}{if($1>1) print $2}'`
    linenum=`awk 'BEGIN{FS="\t"}{print $1}' ${file} | grep -v CHR | sort | uniq -c | awk 'BEGIN{FS=" "}{if($1>1) print $2}' |wc -l`
    if [ ${linenum} -gt 0 ];
    then
        for c in ${chrlist};
        do
        /opt/notebooks/software/plink/plink \
        --bfile /mnt/project/DataAnalysis/01.GenotypeProcessing/ProcessedGenomeData/MRI_DXA_Genome_arrayed_imputed_c${c} \
        --keep /mnt/project/DataAnalysis/05.OSCA/${trait}/${trait}_remove_related_oscainput.oii \
        --clump ${file} \
        --clump-r2 0.2 \
        --clump-kb 500 \
        --out ${file}_c${c}
        cat ${file}_c${c}.clumped >> ${file}.allSNPs.clumped
        done
    fi
done
