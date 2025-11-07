# Binary indicator aggregator for dcast

Returns 1 when the length of x is greater than zero, otherwise 0.
Intended for use as `fun.aggregate` in
[`data.table::dcast`](https://rdatatable.gitlab.io/data.table/reference/dcast.data.table.html)
to create flags.

## Usage

``` r
isLengthNonZero(x)
```

## Arguments

- x:

  A vector passed by the aggregator.

## Value

Integer 1 or 0.

## Examples

``` r
isLengthNonZero(1:3)
#> [1] 1
```
