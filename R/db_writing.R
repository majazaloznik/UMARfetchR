#' Insert new source.
#'
#' This is a one off, but is here for completeness. Used to insert the ZRSZ source
#' into the database. Also adds the cover category for the source.
#'
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#'
#' @return nothing
#' @export
insert_new_source <- function(con, schema = "platform") {
  SURSfetchR::sql_function_call(con,
                                "insert_new_source",
                                as.list(prepare_source_table(con)),
                                schema)
  source_id <- UMARaccessR::get_source_code_from_source_name("UMAR", con)
  SURSfetchR::sql_function_call(con,
                                "insert_new_category",
                                list(id = 0,
                                     name = "UMAR",
                                     source_id = source_id[1,1]),
                                schema)
}

#' Insert new category
#'
#' Used to insert the new UMAR categories into the database.
#'
#' @param cat_name character name of category - usually full name of author
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#' @return nothing
#' @export
insert_new_category <- function(cat_name, con, schema = "platform") {
  SURSfetchR::sql_function_call(con,
                                "insert_new_category",
                                as.list(prepare_category_table(cat_name, con)),
                                schema)
}

#' Insert new category relationship
#'
#' Used to insert the new UMAR category relationships into the database.
#'
#' @param cat_name character name of category - usually full name of author
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#' @return nothing
#' @export
insert_new_category_relationship <- function(cat_name, con, schema = "platform") {
  SURSfetchR::sql_function_call(con,
                                "insert_new_category_relationship",
                                as.list(prepare_category_relationship_table(cat_name, con)),
                                schema)
}

#' Insert new table
#'
#' Used to insert the new tables into the database. The input
#' dataframe must have passed through \link[UMARfetchR]{compute_table_codes} so that
#' the table_codes and table_names are aligned.
#'
#' @param df dataframe table_code and table_name columns.
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#' @return nothing
#' @export
insert_new_table <- function(df, con, schema = "platform") {
  SURSfetchR::sql_function_call(con,
                                "insert_new_table",
                                as.list(prepare_table_table(df, con)),
                                schema)
}
