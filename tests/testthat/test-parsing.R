test_that("check_structure finds unparsable stuff", {
  test1 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet1")
  expect_error(check_structure_df(test1))
  test2 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet2")
  expect_true(check_structure_df(test2))
  test3 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet3")
  expect_error(check_structure_df(test3))
  test4 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet4")
  expect_error(check_structure_df(test4))
  test5 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet5")
  expect_true(check_structure_df(test5))
  test5 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet5")
  expect_true(check_structure_df(test5))
  test6 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet6")
  expect_error(check_structure_df(test6))
  test7 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet7")
  expect_error(check_structure_df(test7))
  test12 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet12")
  expect_error(check_structure_df(test12))
  test13 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet13")
  expect_true(check_structure_df(test13))
  test14 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
  expect_error(check_structure_df(test14))
  test15 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet15")
  expect_error(check_structure_df(test15))
  test16 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet16")
  expect_error(check_structure_df(test16))
  test17 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
  expect_error(check_structure_df(test17))
  test18 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet18")
  expect_error(check_structure_df(test18))
  test19 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
  expect_true(check_structure_df(test19))
  test20 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet20")
  expect_true(check_structure_df(test20))
  test21 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet21")
  expect_true(!all(is.na(compute_series_names(test21)$series_name)))
  expect_message(message_structure(test_path("testdata", "struct_tests2.xlsx")))
  out <- message_structure(test_path("testdata", "struct_tests2.xlsx"))
  expect_equal(out[1,2], 2)
  expect_equal(out[1,3], 2)
  out <- message_structure(test_path("testdata", "struct_tests3.xlsx"))
  expect_equal(out[3,3], 4)
})



dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = "kermitit",
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to test_platform")

  test_that("table codes are computed correctly", {
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"), sheet = "M")
    out <-compute_table_codes(df, con)
    expect_equal(out$table_code, c("MZ001", "MZ001", "MZ002", "MZ003", "MZ003", "MZ004", "MZ004"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"), sheet = "A")
    out <-compute_table_codes(df, con)
    expect_equal(out$table_code, c("MZ003", "MZ003", "MZ003", "MZ003", "MZ003"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet8")
    out <-compute_table_codes(df, con)
    expect_equal(out$table_code, c("MZ001", "MZ001", "MZ001", "MZ003"))
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet9")
    out <-compute_table_codes(df, con)
    expect_equal(out$table_code, c(rep("MZ001",3), rep("MZ002",3), rep("MZ003",2)))
  })
  test_that("series codes are computed correctly", {
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet10")
    out <-compute_series_codes(df)
    expect_equal(out$series_code[8], "UMAR--MZ003--D3--A")
    df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet11")
    out <-compute_series_codes(df)
    expect_equal(out$series_code[8], "UMAR--MZ003--D3--A")
  })
})



