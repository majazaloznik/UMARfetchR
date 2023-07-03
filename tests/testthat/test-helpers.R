
test_that("get_initials correctly extracts initials", {
  expect_equal(get_initials("John Doe"), "JD")
  expect_equal(get_initials("Mary Jane Smith"), "MJS")
  expect_equal(get_initials("John"), "J")
})

test_that("get_initials handles hyphenated names correctly", {
  expect_equal(get_initials("Mary-Jane Smith"), "MJS")
  expect_equal(get_initials("John Doe-Smith"), "JDS")
  expect_equal(get_initials("Anna-Maria"), "AM")
})

test_that("get_initials handles names with multiple spaces correctly", {
  expect_equal(get_initials("John  Doe"), "JD")
  expect_equal(get_initials("  Mary Jane Smith  "), "MJS")
})

test_that("get_initials returns an empty string for an empty input", {
  expect_equal(get_initials(""), "")
})
