# Add a prefix to variable names (except the first column)

Prepend a prefix and an underscore to every column name except the first
(commonly the `ptid` column).

## Usage

``` r
addPrefix(dt, prefix)
```

## Arguments

- dt:

  A data.table or data.frame.

- prefix:

  A string prefix to add.

## Value

The modified `dt` with updated column names.

## Examples

``` r
addPrefix(dt, "labs")
#> Error in `colnames<-`(`*tmp*`, value = `*vtmp*`): attempt to set 'colnames' on an object with less than two dimensions
```
