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
    group_by(gender) %>%
    mutate(retention_rate = learners_active / first(learners_active)) %>%
    ungroup()
    
  # Cache the final joined data for the report
  cache("gender_analysis_data")
    
  # Note: This object will be cached and available for the R Markdown report
}
