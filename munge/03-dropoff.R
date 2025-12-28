# munge/03-dropoff.R
# Prepare drop-off and retention analysis data using dplyr
# This script calculates weekly retention rates and drop-off percentages

# Ensure the dependency from 01-engagement.R exists
if(exists("weekly_engagement")) {
  
  # Calculate weekly summary statistics using dplyr
  dropoff_analysis <- weekly_engagement %>%
    group_by(run_id, week) %>%
    summarise(
      learners_active = n_distinct(learner_id),
      avg_engagement_rate = mean(engagement_rate, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    # Arrange by run and week to ensure correct lag calculations
    arrange(run_id, week) %>%
    # Group by run to calculate retention relative to the start of each run
    group_by(run_id) %>%
    mutate(
      # Retention rate: current active learners / learners active in Week 1
      retention_rate = learners_active / first(learners_active),
      # Week-to-week drop-off: (previous - current) / previous
      prev_learners = lag(learners_active),
      week_to_week_dropoff = (prev_learners - learners_active) / prev_learners
    ) %>%
    # Remove the temporary column
    select(-prev_learners) %>%
    ungroup()
    
  # Cache the analysis results
  cache("dropoff_analysis")
    
  # Note: week_to_week_dropoff will be NA for Week 1 of each run
}
