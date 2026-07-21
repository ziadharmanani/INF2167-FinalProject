# Cleans and prepares the raw Statistics Canada data for analysis.

library(tidyverse)
library(janitor)
library(here)

low_income <- read_csv(here("data", "low_income.csv")) |>
  clean_names()

cleaned_low_income <- low_income |>
  
  mutate(
    across(where(is.character), str_squish),
    ref_date = as.integer(ref_date),
    date = as.Date(date),
    value = suppressWarnings(as.numeric(value))
  )


write_csv(cleaned_low_income, here("data", "cleaned_low_income.csv"))

# Check for NAs in the value column across the different family types
cleaned_low_income |>
  filter(
    low_income_lines == "Low income measure after tax",
    statistics == "Percentage of persons in low income",
    grepl("under 18", persons_in_low_income) # Focus on all child categories
  ) |>
  group_by(persons_in_low_income) |>
  summarize(
    total_years = n_distinct(ref_date),
    missing_values = sum(is.na(value)),
    min_year = min(as.numeric(ref_date), na.rm = TRUE),
    max_year = max(as.numeric(ref_date), na.rm = TRUE)
  )

nrow(cleaned_low_income)