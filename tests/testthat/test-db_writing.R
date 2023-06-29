dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = "kermitit",
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to test_platform")

  test_that("prepare functions work", {
    x <- insert_new_source(con)
    expect_equal(dim(x), c(1,1))
    x <- insert_new_category("Maja Zalo\u017enik", con)
    expect_equal(dim(x), c(1,1))
    x <- insert_new_category_relationship("Maja Zalo\u017enik", con, "test_platform")
    expect_equal(dim(x), c(1,1))
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
    x <- insert_new_table(df, con, "test_platform")
    expect_equal(dim(x), c(2,1))
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
    x <- insert_new_table_dimensions(df, con, "test_platform")
    expect_equal(dim(x), c(6,1))
  })
})



