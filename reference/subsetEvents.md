# Subset events by a date window

Filter a data.table of events to the rows where an event date falls
within a specified start and end date (inclusive).

## Usage

``` r
subsetEvents(dt, event_date_var, start_date_var, end_date_var)
```

## Arguments

- dt:

  A data.table containing event records.

- event_date_var:

  A string naming the column in `dt` that holds the event date.

- start_date_var:

  A string naming the variable or column that holds the start date.

- end_date_var:

  A string naming the variable or column that holds the end date.

## Value

A data.table containing only rows where the event date is between start
and end.

## Examples

``` r
if (FALSE) { # \dontrun{
subsetEvents(dt = events_dt, event_date_var = "event_date",
             start_date_var = "start_date", end_date_var = "end_date")
} # }
```
