test_that("insert structure functions work", {
  with_mock_db({
    con <- make_test_connection()
    df_m <- suppressWarnings( openxlsx::read.xlsx(testthat::test_path("testdata", "umar_serije_podatki_MK.xlsx"), sheet = "M"))
    x <- insert_new_vintage(df_m, con, "test_platform")
    expect_equal(sum(x), 12)
  })
})


test_that("insert data functions work", {
  with_mock_db({
    con <- make_test_connection()
    df_m <- suppressWarnings( openxlsx::read.xlsx(testthat::test_path("testdata", "umar_serije_podatki_MK.xlsx"), sheet = "M"))
    df_m <- prepare_periods(df_m)
    x <- insert_data_points(df_m, con, "test_platform")
    expect_equal(x, 11)
  })
})
