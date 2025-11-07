# Create patient-level flag (binary) wide table

Cast an event-level table to a wide patient-level table of flags (0/1)
indicating presence of each value of `dt_flag_var` per patient.

## Usage

``` r
getFlags(dt, dt_flag_var, data_type, time_period)
```

## Arguments

- dt:

  A data.table of events containing a `ptid` column.

- dt_flag_var:

  A string naming the column to pivot into flag columns.

- data_type:

  A string prefix to add to output variable names (e.g., event type).

- time_period:

  A string describing the time period to include in output names.

## Value

A data.table with `ptid` and one column per unique value of
`dt_flag_var`, formatted with prefixes/suffixes via
`formatVariableNames`.

## Examples

``` r
if (FALSE) { # \dontrun{
getFlags(events_dt, "condition", "diagnosis", "time_period_90d")
} # }
```
