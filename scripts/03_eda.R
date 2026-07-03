# Exploratory data analysis: produces the two figures used in the proposal.

library(tidyverse)
library(here)

cleaned_low_income <- read_csv(here("data", "cleaned_low_income.csv"))
low_income <- read_csv(here("data", "low_income.csv"))

# Figure 1: National LIM-AT trends by group, 2007–2024
figure1 <- ggplot(cleaned_low_income, aes(x = year, y = value, colour = group)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2) +
  labs(
    title = "LIM-AT Rates Change by Group, Canada 2007 to 2024",
    x = NULL,
    y = "LIM-AT Rate (%)",
    colour  = NULL,
    caption = "Source: Statistics Canada, Table 11-10-0135-01"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14),
    legend.position = "bottom"
  )

print(figure1)

# Figure 2: Provincial LIM-AT rates for lone-parent children, 2024
provinces <- c(
  "Newfoundland and Labrador", "Prince Edward Island",
  "Nova Scotia", "New Brunswick", "Quebec", "Ontario",
  "Manitoba", "Saskatchewan", "Alberta", "British Columbia"
)

figure2 <- low_income |>
  filter(
    GEO %in% provinces,
    `Low income lines` == "Low income measure after tax",
    Statistics == "Percentage of persons in low income",
    `Persons in low income` == "Persons under 18 years in one-parent families where the parent is a woman+",
    REF_DATE == 2024
  ) |>
  mutate(value = as.numeric(VALUE)) |>
  filter(!is.na(value)) |>
  ggplot(aes(x = reorder(GEO, value), y = value)) +
  geom_col(fill = "orangered") +
  coord_flip() +
  labs(
    title = "LIM-AT Rates for Children in Lone-Parent Families per Province, 2024",
    x = NULL,
    y = "LIM-AT Rate (%)",
    caption = "Source: Statistics Canada, Table 11-10-0135-01"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 12))

print(figure2)

ggsave(here("outputs", "national_trends.png"), figure1, width = 9, height = 5)
ggsave(here("outputs", "provincial_lim-at_rates_2024.png"), figure2, width = 9, height = 5)