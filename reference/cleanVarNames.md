# Clean variable names to a consistent format

Replace spaces, slashes and punctuation commonly found in column names
with underscores and remove parentheses.

## Usage

``` r
cleanVarNames(dt)
```

## Arguments

- dt:

  A data.frame or data.table.

## Value

The modified `dt` with cleaned column names.

## Examples

``` r
cleanVarNames(df)
#> Error in UseMethod("tbl_vars"): no applicable method for 'tbl_vars' applied to an object of class "function"
```
