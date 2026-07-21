# Prepares the data for a Difference-in-Differences comparison of the Canada Child.

library(tidyverse)
library(here)

provinces <- c(
  "Newfoundland and Labrador", "Prince Edward Island", "Nova Scotia", "New Brunswick",
  "Quebec", "Ontario", "Manitoba", "Saskatchewan", "Alberta", "British Columbia"
)

filtered_low_income <- cleaned_low_income |>
  filter(ref_date >= 2007 & ref_date <= 2019) |>
  filter(
    low_income_lines == "Low income measure after tax",
    statistics == "Percentage of persons in low income",
    geo %in% provinces
  ) |>
  filter(
    persons_in_low_income %in% c(
      "Persons under 18 years in one-parent families where the parent is a woman+",
      "Persons under 18 years in couple families with children"
    )
  ) |>
  select(
    year = ref_date,
    province = geo,
    family_type = persons_in_low_income,
    poverty_rate = value
  ) |>
  mutate(
    year = as.numeric(year),
    post_2016 = case_when(
      year >= 2016 ~ 1,
      year < 2016  ~ 0
    ),
    treated = case_when(
      family_type == "Persons under 18 years in one-parent families where the parent is a woman+" ~ 1,
      family_type == "Persons under 18 years in couple families with children" ~ 0
    )
  )

nrow(filtered_low_income)