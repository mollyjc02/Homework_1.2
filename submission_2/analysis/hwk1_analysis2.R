if (!require("pacman")) install.packages("pacman")

pacman::p_load(tidyverse, ggplot2, dplyr, lubridate, stringr, readxl, data.table, gdata, scales)


full_ma_data <- readRDS("data/output/plan_data2.rds")
contract_service_area <- readRDS("data/output/service_area2.rds")

# create objects for markdown 
plan_type_table <- full_ma_data %>% group_by(plan_type) %>% 
                    count() %>% arrange(-n)
tot_obs <- as.numeric(count(full_ma_data %>% ungroup()))
plan_type_year1 <- full_ma_data %>% group_by(plan_type) %>% count() %>% 
                    arrange(-n) %>% filter(plan_type!="NA")

final_plans <- full_ma_data %>% 
    filter(snp == "No" & eghp =="No" & 
        (planid < 800 | planid >= 900))

plan_type_year2 <- final_plans %>% group_by(plan_type) %>% count() %>% arrange(-n)

plan_type_enroll <- final_plans %>% group_by(plan_type) %>% summarize(n=n(), enrollment=mean(enrollment, na.rm=TRUE)) %>% arrange(-n)

final_data <- final_plans %>% 
    inner_join(contract_service_area %>% 
                select(contractid, fips, year),
                by=c("contractid", "fips", "year")) %>% 
    filter(!is.na(enrollment))

rm(list=c("full_ma_data", "contract_service_area", "final_data"))
save.image("submission_2/results/hwk1_workspace.Rdata")
