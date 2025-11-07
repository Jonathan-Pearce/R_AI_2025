# Create patient-level counts wide table

Cast an event-level table to a wide patient-level table of counts of
each value of `dt_count_var`.

## Usage

``` r
getCounts(dt, dt_count_var, data_type, time_period, fill_value = NA)
```

## Arguments

- dt:

  A data.table of events containing a `ptid` column.

- dt_count_var:

  A string naming the column to pivot into count columns.

- data_type:

  A string prefix to add to output variable names.

- time_period:

  A string describing the time period to include in output names.

- fill_value:

  Value used to fill missing combinations (default NA).

## Value

A data.table with `ptid` and count columns formatted via
`formatVariableNames`.

## Examples

``` r
if (FALSE) { # \dontrun{
getCounts(events_dt, "medication", "rx", "time_period_365d", fill_value = 0)
} # }
```
