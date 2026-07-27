# Prepares the data for a Difference-in-Differences comparison of the Canada Child.

library(tidyverse)
library(here)

# Load cleaned data
cleaned_low_income <- read_csv(here("data", "cleaned_low_income.csv"))

provinces <- c(
  "Newfoundland and Labrador", "Prince Edward Island", "Nova Scotia", "New Brunswick",
  "Quebec", "Ontario", "Manitoba", "Saskatchewan", "Alberta", "British Columbia"
)

family <- c(
  "Persons under 18 years in one-parent families where the parent is a woman+",
  "Persons under 18 years in couple families with children"
)

# 1. National-level panel: main Difference-in-Differences comparison (RQ1-RQ3)
# Pre-CCB period: 2007-2015
# Post-CCB period: 2016-2024
filtered_low_income <- cleaned_low_income |>
  filter(ref_date >= 2007 & ref_date <= 2024) |>
  filter(
    low_income_lines == "Low income measure after tax", # Keep the LIM-AT measure for different family types
    statistics == "Percentage of persons in low income",
    geo == "Canada",
    persons_in_low_income %in% family
  ) |>
  select(
    year = ref_date,
    family_type = persons_in_low_income,
    poverty_rate = value
  ) |>
  mutate(
    year = as.numeric(year),
    post_2016 = if_else(year >= 2016, 1, 0),
    treated = if_else(
      family_type == "Persons under 18 years in one-parent families where the parent is a woman+",
      1, 0
    )
  ) |>
  filter(!is.na(poverty_rate))

write_csv(filtered_low_income, here("data", "filtered_low_income.csv"))
nrow(filtered_low_income)

# 2. Provincial panel: robustness / extension check
filtered_low_income_province <- cleaned_low_income |>
  filter(ref_date >= 2007 & ref_date <= 2024) |>
  filter(
    low_income_lines == "Low income measure after tax",
    statistics == "Percentage of persons in low income",
    geo %in% provinces,
    persons_in_low_income %in% family
  ) |>
  select(
    year = ref_date,
    province = geo,
    family_type = persons_in_low_income,
    poverty_rate = value
  ) |>
  mutate(
    year = as.numeric(year),
    post_2016 = if_else(year >= 2016, 1, 0),
    treated = if_else(
      family_type == "Persons under 18 years in one-parent families where the parent is a woman+",
      1, 0
    )
  ) |>
  filter(!is.na(poverty_rate))

write_csv(filtered_low_income_province, here("data", "filtered_low_income_province.csv"))
nrow(filtered_low_income_province)

# 3. Benchmark group: adults without children
# Used to visually/statistically check the pre-2016 parallel trends assumption
# discussed in the proposal's "Assumptions & Limitations" section.
benchmark_low_income <- cleaned_low_income |>
  filter(ref_date >= 2007 & ref_date <= 2024) |>
  filter(
    low_income_lines == "Low income measure after tax",
    statistics == "Percentage of persons in low income",
    geo == "Canada",
    persons_in_low_income == "Non-seniors not in an economic family"
  ) |>
  select(
    year = ref_date,
    poverty_rate = value
  ) |>
  mutate(year = as.numeric(year)) |>
  filter(!is.na(poverty_rate))

write_csv(benchmark_low_income, here("data", "benchmark_low_income.csv"))
nrow(benchmark_low_income)