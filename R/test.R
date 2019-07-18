library(tidyverse)
#library(plyr)
library(PHABMetrics)
fieldandhabitat <- read.csv("data/PSA2013_FieldAndHabitat_RBIND_FILLED.csv")

fieldandhabitat <- fieldandhabitat %>% 
  mutate(
    id = StationCode
  )
fieldandhabitat$id <- fieldandhabitat$StationCode

fieldandhabitat <- fieldandhabitat %>% select(colnames(sampdat))