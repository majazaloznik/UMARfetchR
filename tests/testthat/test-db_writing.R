dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "192.168.38.21",
                        port = 5432,
                        user = "majaz",
                        password = Sys.getenv("PG_MZ_PSW"),
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to platform")

  test_that("prepare functions work", {
    x <- insert_new_source(con)
    expect_equal(dim(x), c(1,1))
    x <- insert_new_category("Maja Založnik", con)
    expect_equal(dim(x), c(1,1))
    x <- insert_new_category_relationship("Maja Založnik", con)
    expect_equal(dim(x), c(1,1))
  })
})



