library(here)
library(tidyverse)

### Base Model ###
# Load the national panel
filtered_low_income <- read_csv(here("data", "filtered_low_income.csv"))

# Estimate the Difference-in-Differences model
did_model <- lm(poverty_rate ~ treated * post_2016, data = filtered_low_income)
summary(did_model)

saveRDS(did_model, here("models", "did_model.rds"))

# Intercept = 11.82
# During the pre-treatment period (2007–2015), the expected baseline LIM-AT rate for children in two-parent families 
# was 11.82% 

# treated = 30.01
# Prior to the 2016 policy reform, there was a severe structural disparity. The expected LIM-AT rate for children in 
# lone-parent families was 30.01 percentage points higher than that of two-parent families (p < 0.001).

# post_2016 = -3.4556
# This isolates the baseline time trend and directly answers RQ2. Following the implementation of the CCB in 2016, the 
# LIM-AT rate for two-parent families decreased by 3.46%, which is statistically significant (p = 0.0201).  

# Interaction effect (treated:post_2016 = -3.8333)
# This is the Difference-in-Differences estimator, addressing RQ3. It indicates that the CCB reform is associated with 
# an additional 3.83% reduction in the LIM-AT rate specifically for lone-parent families, over and above the baseline 
# trend observed in two-parent families. This confirms that the income-tested design of the CCB exerted a stronger 
# poverty-reduction effect on the structurally lower-income group.

# R-squared = 0.9626
# This means that 96.26% of the variance is explained by the model.

### CERB Model ###
# Add a dummy variable for the pandemic anomaly (2020 and 2021)
filtered_low_income_cerb <- filtered_low_income |> 
  mutate(cerb = if_else(year %in% c(2020, 2021), 1, 0))

# Re-estimate the DiD model including the new shock variable (CERB)
did_model_cerb <- lm(poverty_rate ~ treated * post_2016 + cerb, data = filtered_low_income_cerb)
summary(did_model_cerb)

saveRDS(did_model_cerb, here("models", "did_model_cerb.rds"))

### Provincial Model ###
# Load the provincial dataset
filtered_low_income_province <- read_csv(here("data", "filtered_low_income_province.csv"))

# Set Quebec as the reference category for province
filtered_low_income_province_cerb <- filtered_low_income_province |>
  mutate(
    cerb = if_else(year %in% c(2020, 2021), 1, 0),
    province = relevel(factor(province), ref = "Quebec")
  )

# Estimate the Provincial Fixed Effects Model (Quebec as reference)
#did_model_provincial <- lm(poverty_rate ~ treated * post_2016 + cerb + province, data = filtered_low_income_province_cerb)
did_model_provincial <- lm(poverty_rate ~ treated * post_2016 + cerb + treated * province, data = filtered_low_income_province_cerb)

summary(did_model_provincial)

saveRDS(did_model_provincial, here("models", "did_model_provincial.rds"))