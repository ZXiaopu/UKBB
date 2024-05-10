#!/bin/bash

phenotype=${1}
    
## generate the phenotype data for OSCA
/DataAnalysis/02.PhenotypeProcessing/${phenotype}.remove.related.txt
/opt/notebooks/software/osca/osca \
    --efile /mnt/project/DataAnalysis/02.PhenotypeProcessing/MRI/${phenotype}.remove.related.txt \
    --methylation-m \
    --make-bod \
    --out ${phenotype}_remove_related_oscainput

dx mkdir ${phenotype}
dx upload ${phenotype}_remove_related_oscainput* --path "vQTL:/DataAnalysis/05.OSCA/${phenotype}/"
