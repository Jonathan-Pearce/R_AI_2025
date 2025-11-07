# Wrapper to subset by a two-element time period

Calls `subsetEvents` using a named time period (vector of length 2).

## Usage

``` r
getDataTimePeriod(dt, dt_date_var, time_period)
```

## Arguments

- dt:

  A data.table containing event records.

- dt_date_var:

  A string naming the date column in `dt` to filter on.

- time_period:

  A string naming an object (vector of length 2) containing start and
  end dates.

## Value

A data.table filtered to the specified time period.

## Examples

``` r
if (FALSE) { # \dontrun{
getDataTimePeriod(events_dt, "event_date", "time_period_q1")
} # }
```
