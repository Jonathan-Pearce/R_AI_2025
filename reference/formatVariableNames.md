# Format variable names by adding data type, time period, and value type

Convenience function that applies `addPrefix` and `addSuffix` in
sequence to create consistent variable naming: prefix (data_type),
suffix (time_period), suffix (value_type).

## Usage

``` r
formatVariableNames(dt, data_type, time_period, value_type)
```

## Arguments

- dt:

  A data.table or data.frame.

- data_type:

  A string prefix to add.

- time_period:

  A string describing the time period; the function will remove any
  leading "time_period\_" before using it as a suffix.

- value_type:

  A string describing the value type (e.g., "count", "flag", "mean").

## Value

The modified `dt` with formatted column names.

## Examples

``` r
formatVariableNames(dt, "labs", "time_period_30d", "mean")
#> Error in `colnames<-`(`*tmp*`, value = `*vtmp*`): attempt to set 'colnames' on an object with less than two dimensions
```
