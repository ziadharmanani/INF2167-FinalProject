# Exploratory data analysis: produces the two figures used in the proposal.

library(tidyverse)
library(ggplot2)
library(here)

cleaned_low_income <- read_csv(here("data", "cleaned_low_income.csv"))
low_income <- read_csv(here("data", "low_income.csv"))

# Figure 1: National LIM-AT trends by group, 2007–2024
figure1 <- cleaned_low_income |>
  filter(
    geo == "Canada",
    statistics == "Percentage of persons in low income",
    low_income_lines == "Low income measure after tax" 
  ) |>
  filter(
    persons_in_low_income %in% c(
      "Non-seniors not in an economic family", 
      "Persons under 18 years in couple families with children", 
      "Persons under 18 years in one-parent families where the parent is a woman+"
    )
  ) |>
  ggplot(aes(x = ref_date, y = value, colour = persons_in_low_income)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2) +
  labs(
    title = "LIM-AT Rates Change by Group, Canada 2007 to 2024",
    x = NULL,
    y = "LIM-AT Rate (%)",
    colour  = "Demographic Group",
    caption = "Source: Statistics Canada, Table 11-10-0135-01"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14),
    legend.position = "bottom",
    legend.direction = "vertical"
  )

print(figure1)

# Figure 2: Provincial LIM-AT rates for lone-parent children, 2024
provinces <- c(
  "Newfoundland and Labrador", "Prince Edward Island",
  "Nova Scotia", "New Brunswick", "Quebec", "Ontario",
  "Manitoba", "Saskatchewan", "Alberta", "British Columbia"
)

figure2 <- cleaned_low_income |>
  filter(
    geo %in% provinces,
    low_income_lines == "Low income measure after tax",
    statistics == "Percentage of persons in low income",
    persons_in_low_income == "Persons under 18 years in one-parent families where the parent is a woman+",
    ref_date == 2024
  ) |>
  mutate(value = as.numeric(value)) |>
  filter(!is.na(value)) |>
  ggplot(aes(x = reorder(geo, value), y = value)) +
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

# Figure 3
figure3 <- cleaned_low_income |>
  ggplot(aes(x = persons_in_low_income, y = value)) + 
  geom_col(fill = "orangered") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(
    x = "Demographic Group", 
    y = "Count", 
    title = "Distribution of Demographic Groups"
  )
print(figure3)

names(cleaned_low_income)

ggsave(here("outputs", "national_trends.png"), figure1, width = 9, height = 5)
ggsave(here("outputs", "provincial_lim-at_rates_2024.png"), figure2, width = 9, height = 5)