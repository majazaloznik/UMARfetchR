
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

dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"),
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to test_platform")

  test_that("get id works if table exists", {
    x <- get_table_id_with_same_name("MZ", "dfg", con)
    expect_equal(x, "MZ003")
  })
})

test_that("get id works if table exists", {
  x <- get_interval_from_period("2192M12")
  expect_equal(x, "M")
  x <- get_interval_from_period("2192Q2")
  expect_equal(x, "Q")
  x <- get_interval_from_period("2193")
  expect_equal(x, "A")
  expect_error(get_interval_from_period("219"))
  expect_error(get_interval_from_period("21923mm"))
  expect_error(get_interval_from_period("21Q1"))
  expect_equal(excel_date_to_r_date(1234), as.Date("1903-05-18"))
  expect_true(is.na(excel_date_to_r_date("dd")))
})

