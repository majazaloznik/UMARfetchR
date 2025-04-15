dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"),
                        client_encoding = "utf8")
  DBI::dbExecute(con, "set search_path to test_platform")

  test_that("preparing vintage table works", {
    dtfrm <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "M")
    expect_equal(prepare_periods(dtfrm)[1,1], "2020M01")
    dtfrm <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_tests2.xlsx"), sheet = "Q")
    expect_equal(prepare_periods(dtfrm)[1,1], "2020Q1")
    df_m <- suppressWarnings( openxlsx::read.xlsx(testthat::test_path("testdata", "umar_serije_podatki_MK.xlsx"), sheet = "M"))
    x <- prepare_vintage_table(df_m, con, "test_platform")
    expect_equal(nrow(x), 12)
    expect_equal(ncol(x), 3)
  })
})

test_that("prepare data functions work", {
  with_mock_db({
    con <- make_test_connection()
    df_m <- suppressWarnings( openxlsx::read.xlsx(testthat::test_path("testdata", "umar_serije_podatki_MK.xlsx"), sheet = "M"))
    selection <- prepare_vintage_table(df_m, con, "test_platform")
    x <- prepare_data_table(df_m, selection, con, "test_platform")
    expect_equal(nrow(x), 2306)
    expect_equal(ncol(x), 3)
    expect_true(all(names(x) == c("vintage_id", "period_id", "value")))
  })
})



