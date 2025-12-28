# munge/01-engagement.R
# Prepare weekly engagement metrics using dplyr
# This script aggregates step activity into weekly engagement rates per learner

# Initialize a list to store processed data for each run
engagement_list <- list()

# Process engagement data across all 7 runs using dplyr
for(run_num in 1:7) {
  # Construct the object name as loaded by ProjectTemplate
  dataset_name <- paste0("cyber.security.", run_num, "_step.activity")
  
  if(exists(dataset_name)) {
    # Get the dataset and process using dplyr pipes
    df_raw <- get(dataset_name)
    
    # Defensive check: Ensure the week_number column exists
    if("week_number" %in% colnames(df_raw)) {
      df_processed <- df_raw %>%
        # Add run identifier
        mutate(run_id = run_num) %>%
        # Determine if a learner was engaged in a step (either visited or completed)
        mutate(is_engaged = !is.na(first_visited_at) | !is.na(last_completed_at)) %>%
        # Group by learner and week to calculate engagement metrics
        # Note: We use the 'week_number' column from raw data but rename to 'week' for consistency
        group_by(learner_id, run_id, week = week_number) %>%
        summarise(
          steps_engaged = sum(is_engaged, na.rm = TRUE),
          steps_available = n(),
          .groups = "drop"
        ) %>%
        # Calculate the engagement rate for the week
        mutate(engagement_rate = steps_engaged / steps_available)
      
      # Store in list
      engagement_list[[run_num]] <- df_processed
    }
  }
}

# Combine all runs into a single master engagement data frame
weekly_engagement <- bind_rows(engagement_list)

# Cache the processed data for efficiency and reproducibility
cache("weekly_engagement")

# Clean up temporary list
rm(engagement_list)
