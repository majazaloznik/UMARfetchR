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
    x <- parse_structure(test25, con, "test_platform")
    expect_equal(x$df_new$series_code[4], "UMAR-EUROSTAT--MZ004--12--M")
    # out <- prep_and_import_structure(x$df_new, con, "test_platform")
    output <- main_structure(test_path("testdata", "struct_tests4.xlsx"),
                                         con, "test_platform")
    expect_true(length(output) == 5)
    filename <- testthat::test_path("testdata", "struct_tests6.xlsx")
    codes <- main_structure(filename, con, "test_platform")
    filename <- testthat::test_path("testdata", "data_test6.xlsx")
    expect_message(main_data(filename, codes, con, "test_platform"))

  })
})

local_update_data_mocks <- function(main_data_fun, env = parent.frame()) {
  local_mocked_bindings(
    read_codes_from_metadata_excel = function(...) c("A", "B"),
    main_data = main_data_fun, .env = env)
  local_mocked_bindings(
    sql_get_email_from_author_initials = function(...) "x@y.si",
    .package = "UMARaccessR", .env = env)
}

test_that("update_data returns counts and logs messages and warnings", {
  dir <- tempfile(); dir.create(dir)
  local_update_data_mocks(function(...) { message("uvoz ok"); warning("pazi"); 5 })
  suppressMessages(expect_warning(
    res <- update_data("p/umar_serije_metadata_XY.xlsx", "p/umar_serije_podatki_XY.xlsx",
                       con = NULL, schema = "platform", path = dir),
    "pazi"))
  expect_equal(res$rows, 5)
  expect_equal(res$initials, "XY")
  expect_equal(res$email, "x@y.si")
  expect_equal(res$codes, c("A", "B"))
  log <- readLines(res$log_file)
  expect_true(any(grepl("uvoz ok", log)))
  expect_true(any(grepl("Opozorilo: pazi", log)))
  expect_equal(sink.number(), 0)
})

test_that("update_data logs and re-raises errors, releasing the sink", {
  dir <- tempfile(); dir.create(dir)
  local_update_data_mocks(function(...) stop("napacna koda"))
  suppressMessages(expect_error(
    update_data("p/umar_serije_metadata_XY.xlsx", "p/umar_serije_podatki_XY.xlsx",
                con = NULL, schema = "platform", path = dir),
    "napacna koda"))
  log <- readLines(list.files(dir, full.names = TRUE))
  expect_true(any(grepl("Napaka: napacna koda", log)))
  expect_equal(sink.number(), 0)
})

test_that("update_data refuses mismatched files", {
  expect_error(update_data("umar_serije_metadata_XY.xlsx", "umar_serije_podatki_AB.xlsx",
                           con = NULL, schema = "platform", path = tempdir()),
               "different initials")
})
