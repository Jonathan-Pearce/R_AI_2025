library(testthat)

# Load functions if not already available (works when running tests from package root)
if (!exists("isLengthNonZero", mode = "function")) {
  source(file.path("helper_functions.R"))
}

test_that("isLengthNonZero returns 0 for zero-length inputs", {
  expect_equal(isLengthNonZero(integer(0)), 0)
  expect_equal(isLengthNonZero(numeric(0)), 0)
  expect_equal(isLengthNonZero(character(0)), 0)
  expect_equal(isLengthNonZero(list()), 0)
})

test_that("isLengthNonZero returns 1 for non-zero-length inputs", {
  expect_equal(isLengthNonZero(1), 1)
  expect_equal(isLengthNonZero(1:3), 1)
  expect_equal(isLengthNonZero(c("a", "b")), 1)
  expect_equal(isLengthNonZero(list(NA)), 1)
})