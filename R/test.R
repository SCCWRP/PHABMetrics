library(tidyverse)
#library(plyr)
library(PHABMetrics)
data <- read.csv("data/PSA2013_FieldAndHabitat_RBIND_FILLED.csv")

data <- data %>% 
  mutate(
    id = StationCode
  )
data$id <- data$StationCode

data <- data %>% select(colnames(sampdat))