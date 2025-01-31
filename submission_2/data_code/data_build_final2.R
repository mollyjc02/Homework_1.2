if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggplot2, dplyr, lubricate, stringr, readxl, data.table, gdata, scales)

# call each individual script 
source("submission_2/data_code/data_build_plan2.R")
source("submission_2/data_code/data_build_SA2.R")
