# Downloads Statistics Canada Table 11-10-0135-01
# Source: https://www150.statcan.gc.ca/t1/tbl1/en/dtbl/11-10-0135-01

# Uses the {cansim} package to retrieve the table programmatically
# Run once to save the raw data locally before cleaning
if (!requireNamespace("cansim", quietly = TRUE)) {
  install.packages("cansim")
}
library(cansim)
library(here)

# Download table 11-10-0135-01 from Statistics Canada
low_income <- get_cansim("11-10-0135-01")

# Save raw file
write.csv(low_income, here("data", "low_income.csv"), row.names = FALSE)