# MAS8600 Learning Analytics Project: Cyber Security MOOC

## Description
This project investigates learner engagement and retention patterns across seven runs of the Newcastle University MOOC *"Cyber Security: Safety at Home, Online, and in Life."* Using the CRISP-DM framework, the analysis explores overall retention trends (Cycle 1) and the impact of learner demographics on disengagement (Cycle 2). The project is built using `ProjectTemplate` to ensure reproducibility and follows best practices in data munging and visualization.

## Directory Map
- **reports/Analysis_Report.Rmd**: The main R Markdown file containing the analysis and findings.
- **cache/**: Contains cached data objects (`weekly_engagement`, `gender_analysis_data`, etc.) to speed up report generation.
- **config/**: Contains `global.dcf` for project configuration and package management.
- **data/**: Contains the raw FutureLearn MOOC datasets (CSV files).
- **munge/**: Contains R scripts (01-04) for data cleaning, transformation, and feature engineering.
- **renv.lock**: The renv lockfile ensuring consistent package versions.
- **git_log.txt**: A record of the project's version control history.
- **MAS8600_Project.Rproj**: RStudio project file for easy loading.

## Project Setup Instructions
1. Ensure you have R and RStudio installed.
2. Open the `MAS8600_Project.Rproj` file in RStudio.
3. The project uses `renv` for dependency management. If prompted, run `renv::restore()` to install the required packages.
4. Ensure the raw data files are located in the `data/` directory.

## Project Execution Instructions
1. Open `reports/Analysis_Report.Rmd` in RStudio.
2. Click the **Knit** button to generate the final report (Word document).
3. Alternatively, to load the preprocessed data into your R environment for exploration, run:
   ```r
   library(ProjectTemplate)
   load.project()
   ```
   Note: `munging` is set to `FALSE` in `config/global.dcf` by default to use the cached data. To re-run the preprocessing scripts, set `munging: TRUE` and run `load.project()`.
