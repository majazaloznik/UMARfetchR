library(DBI)
library(dittodb)

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "192.168.38.21",
#                       port = 5432,
#                       user = "majaz",
#                       password = Sys.getenv("PG_MZ_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to platform")
# on.exit(dbDisconnect)
# source <- dplyr::tbl(con, "source") |>
#   dplyr::collect()
# stop_db_capturing()


# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "192.168.38.21",
#                       port = 5432,
#                       user = "majaz",
#                       password = Sys.getenv("PG_MZ_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to platform")
# on.exit(dbDisconnect)
# insert_new_source(con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "192.168.38.21",
#                       port = 5432,
#                       user = "majaz",
#                       password = Sys.getenv("PG_MZ_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to platform")
# on.exit(dbDisconnect)
# UMARaccessR::get_source_code_from_source_name("UMAR", con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "192.168.38.21",
#                       port = 5432,
#                       user = "majaz",
#                       password = Sys.getenv("PG_MZ_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to platform")
# on.exit(dbDisconnect)
# prepare_category_table("Maja Zalo\u017enik", con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW")
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# insert_new_category("Maja Zalo\u017enik", con, "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# prepare_category_relationship_table("Maja Zalo\u017enik", con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# insert_new_category_relationship("Maja Zalo\u017enik", con, "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests3.xlsx"), sheet = "M")
# out <-compute_table_codes(df, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
# out <-prepare_table_table(df, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
# insert_new_table(df, con, "test_platform")
# stop_db_capturing()
#
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
# prepare_table_dimensions(df, con)
# stop_db_capturing()


# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
# out <- prepare_table_dimensions_table(df, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
# x <- insert_new_table_dimensions(df, con, "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
# x <- prepare_dimension_levels_table(df, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
# x <- insert_new_dimension_levels(df, con, "test_platform")
# stop_db_capturing()


# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
# x <- prepare_series_table(df, con)
# stop_db_capturing()

start_db_capturing()
con <- DBI::dbConnect(RPostgres::Postgres(),
                      dbname = "platform",
                      host = "localhost",
                      port = 5432,
                      user = "mzaloznik",
                      password = Sys.getenv("PG_local_MAJA_PSW"),
                      client_encoding = "utf8")
dbExecute(con, "set search_path to test_platform")
on.exit(dbDisconnect)
df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
x <- insert_new_series(df, con, "test_platform")
stop_db_capturing()
