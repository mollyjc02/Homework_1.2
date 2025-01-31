install.packages("readr")
install.packages("dplyr")
install.packages("tidyverse")

library(tidyverse)
library(readr)

# Define the file path for the specific month and year
ma_path <- "data/input/MA_Cnty_SA_2015_01.csv"

# Read the CSV file
service_area <- read_csv(
                ma_path,
                skip = 1,
                col_names = c("contractid", "org_name", "org_type", "plan_type",
                                "partial", "eghp", "ssa", "fips", "county", "state", "notes"),
                col_types = cols(
                contractid = col_character(),
                org_name = col_character(),
                org_type = col_character(),
                plan_type = col_character(),
                partial = col_logical(),
                eghp = col_character(),
                ssa = col_double(),
                fips = col_double(),
                county = col_character(),
                notes = col_character()
                ),
                na = "*")

# Add month and year columns
service_area <- service_area %>%
  mutate(month = "01", year = 2015)

## Fill in missing fips codes (by state and county)
service_area <- service_area %>%
  group_by(state, county) %>%
  fill(fips)

# Fill in missing plan type, org info, partial status, eghp by contract ID
service_area <- service_area %>%
  group_by(contractid) %>%
  fill(plan_type, partial, eghp, org_type, org_name)

## Save th processed 2015 data
write_rds(service_area, "data/output/service_area1.rds")
