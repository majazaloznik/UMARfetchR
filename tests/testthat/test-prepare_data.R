dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"),
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to test_platform")

  test_that("preparing vintage table works", {
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "A")
    x <- prepare_vintage_table(df, con)
    expect_equal(dim(x), c(1,3))
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "M")
    x <- prepare_vintage_table(df, con)
    expect_equal(dim(x), c(3,3))
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "A")
    selection <- prepare_vintage_table(df, con)
    x <- prepare_data_table(df, selection, con)
    expect_equal(dim(x), c(6,3))
    expect_equal(x[[6,3]], 12)
  })
})


