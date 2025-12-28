# munge/04-final_data.R
# Final data preparation for Cycle 2 analysis
# This script joins engagement data with demographic data.
# Note: This script runs during the general munging phase but prepares data 
# specifically for the demographic investigations in CRISP-DM Cycle 2.

if(exists("weekly_engagement") && exists("enrolments_clean")) {
  
  # Join engagement with enrolments for demographic analysis
  # We use left_join to avoid bias; learners without demographics are kept as 'Unknown'
  gender_analysis_data <- weekly_engagement %>%
    left_join(enrolments_clean, by = c("learner_id", "run_id")) %>%
    # Filter out Unknown gender for clearer comparison in the report visualizations
    # This filtering is performed here to keep the R Markdown code focused on analysis
    filter(gender %in% c("male", "female", "other")) %>%
    group_by(week, gender) %>%
    summarise(
      learners_active = n_distinct(learner_id),
      .groups = "drop"
    ) %>%
    # Ensure data is sorted by week before calculating cohort size
    arrange(gender, week) %>%
    group_by(gender) %>%
    mutate(
      # Initial cohort size (Week 1)
      cohort_size = first(learners_active),
      # Retention rate: current active learners / learners active in Week 1
      retention_rate = learners_active / cohort_size
    ) %>%
    ungroup()
    
  # Cache the final joined data for the report
  cache("gender_analysis_data")
  
  # Prepare Age Range analysis data
  age_analysis_data <- weekly_engagement %>%
    left_join(enrolments_clean, by = c("learner_id", "run_id")) %>%
    # Filter out Unknown age for clearer comparison
    filter(age_range != "Unknown") %>%
    group_by(week, age_range) %>%
    summarise(
      learners_active = n_distinct(learner_id),
      .groups = "drop"
    ) %>%
    arrange(age_range, week) %>%
    group_by(age_range) %>%
    mutate(
      cohort_size = first(learners_active),
      retention_rate = learners_active / cohort_size
    ) %>%
    ungroup()
    
  cache("age_analysis_data")
}
