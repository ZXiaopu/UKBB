library(tidyr)
library(readr)
library(dplyr)

args <- commandArgs(T)
traitfile <- args[1]
traitname <- args[2]

output <- list()

for (chr in c(1:22)){
    res <- read_delim(paste0(traitfile, "/", chr, "/", traitname, "_trait.res.regenie.gz")) %>%
        filter(A1FREQ > 0.05 & A1FREQ < 0.95)
    output[[chr]] <- res
}

output_regenie <- bind_rows(output)

gz <- gzfile(paste0(traitfile,"_regenie_result_allchr.gz"), "w")
write.csv(output_regenie, gz)
close(gz)
