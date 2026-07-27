# Exploratory data analysis

library(tidyverse)
library(ggplot2)
library(here)

cleaned_low_income <- read_csv(here("data", "cleaned_low_income.csv"))
low_income <- read_csv(here("data", "low_income.csv"))

provinces <- c(
  "Newfoundland and Labrador", "Prince Edward Island",
  "Nova Scotia", "New Brunswick", "Quebec", "Ontario",
  "Manitoba", "Saskatchewan", "Alberta", "British Columbia"
)

child_family_types <- c(
  "Persons under 18 years in one-parent families where the parent is a woman+",
  "Persons under 18 years in couple families with children"
)

# Figure 1: National LIM-AT trends by group, 2007-2024
figure1 <- cleaned_low_income |>
  filter(
    geo == "Canada",
    statistics == "Percentage of persons in low income",
    low_income_lines == "Low income measure after tax"
  ) |>
  filter(
    persons_in_low_income %in% c("Non-seniors not in an economic family", child_family_types)
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

# Figure 3: Distribution of LIM-AT rates by group, 2007-2024
figure3 <- cleaned_low_income |>
  filter(
    geo == "Canada",
    statistics == "Percentage of persons in low income",
    low_income_lines == "Low income measure after tax",
    persons_in_low_income %in% c("Non-seniors not in an economic family", child_family_types)
  ) |>
  ggplot(aes(x = persons_in_low_income, y = value)) +
  geom_boxplot(fill = "steelblue", alpha = 0.6) +
  geom_jitter(width = 0.1, alpha = 0.4) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) +
  labs(
    x = NULL,
    y = "LIM-AT Rate (%)",
    title = "Distribution of LIM-AT Rates by Group, 2007-2024",
    caption = "Source: Statistics Canada, Table 11-10-0135-01"
  )

print(figure3)

# Figure 4: Parallel trends check around the 2016 CCB reform
figure4 <- cleaned_low_income |>
  filter(
    geo == "Canada",
    statistics == "Percentage of persons in low income",
    low_income_lines == "Low income measure after tax",
    persons_in_low_income %in% c("Non-seniors not in an economic family", child_family_types),
    ref_date <= 2019
  ) |>
  ggplot(aes(x = ref_date, y = value, colour = persons_in_low_income)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2016, linetype = "dashed", colour = "gray40") +
  annotate("text", x = 2016.1, y = Inf, label = "CCB introduced", vjust = 1.5, hjust = 0, size = 3) +
  labs(
    title = "Parallel Trends Check: LIM-AT Rates Around the 2016 CCB Reform",
    x = NULL,
    y = "LIM-AT Rate (%)",
    colour = "Demographic Group",
    caption = "Source: Statistics Canada, Table 11-10-0135-01"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom", legend.direction = "vertical")

print(figure4)

# Figure 5: Pre and post average comparison
figure5 <- cleaned_low_income |>
  filter(
    geo == "Canada",
    statistics == "Percentage of persons in low income",
    low_income_lines == "Low income measure after tax",
    persons_in_low_income %in% child_family_types,
    ref_date >= 2007, ref_date <= 2024
  ) |>
  mutate(period = if_else(ref_date >= 2016, "Post-CCB (2016-2024)", "Pre-CCB (2007-2015)")) |>
  group_by(persons_in_low_income, period) |>
  summarize(avg_rate = mean(value, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(x = persons_in_low_income, y = avg_rate, fill = period)) +
  geom_col(position = "dodge") +
  labs(
    title = "Average LIM-AT Rates Before vs After the CCB",
    x = NULL,
    y = "Average LIM-AT Rate (%)",
    fill = NULL,
    caption = "Source: Statistics Canada, Table 11-10-0135-01"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))

print(figure5)

# Figure 6: Provincial trends for lone-parent children
figure6 <- cleaned_low_income |>
  filter(
    geo %in% provinces,
    low_income_lines == "Low income measure after tax",
    statistics == "Percentage of persons in low income",
    persons_in_low_income == "Persons under 18 years in one-parent families where the parent is a woman+"
  ) |>
  ggplot(aes(x = ref_date, y = value)) +
  geom_line(colour = "orangered", linewidth = 0.5) +
  geom_vline(xintercept = 2016, linetype = "dashed", colour = "gray50") +
  facet_wrap(~ geo, ncol = 5) +
  theme_minimal(base_size = 9) +
  labs(
    title = "LIM-AT Rates for Lone-Parent Children by Province, 2007-2024",
    x = NULL,
    y = "LIM-AT Rate (%)",
    caption = "Source: Statistics Canada, Table 11-10-0135-01"
  )

print(figure6)

names(cleaned_low_income)

ggsave(here("outputs", "figure1_national_trends.png"), figure1, width = 9, height = 5)
ggsave(here("outputs", "figure2_provincial_lim-at_rates_2024.png"), figure2, width = 9, height = 5)
ggsave(here("outputs", "figure3_rate_distribution_by_group.png"), figure3, width = 8, height = 5)
ggsave(here("outputs", "figure4_parallel_trends_check.png"), figure4, width = 9, height = 5)
ggsave(here("outputs", "figure5_pre_post_average_comparison.png"), figure5, width = 8, height = 5)
ggsave(here("outputs", "figure6_provincial_trends_small_multiples.png"), figure6, width = 10, height = 6)