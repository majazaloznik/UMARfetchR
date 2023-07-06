dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"),
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to test_platform")

  test_that("check_structure finds unparsable stuff", {
    test1 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet1")
    expect_error(check_structure_df(test1, con))
    test2 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet2")
    expect_true(check_structure_df(test2, con))
    test3 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet3")
    expect_error(check_structure_df(test3, con))
    test4 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet4")
    expect_error(check_structure_df(test4, con))
    test5 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet5")
    expect_true(check_structure_df(test5, con))
    test5 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet5")
    expect_true(check_structure_df(test5, con))
    test6 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet6")
    expect_error(check_structure_df(test6, con))
    test7 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet7")
    expect_error(check_structure_df(test7, con))
    test12 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet12")
    expect_error(check_structure_df(test12, con))
    test13 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet13")
    expect_true(check_structure_df(test13, con ))
    test14 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
    expect_error(check_structure_df(test14, con))
    test15 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet15")
    expect_error(check_structure_df(test15, con))
    test16 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet16")
    expect_error(check_structure_df(test16, con))
    test17 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
    expect_error(check_structure_df(test17, con))
    test18 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet18")
    expect_error(check_structure_df(test18, con))
    test19 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
    expect_true(check_structure_df(test19, con))
    test20 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet20")
    expect_true(check_structure_df(test20, con))
    test21 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet21")
    expect_true(!all(is.na(compute_series_names(test21)$series_name)))
    expect_error(check_structure_df(test21, con))
    test22 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet22")
    expect_error(check_structure_df(test22, con))
    test23 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet23")
    expect_error(check_structure_df(test23, con))
    test27 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet27")
    expect_error(check_structure_df(test27, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests2.xlsx"))
    x <- message_structure(df)
    expect_equal(x, c(2,2))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"))
    x <- message_structure(df)
    expect_equal(x, c(4,3))

  })


  test_that("table codes are computed correctly", {
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"), sheet = "M")
    out <-compute_table_codes(df, con)
    expect_equal(out$table_code, c("MZ001", "MZ001", "MZ002",  "MZ006", "MZ006", "MZ007", "MZ007"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"), sheet = "A")
    out <-compute_table_codes(df, con)
    expect_equal(out$table_code, c("MZ006", "MZ006", "MZ006", "MZ006", "MZ006"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet8")
    out <-compute_table_codes(df, con)
    expect_equal(out$table_code, c("MZ001", "MZ001", "MZ001", "MZ006"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet9")
    out <-compute_table_codes(df, con)
    expect_equal(out$table_code, c(rep("MZ001",3), rep("MZ002",3), rep("MZ003",2)))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet26")
    out <- compute_table_codes(df, con)
    expect_equal(out$table_code, c(rep("MZ004",2), rep("MZ005",2)))


  })
  test_that("series codes are computed correctly", {
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet10")
    out <-compute_series_codes(df)
    expect_equal(out$series_code[8], "UMAR--MZ003--D3--A")
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet11")
    out <-compute_series_codes(df)
    expect_equal(out$series_code[8], "UMAR--MZ003--D3--A")
    test25 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet25")
    x <- parse_structure(test25, con)
    expect_equal(x$series_code[4], "UMAR-EUROSTAT--MZ005--12--M")
    test25 <- compute_table_codes(test25, con)
    out <-compute_series_codes(test25)
    out$series_code[4] == "UMAR-EUROSTAT--MZ005--12--M"
  })

  test_that("data parsing is cool", {
    counter <- 0
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet1")
    out <-check_data_df(df, con)
    expect_true(out)
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet9")
    expect_error(check_data_df(df, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet11")
    expect_error(check_data_df(df, con))
    rm(counter)
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet2")
    expect_error(check_data_df(df, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet3")
    expect_error(check_data_df(df, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet4")
    expect_error(check_data_df(df, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet5")
    expect_error(check_data_df(df, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet6")
    expect_error(check_data_df(df, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet7")
    expect_error(check_data_df(df, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet8")
    expect_error(check_data_df(df, con))
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet10")
    expect_error(check_data_df(df, con))

  })
})





