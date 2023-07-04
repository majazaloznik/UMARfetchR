dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"),
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to test_platform")
  test_that("series codes are computed correctly", {
    test25 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet25")
    x <- parse_structure(test25, con)
    expect_equal(x$series_code[4], "UMAR-EUROSTAT--MZ005--12--M")
    out <- prep_and_import_structure(x, con, "test_platform")
    output <- main_structure(test_path("testdata", "struct_tests4.xlsx"),
                                         con, "test_platform")
    expect_true(output)
  })
})
