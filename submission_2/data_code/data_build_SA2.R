install.packages("readr")
install.packages("dplyr")
install.packages("tidyverse")


# Define the file path for the specific month and year
ma_path <- "data/input/MA_Cnty_SA_2015_01.csv"

# Read the CSV file
service_area <- read_csv(ma_path,
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
                        ), na = "*")

# Add month and year columns
service_area <- service_area %>%
  mutate(year=2015)%>%
  group_by(state, county) %>%
  fill(fips) %>%
  group_by(contractid) %>%
  fill(plan_type, partial, eghp, org_type, org_name)

# Collapse to contract/fips/year unit of observation
service_year <- service_area %>%
  group_by(contractid, fips) %>%
  mutate(id_count=row_number()) %>%
  filter(id_count==1) %>%
  select(-c(id_count))

## Save th processed 2015 data
write_rds(service_year, "data/output/service_area2.rds")
