dittodb::with_mock_db({
  con <- make_test_connection()
  test_that("check_structure finds unparsable stuff", {
    test1 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet1")
    expect_error(check_structure_df(test1, con, "test_platform"))
    test2 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet2")
    expect_true(check_structure_df(test2, con, "test_platform"))
    test3 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet3")
    expect_error(check_structure_df(test3, con, "test_platform"))
    test4 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet4")
    expect_error(check_structure_df(test4, con, "test_platform"))
    test5 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet5")
    expect_true(check_structure_df(test5, con, "test_platform"))
    test5 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet5")
    expect_true(check_structure_df(test5, con, "test_platform"))
    test6 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet6")
    expect_error(check_structure_df(test6, con, "test_platform"))
    test7 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet7")
    expect_error(check_structure_df(test7, con, "test_platform"))
    test12 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet12")
    expect_error(check_structure_df(test12, con, "test_platform"))
    test13 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet13")
    expect_true(check_structure_df(test13, con , "test_platform"))
    test14 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
    expect_error(check_structure_df(test14, con, "test_platform"))
    test15 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet15")
    expect_error(check_structure_df(test15, con, "test_platform"))
    test16 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet16")
    expect_error(check_structure_df(test16, con, "test_platform"))
    test17 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
    expect_error(check_structure_df(test17, con, "test_platform"))
    test18 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet18")
    expect_error(check_structure_df(test18, con, "test_platform"))
    test19 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
    expect_true(check_structure_df(test19, con, "test_platform"))
    test20 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet20")
    expect_true(check_structure_df(test20, con, "test_platform"))
    test21 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet21")
    expect_true(!all(is.na(compute_series_names(test21)$series_name)))
    expect_error(check_structure_df(test21, con, "test_platform"))
    test22 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet22")
    expect_error(check_structure_df(test22, con,"test_platform"))
    test23 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet23")
    expect_error(check_structure_df(test23, con, "test_platform"))
    test27 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet27")
    expect_error(check_structure_df(test27, con, "test_platform"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests2.xlsx"))
    x <- split_structure(df)
    expect_equal(nrow(x$df_new),2)
    expect_equal(nrow(x$df_old),2)
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"))
    x <- split_structure(df)
    expect_equal(nrow(x$df_new),4)
    expect_equal(nrow(x$df_old),3)
    test28 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests7.xlsx"), sheet = "Sheet1")
    expect_error(check_structure_df(test28, con, "test_platform"))
    test30 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet30")
    expect_error(check_structure_df(test30, con, "test_platform"))
    test31 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests8.xlsx"), sheet = "timeseries")
    expect_error(check_structure_df(test31, con, "test_platform"))
    test31 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet31")
    expect_error(check_structure_df(test31, con, "test_platform"))
    test32 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet32")
    expect_error(check_structure_df(test32, con, "test_platform"))
    test33 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet33")
    expect_true(check_structure_df(test33, con, "test_platform"))
    })


  test_that("table codes are computed correctly", {
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"), sheet = "M")
    out <-compute_table_codes(df, con, schema = "test_platform")
    expect_equal(out$table_code, c("MZ001", "MZ001", "MZ002",  "MZ005", "MZ005", "MZ006", "MZ006"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"), sheet = "A")
    out <-compute_table_codes(df, con, schema = "test_platform")
    expect_equal(out$table_code, c("MZ005", "MZ005", "MZ005", "MZ005", "MZ005"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet8")
    out <-compute_table_codes(df, con, schema = "test_platform")
    expect_equal(out$table_code, c("MZ001", "MZ001", "MZ001", "MZ005"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet9")
    out <-compute_table_codes(df, con, schema = "test_platform")
    expect_equal(out$table_code, c(rep("MZ001",3), rep("MZ002",3), rep("MZ003",2)))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet26")
    out <- compute_table_codes(df, con, schema = "test_platform")
    expect_equal(out$table_code, c(rep("MZ003",2), rep("MZ004",2)))


  })
  test_that("series codes are computed correctly", {
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet10")
    out <-compute_series_codes(df)
    expect_equal(out$series_code[8], "UMAR--MZ003--D3--A")
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet11")
    out <-compute_series_codes(df)
    expect_equal(out$series_code[8], "UMAR--MZ003--D3--A")
    test25 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet25")
    test25 <- compute_table_codes(test25, con, schema = "test_platform")
    out <-compute_series_codes(test25)
    out$series_code[4] == "UMAR-EUROSTAT--MZ005--12--M"
    test29 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet29")
    out <-compute_series_codes(test29)
    out$series_code[1] == "UMAR-EUROSTAT--MZ001--234--M"
    out$series_code[2] == "UMAR-IMF--MZ001--1123--M"
    out$series_code[3] == "INVESTOPEDIA-UMAR--MZ001--12--M"
  })

  test_that("data parsing df is cool", {
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet1")
    out <-check_data_df(df, c("UMAR--MZ002--1--M",	"UMAR--MZ002--12--M"))
    expect_true(out == "M")
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet9")
    expect_error(check_data_df(df)) # duplicated series
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet2")
    expect_error(check_data_df(df)) # missing period column
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet3")
    expect_error(check_data_df(df)) # 2 period columns
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet4")
    expect_error(check_data_df(df)) # same period
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet5")
    expect_error(check_data_df(df)) # different intervals
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet6")
    expect_error(check_data_df(df)) # misformed period m
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet7")
    expect_error(check_data_df(df)) # misformed period q
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet8")
    expect_error(check_data_df(df)) # misformed period a
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet10")
    expect_error(check_data_df(df)) # missing period
    df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet11")
    expect_error(check_data_df(df, c("UMAR--MZ002--1--M",	"UMAR--MZ002--12--M"), con)) # wrong series
  })

    test_that("data parsing wb is cool", {

    filename <- test_path("testdata", "data_tests2.xlsx")
    out <- check_data_xlsx(filename, c("UMAR--MZ002--1--M", "UMAR--MZ002--12--M",
                                       "UMAR--MZ002--1--Q",	"UMAR--MZ002--12--Q"))
    expect_true(out)
    filename <- test_path("testdata", "data_tests3.xlsx")
    expect_error(check_data_xlsx(filename)) # wrong interval
    expect_true(out)
    filename <- test_path("testdata", "data_tests4.xlsx")
    expect_error(check_data_xlsx(filename,
                                 c("UMAR--MZ002--1--M",	"UMAR--MZ002--12--M", "UMAR--MZ007--LKJ--11--A"))) # wrong series
    x <- check_data_xlsx(test_path("testdata", "data_tests4.xlsx"),codes = c("UMAR--MZ007--LKJ--131--A", "UMAR--MZ002--1--M"	,"UMAR--MZ002--12--M"))
    expect_true(x)


  })

})





