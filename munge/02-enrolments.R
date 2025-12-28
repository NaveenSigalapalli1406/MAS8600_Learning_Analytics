# munge/02-enrolments.R
# Clean and prepare enrolment data using dplyr
# This script standardizes demographics and derives completion status

# Initialize a list to store processed data for each run
enrolments_list <- list()

# Process enrolment data across all 7 runs using dplyr
for(run_num in 1:7) {
  # Construct the object name as loaded by ProjectTemplate
  dataset_name <- paste0("cyber.security.", run_num, "_enrolments")
  
  if(exists(dataset_name)) {
    # Get the dataset and process using dplyr pipes
    df_processed <- get(dataset_name) %>%
      mutate(
        run_id = run_num,
        # Convert enrolment date to Date object
        enrolled_at = as.Date(enrolled_at),
        # Derive completion status from fully_participated_at column
        # A non-missing value in fully_participated_at indicates the learner completed the course
        is_completed = if_else(!is.na(fully_participated_at), "Completed", "Not Completed"),
        # Standardize missing demographic values
        country = if_else(is.na(country) | country == "Unknown", "Unknown", country),
        age_range = if_else(is.na(age_range) | age_range == "Unknown", "Unknown", age_range),
        # Handle gender column as mentioned in the report
        gender = if_else(is.na(gender) | gender == "Unknown", "Unknown", gender)
      ) %>%
      # Select only the columns needed for analysis to save memory
      select(learner_id, run_id, enrolled_at, is_completed, country, age_range, gender)
    
    # Store in list
    enrolments_list[[run_num]] <- df_processed
  }
}

# Combine all runs into a single master enrolments data frame
enrolments_clean <- bind_rows(enrolments_list)

# Clean up temporary list
rm(enrolments_list)
