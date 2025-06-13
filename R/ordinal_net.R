library(MASS)
library(emmeans)
library(detectseparation)
library(logistf)
library(dplyr)
library(detectseparation)
library(glmnet)
library(ordinalNet)

accident_severity_variables <- read.csv("C:/Users/Gem/OneDrive/Documents/Portfolio/accident_severity_variables.csv", header = TRUE, stringsAsFactors = FALSE)

categorical_vars <- c("casualty_home_area_type", "day_of_week", "first_road_class", "road_type", 
                      "junction_detail", "junction_control", "light_conditions", "vehicle_type", 
                      "sex_of_driver", "weather_conditions")

for (var in categorical_vars) {
  accident_severity_variables[[var]] <- factor(accident_severity_variables[[var]])
}

# Convert numeric 1, 2, 3 to ordered factor with labels
accident_severity_variables$accident_severity <- factor(
  accident_severity_variables$accident_severity,
  levels = c(1, 2, 3),
  labels = c("fatal", "serious", "slight"),
  ordered = TRUE
)

# Sample rows for faster modeling
set.seed(123)  # for reproducibility
sample_indices <- sample(nrow(accident_severity_variables), 1500)
accident_sample <- accident_severity_variables[sample_indices, ]


# Create main effects for everything, plus pairwise interactions only among selected vars

X <- model.matrix(~~ (speed_limit + road_type + age_of_driver + light_conditions + weather_conditions)^2 + 
                    sex_of_driver + junction_detail + road_surface_conditions + age_of_vehicle + 
                    junction_control + casualty_home_area_type + first_road_class + vehicle_type + day_of_week,
                  data = accident_sample
                  
)


dim(X)


y <- accident_sample$accident_severity

# Fit penalized ordinal regression (elastic net)
fit_ordinalnet <- ordinalNet(
  x = X, 
  y = y,    
  family = "cumulative", 
  link = "logit",
  lambdaVals = c(0.01),
  alpha = 0.5,      # elastic net mixing parameter
  penaltyFactors = NULL # equal penalty on all variables
)

# View the coefficients with:
print(coef(fit_ordinalnet))


# Extract coefficients as a named vector
coefs <- coef(fit_ordinalnet)

# Convert to a tidy dataframe
coef_df <- data.frame(
  term = names(coefs),
  estimate = as.numeric(coefs),
  row.names = NULL
)

# Save to CSV
write.csv(coef_df, "C:/Users/Gem/OneDrive/Documents/Portfolio/coef_df.csv", row.names = FALSE)



