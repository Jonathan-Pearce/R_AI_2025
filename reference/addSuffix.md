# Add a suffix to variable names (except the first column)

Append an underscore and suffix to every column name except the first.

## Usage

``` r
addSuffix(dt, suffix)
```

## Arguments

- dt:

  A data.table or data.frame.

- suffix:

  A string suffix to add.

## Value

The modified `dt` with updated column names.

## Examples

``` r
addSuffix(dt, "30d")
#> Error in `colnames<-`(`*tmp*`, value = `*vtmp*`): attempt to set 'colnames' on an object with less than two dimensions
```
