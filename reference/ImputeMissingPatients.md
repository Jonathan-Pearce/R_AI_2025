# Ensure all sample patients are present and impute missing values

Merge `dt` with a sample of patient IDs and replace NA values in the
specified columns with a provided imputation value.

## Usage

``` r
ImputeMissingPatients(dt, dt_sample, var_to_impute, impute_value)
```

## Arguments

- dt:

  A data.table with patient-level variables including `ptid`.

- dt_sample:

  A data.table (or data.frame) containing the set of patient IDs to
  keep.

- var_to_impute:

  Character vector of column names in `dt` to impute.

- impute_value:

  A scalar value used to replace NA in `var_to_impute`.

## Value

A data.table containing all patient IDs from `dt_sample` and columns
from `dt` with missing values imputed.

## Examples

``` r
if (FALSE) { # \dontrun{
ImputeMissingPatients(patient_vals_dt, sample_dt, "age", impute_value = -1)
} # }
```
