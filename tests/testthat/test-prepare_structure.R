dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"),
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to test_platform")

  test_that("prepare functions work", {
    x <- prepare_source_table(con)
    expect_equal(dim(x), c(1,4))
    x <- prepare_category_table("Maja Zalo\u017enik", con)
    expect_equal(dim(x), c(1,3))
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
    x <- prepare_category_table_table(df, con)
    expect_equal(dim(x), c(2,3))
    x <- prepare_category_relationship_table("Maja Zalo\u017enik", con)
    expect_equal(dim(x), c(1,3))
    out <- prepare_table_table(df, con)
    expect_equal(dim(out), c(2,5))
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
    out <- prepare_table_dimensions_table(df, con)
    expect_equal(dim(out), c(6,3))
    expect_equal(out[[6,1]], "dim3")
    out <- prepare_dimension_levels_table(df, con)
    expect_equal(dim(out), c(10,3))
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
    out <- prepare_series_table(df, con)
    expect_equal(dim(out), c(4,5))
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
    out <- prepare_series_levels_table(df, con)
    expect_equal(out[[1,2]], 130)
  })
})
