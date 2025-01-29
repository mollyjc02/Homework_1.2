# File paths for 2015
contract_path <- "data/input/CPSC_Contract_Info_2015_01.csv"
enrollment_path <- "data/input/CPSC_Enrollment_Info_2015_01.csv"

# Read contract information for 2015
contract_info <- read_csv(contract_path,
                          skip = 1,
                          col_names = c("contractid", "planid",
                                        "org_type", "plan_type", "partd", "snp",
                                        "eghp", "org_name",
                                        "org_marketing_name", "plan_name",
                                        "parent_org", "contract_date"),
                          col_types = cols(
                            contractid = col_character(),
                            planid = col_double(),
                            org_type = col_character(),
                            plan_type = col_character(),
                            partd = col_character(),
                            snp = col_character(),
                            eghp = col_character(),
                            org_name = col_character(),
                            org_marketing_name = col_character(),
                            plan_name = col_character(),
                            parent_org = col_character(),
                            contract_date = col_character()
                          ))

# Remove duplicates
contract_info <- contract_info %>%
  group_by(contractid, planid) %>%
  mutate(id_count = row_number()) %>%
  filter(id_count == 1) %>%
  select(-id_count)

# Read enrollment information for 2015
enroll_info <- read_csv(
  enrollment_path,
  skip = 1,
  col_names = c("contractid", "planid", "ssa",
                "fips", "state", "county", "enrollment"),
  col_types = cols(
    contractid = col_character(),
    planid = col_double(),
    ssa = col_double(),
    fips = col_double(),
    state = col_character(),
    county = col_character(),
    enrollment = col_double()
  ),
  na = "*"
)

# Merge contract info with enrollment info
plan_data <- contract_info %>%
  left_join(enroll_info, by = c("contractid", "planid")) %>%
  mutate(year = 2015)

# Fill missing fips codes by state and county
plan_data <- plan_data %>%
  group_by(state, county) %>%
  fill(fips)

# Fill missing plan characteristics by contract and plan ID
plan_data <- plan_data %>%
  group_by(contractid, planid) %>%
  fill(plan_type, partd, snp, eghp, plan_name)

# Fill missing contract characteristics by contract ID
plan_data <- plan_data %>%
  group_by(contractid) %>%
  fill(org_type, org_name, org_marketing_name, parent_org)

# Collapse from monthly data to yearly
plan_year <- plan_data %>%
  group_by(contractid, planid, fips) %>%
  arrange(contractid, planid, fips) %>%
  rename(avg_enrollment = enrollment)

# Save processed data for 2015
write_rds(plan_year, "data/output/ma_data_2015.rds")

glimpse(plan_year)