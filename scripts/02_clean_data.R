# Cleans and prepares the raw Statistics Canada data for analysis.

library(tidyverse)
library(here)

low_income <- read_csv(here("data", "low_income.csv"))

# Groups of interest
groups <- c(
  "Persons under 18 years in one-parent families where the parent is a woman+",
  "Persons under 18 years in couple families with children",
  "Non-seniors not in an economic family"
)

# Short labels for visualizations
labels <- c(
  "Persons under 18 years in one-parent families where the parent is a woman+" = "Children: Lone-parent",
  "Persons under 18 years in couple families with children" = "Children: Two-parent",
  "Non-seniors not in an economic family" = "Adults: No children (benchmark)"
)

df <- low_income |>
  filter(
    GEO == "Canada",
    `Low income lines` == "Low income measure after tax",
    Statistics == "Percentage of persons in low income",
    `Persons in low income` %in% groups,
    REF_DATE >= 2007
  ) |>
  mutate(
    group = recode(`Persons in low income`, !!!labels),
    value = as.numeric(VALUE),
    year  = as.integer(REF_DATE)
  ) |>
  select(year, group, value) |>
  filter(!is.na(value))

write_csv(df, here("data", "cleaned_low_income.csv"))