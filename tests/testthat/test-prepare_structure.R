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
    x <- prepare_source_table(con)
    expect_equal(dim(x), c(1,4))
    x <- prepare_category_table("Maja Zalo\u017enik", con)
    expect_equal(dim(x), c(1,3))
    x <- prepare_category_relationship_table("Maja Zalo\u017enik", con)
    expect_equal(dim(x), c(1,3))
  })
})



