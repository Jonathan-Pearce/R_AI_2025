# Create patient-level aggregated values wide table

Cast an event-level table to a wide patient-level table of aggregated
values (e.g., mean, median) of `dt_value_var` by `dt_name_var`.

## Usage

``` r
getValues(
  dt,
  dt_value_var,
  dt_name_var,
  data_type,
  time_period,
  date_description = NA,
  FUN_value = "mean",
  fill_value = NA
)
```

## Arguments

- dt:

  A data.table of events containing a `ptid` column.

- dt_value_var:

  A string naming the numeric/value column to aggregate.

- dt_name_var:

  A string naming the column whose unique values become columns.

- data_type:

  A string prefix to add to output variable names.

- time_period:

  A string describing the time period to include in output names.

- date_description:

  Optional string to prepend to the aggregation name (e.g.,
  "first_date").

- FUN_value:

  A string naming the aggregation function to apply (e.g., "mean",
  "median").

- fill_value:

  Value used to fill missing combinations (default NA).

## Value

A data.table with `ptid` and aggregated value columns formatted via
`formatVariableNames`.

## Examples

``` r
if (FALSE) { # \dontrun{
getValues(labs_dt, "value", "lab_name", "labs", "time_period_30d", FUN_value = "mean")
} # }
```
