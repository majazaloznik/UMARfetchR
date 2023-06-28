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
# prepare_category_table("Maja Založnik", con)
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
# insert_new_category("Maja Založnik", con)
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
# prepare_category_relationship_table("Maja Založnik", con)
# stop_db_capturing()
#
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
# insert_new_category_relationship("Maja Založnik", con)
# stop_db_capturing()


