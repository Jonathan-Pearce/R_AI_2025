# R_AI_2025 — helper utilities for patient-level ETL

This repository is associated with Jonathan Pearce’s R+AI 2025 Conference Presentation.

High-level summary
- Small R utilities (data.table + dplyr) for patient-level ETL: filtering events by date windows, pivoting event-level data to wide patient-level flag/count/value tables, imputing missing patients/values, and normalizing variable names.
- Includes a minimal test for the isLengthNonZero helper (tests/testthat/test-isLengthNonZero.R).

Repository contents (key files)
- helper_functions.R — main helper functions used for pivoting and naming.
- tests/testthat/test-isLengthNonZero.R — unit tests for the isLengthNonZero function.
- README.md — this file.

Function summaries (in helper_functions.R)
- subsetEvents(dt, event_date_var, start_date_var, end_date_var)
  - Filter a data.table of events to rows where event_date_var is between start_date_var and end_date_var (inclusive).

- getDataTimePeriod(dt, dt_date_var, time_period)
  - Wrapper around subsetEvents that uses a two-element time_period object (start, end) to subset dt.

- isLengthNonZero(x)
  - Aggregator that returns 1 if length(x) > 0, otherwise 0. Intended for use as fun.aggregate in dcast to create binary flags.

- getFlags(dt, dt_flag_var, data_type, time_period)
  - Pivot dt to a wide patient-level flag table (ptid ~ dt_flag_var) using isLengthNonZero; then formats column names with data_type/time_period/value-type.

- getCounts(dt, dt_count_var, data_type, time_period, fill_value = NA)
  - Pivot dt to a wide patient-level counts table (ptid ~ dt_count_var) using length as aggregator; then formats names.

- getValues(dt, dt_value_var, dt_name_var, data_type, time_period, date_description = NA, FUN_value = "mean", fill_value = NA)
  - Pivot dt to a wide patient-level aggregated-values table (ptid ~ dt_name_var) applying FUN_value (e.g., mean) to dt_value_var; optional date_description is prepended to the value-type name; then formats names.

- ImputeMissingPatients(dt, dt_sample, var_to_impute, impute_value)
  - Ensures all ptid from dt_sample are present by left-joining and replaces NA in specified columns with impute_value.

- addPrefix(dt, prefix)
  - Prepend prefix_ to all column names except the first (assumed ptid).

- addSuffix(dt, suffix)
  - Append _suffix to all column names except the first.

- formatVariableNames(dt, data_type, time_period, value_type)
  - Convenience: addPrefix(data_type) then addSuffix(time_period without "time_period_") then addSuffix(value_type).

- cleanVarNames(dt)
  - Normalize column names: replace spaces, "/", ".", "-" with underscores and remove parentheses.

Video recording (placeholder)
- A recording of Jonathan Pearce’s R+AI 2025 presentation will be added here after the conference.
- Placeholder link: [Presentation video — coming soon](#)
- When available, replace the placeholder URL with the hosted video URL.

Running tests
- From the project root:
  - Using testthat:
    Rscript -e "testthat::test_dir('tests/testthat')"
  - Or with devtools (if available):
    R -e "devtools::test()"

Notes
- Functions assume a column named `ptid` for patient identifier and rely on data.table semantics. Validate inputs (types and presence of columns) before use in production pipelines.
```// filepath: /workspaces/R_AI_2025/README.md