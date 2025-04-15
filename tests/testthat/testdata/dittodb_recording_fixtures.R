source("tests/testthat/helper-connection.R")

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "192.168.38.21",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_PG_PSW"),
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

start_db_capturing()
con <- DBI::dbConnect(RPostgres::Postgres(),
                      dbname = "platform",
                      host = "192.168.38.21",
                      port = 5432,
                      user = "majaz",
                      password = Sys.getenv("PG_MZ_PSW"),
                      client_encoding = "utf8")
DBI::dbExecute(con, "set search_path to platform")
on.exit(dbDisconnect)
prepare_category_table("Maja Zalo\u017enik", con)
stop_db_capturing()
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
# x <- insert_new_series(df, con, "test_platform")
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
# x <- insert_new_series(df, con, "test_platform")
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
# x <- prepare_series_levels_table(df, con)
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
# x <- insert_new_series_levels(df, con, "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# test25 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet25")
# test25 <- compute_table_codes(test25, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# test25 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet25")
# x <- parse_structure(test25, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
# x <- insert_new_category_table(df, con, "test_platform")
# stop_db_capturing()
#
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# test25 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet25")
# x <- parse_structure(test25, con)
# prep_and_import_structure(x, con, "test_platform")
# stop_db_capturing()


# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# get_table_id_with_same_name("MZ", "dfg", con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet9")
# out <-compute_table_codes(df, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet26")
# x <- compute_table_codes(df, con)
# stop_db_capturing()

#
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# main_structure(test_path("testdata", "struct_tests4.xlsx"), con, "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# insert_new_author("Maja Založnik", "MZ", "maja.zaloznik@gov.si", NA, con, "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# auth <- UMARaccessR::get_initials_from_author_name("Maja Zalo\u017enik", con)
# stop_db_capturing()

#
start_db_capturing()
con <- DBI::dbConnect(RPostgres::Postgres(),
                      dbname = "platform",
                      host = "localhost",
                      port = 5433,
                      user = "postgres",
                      password = Sys.getenv("PG_local_15_PG_PSW"),
                      client_encoding = "utf8")
DBI::dbExecute(con, "set search_path to test_platform")
on.exit(dbDisconnect)
add_author_folder("MZ", "O:/Avtomatizacija/umar-data/mz", con, "test_platform")
stop_db_capturing()


start_db_capturing()
con <- DBI::dbConnect(RPostgres::Postgres(),
                      dbname = "platform",
                      host = "localhost",
                      port = 5433,
                      user = "postgres",
                      password = Sys.getenv("PG_local_15_PG_PSW"),
                      client_encoding = "utf8")
DBI::dbExecute(con, "set search_path to test_platform")
on.exit(dbDisconnect)
dir.create(  testthat::test_path("test_dir"))
# Call the function with custom path
x <- add_new_author("Matevz Hribernik",
                    initials = "MH",
                    email = "maja.zaloznik@gov.si",
                    con = con,schema = "test_platform",
                    data_location = testthat::test_path("test_dir") , overwrite = TRUE)
stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# counter = 0
# df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet1")
# out <-check_data_df(df, con)
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
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet9")
# check_data_df(df, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(test_path("testdata", "data_tests.xlsx"), sheet = "Sheet1")
# check_data_df(df, con)
# stop_db_capturing()


# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# filename <- test_path("testdata", "data_tests2.xlsx")
# interval <- check_data_xlsx(filename, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# vintages <- UMARfetchR:::prepare_vintage_table(df, con)[,2:3]
# res <- UMARimportR::sql_function_call(con,
#                                      "insert_new_vintage",
#                                      as.list(vintages))
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(test_path("testdata", "data_test6.xlsx"), sheet = "M")
# insert_new_data(df, con, "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "A")
# x <- prepare_vintage_table(df, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "M")
# x <- prepare_vintage_table(df, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "A")
# insert_new_vintage(df, con, schema= "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "A")
# insert_new_vintage(df, con, schema= "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "A")
# selection <- prepare_vintage_table(df, con)
# prepare_data_table(df, selection, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "data_test6.xlsx"), sheet = "A")
# insert_data_points(df, con, "test_platform")
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# filename <- testthat::test_path("testdata", "struct_tests6.xlsx")
# codes <- main_structure(filename, con, "test_platform")
# filename <- testthat::test_path("testdata", "data_test6.xlsx")
# main_data(filename, codes, con, "test_platform")
# stop_db_capturing()
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests8.xlsx"), sheet = "timeseries")
# check_structure_df(df, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_PG_PSW"),
#                       client_encoding = "utf8")
# DBI::dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# legal_units <- dplyr::tbl(con, "unit") |>
#   dplyr::collect() |>
#   dplyr::select(name) |>
#   dplyr::pull()
# test32 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet32")
# expect_error(check_structure_df(test32, con))
# stop_db_capturing()

# start_db_capturing()
# con <- make_test_connection()
# df_m <- suppressWarnings( openxlsx::read.xlsx("O://Avtomatizacija/umar-data/MK/umar_serije_podatki_MK.xlsx", sheet = "M"))
# x <- prepare_vintage_table(df_m, con, "test_platform")
# stop_db_capturing()

start_db_capturing()
con <- make_test_connection()
Sys.setenv("TESTTHAT"="true")
df_m <- suppressWarnings( openxlsx::read.xlsx("O://Avtomatizacija/umar-data/MK/umar_serije_podatki_MK.xlsx", sheet = "M"))
insert_new_vintage(df_m, con, "test_platform")
Sys.setenv("TESTTHAT"="false")
stop_db_capturing()

start_db_capturing()
con <- make_test_connection()
Sys.setenv("TESTTHAT"="true")
df_m <- suppressWarnings( openxlsx::read.xlsx("O://Avtomatizacija/umar-data/MK/umar_serije_podatki_MK.xlsx", sheet = "M"))
selection <- prepare_vintage_table(df_m, con, "test_platform")
prepare_data_table(df_m, selection, con, "test_platform")
Sys.setenv("TESTTHAT"="false")
stop_db_capturing()


start_db_capturing()
con <- make_test_connection()
Sys.setenv("TESTTHAT"="true")
df_m <- suppressWarnings( openxlsx::read.xlsx("O://Avtomatizacija/umar-data/MK/umar_serije_podatki_MK.xlsx", sheet = "M"))
df_m <- prepare_periods(df_m)
x <- insert_data_points(df_m, con, "test_platform")
Sys.setenv("TESTTHAT"="false")
stop_db_capturing()

# start_db_capturing()
# con <- make_test_connection()
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet1")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet2")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet3")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet4")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet5")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet5")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet6")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet7")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet12")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet13")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet15")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet16")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet18")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet20")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet21")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet22")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet23")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet27")
# df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests2.xlsx"))
# x <- split_structure(df)
# df <- openxlsx::read.xlsx(test_path("testdata", "struct_tests3.xlsx"))
# x <- split_structure(df)
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests7.xlsx"), sheet = "Sheet1")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet30")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests8.xlsx"), sheet = "timeseries")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet31")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet32")
# check_structure_df(test, con, "test_platform")
# test <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet33")
# check_structure_df(test, con, "test_platform")
# filename <- test_path("testdata", "data_tests4.xlsx")
# check_data_xlsx(filename, c("UMAR--MZ002--1--M",	"UMAR--MZ002--12--M", "UMAR--MZ007--LKJ--11--A"))
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# x <- prepare_category_table("Maja Zalo\u017enik", con, schema = "test_platform")
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
# x <- prepare_category_table_table(df, con, schema = "test_platform")
# x <- prepare_category_relationship_table("Maja Zalo\u017enik", con, schema = "test_platform")
# out <- prepare_table_table(df, con, "test_platform")
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
# out <- prepare_table_dimensions_table(df, con, "test_platform")
# out <- prepare_dimension_levels_table(df, con, "test_platform")
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
# out <- prepare_series_table(df, con, "test_platform")
# df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet34")
# out <- prepare_series_levels_table(df, con, "test_platform")
# out <- prepare_new_author_table("kh", "kjh", "ljlk", NA)
# stop_db_capturing()
#
# start_db_capturing()
# test25 <- openxlsx::read.xlsx(test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet25")
# x <- parse_structure(test25, con, "test_platform")
# out <- prep_and_import_structure(x$df_new, con, "test_platform")
# output <- main_structure(test_path("testdata", "struct_tests4.xlsx"),
#                          con, "test_platform")
# stop_db_capturing()
# start_db_capturing()
# con <- make_test_connection()
# filename <- testthat::test_path("testdata", "struct_tests6.xlsx")
# codes <- main_structure(filename, con, "test_platform")
# filename <- testthat::test_path("testdata", "data_test6.xlsx")
# main_data(filename, codes, con, "test_platform")
# stop_db_capturing()

stop_db_capturing()
start_db_capturing()
df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
out <- prepare_table_dimensions_table(df, con, schema = "test_platform")
expect_equal(dim(out), c(6,3))
expect_equal(out[[6,1]], "dim3")
out <- prepare_dimension_levels_table(df, con,  schema = "test_platform")
stop_db_capturing()
