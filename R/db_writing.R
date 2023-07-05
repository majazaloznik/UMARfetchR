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
  x1 <- SURSfetchR::sql_function_call(con,
                                "insert_new_source",
                                as.list(prepare_source_table(con)),
                                schema)
  source_id <- UMARaccessR::get_source_code_from_source_name("UMAR", con)
  x2 <- SURSfetchR::sql_function_call(con,
                                "insert_new_category",
                                list(id = 0,
                                     name = "UMAR",
                                     source_id = source_id[1,1]),
                                schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo source: ", sum(x1))
  message("\u0160tevilo novih vrstic zapisanih v tabelo category: ", sum(x2))
  x2
}

#' Insert new author
#'
#' Used to insert a new author into the database.
#'
#' @param name name
#' @param initials keep it short, also unique!
#' @param email email
#' @param folder can be left empty
#' @param con connection to the database
#' @param schema schema name
#' @return number of rows inserted
#' @export
insert_new_author <- function(name, initials, email, folder = NA, con, schema = "platform") {
  x <- SURSfetchR::sql_function_call(con,
                                     "insert_new_author",
                                     as.list(prepare_new_author_table(name, initials, email, folder)),
                                     schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo umar_author: ", x[1,1])
  x[1,1]
}

#' Add author folder
#'
#' Add the folder to an author already in the database.
#'
#' @param initials keep it short, also unique!
#' @param folder can be left empty
#' @param con connection to the database
#' @param schema schema name
#'
#' @return number of rows inserted
#' @export
add_author_folder <- function(initials, folder, con, schema = "platform") {
  x <- DBI::dbExecute(con, sprintf("update umar_authors
       set folder = '%s'
       WHERE initials = '%s';", folder, initials))

  message("Posodobljeno polje folder tabeli umar_author.")
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
  x <- SURSfetchR::sql_function_call(con,
                                "insert_new_category",
                                as.list(prepare_category_table(cat_name, con)),
                                schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo category: ", sum(x))
  sum(x)
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
  x <- SURSfetchR::sql_function_call(con,
                                "insert_new_category_relationship",
                                as.list(prepare_category_relationship_table(cat_name, con)),
                                schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo category_relationship: ", sum(x))
    sum(x)
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
  x <- SURSfetchR::sql_function_call(con,
                                     "insert_new_table",
                                     as.list(prepare_table_table(df, con)),
                                     schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo table: ", sum(x))
  sum(x)
}


#' Insert new category table
#'
#' Used to insert the new UMAR category_table into the database.
#'
#' @param df dataframe with author,and  table code columns
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#' @return nothing
#' @export
insert_new_category_table <- function(df, con, schema = "platform") {
  x <- SURSfetchR::sql_function_call(con,
                                     "insert_new_category_table",
                                     as.list(prepare_category_table_table(df, con)),
                                     schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo category_table: ", sum(x))
  sum(x)
}



#' Insert new table_dimensions table
#'
#' Used to insert the new tables_dimensions into the database. The input
#' dataframe must have passed through \link[UMARfetchR]{compute_table_codes} so that
#' the table_codes and table_names are aligned. And all the checks of the parser
#' of course.
#'
#' @param df dataframe table_code and dimensions columns.
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#' @return nothing
#' @export
insert_new_table_dimensions <- function(df, con, schema = "platform") {
  x <- SURSfetchR::sql_function_call(con,
                                "insert_new_table_dimensions",
                                as.list(prepare_table_dimensions_table(df, con)),
                                schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo table_dimenisons: ", sum(x))
  sum(x)
}

#' Insert new dimension_levels table
#'
#' Used to insert the new dimension levels into the database. The input
#' dataframe must have passed through \link[UMARfetchR]{compute_table_codes} so that
#' the table_codes and table_names are aligned. And all the checks of the parser
#' of course.
#'
#' @param df dataframe table_code and dimensions, dimension_level_text and
#' dimension_level_code columns.
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#' @return nothing
#' @export
insert_new_dimension_levels <- function(df, con, schema = "platform") {
  x <- SURSfetchR::sql_function_call(con,
                                "insert_new_dimension_levels",
                                as.list(prepare_dimension_levels_table(df, con)),
                                schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo dimension_levels: ", sum(x))

  sum(x)
}

#' Insert new series table
#'
#' Used to insert the new series levels into the database. The input
#' dataframe must have passed through \link[UMARfetchR]{compute_series_codes} . And all the checks of the parser
#' of course.
#'
#' @param df dataframe table_code and dimensions, dimension_level_text and
#' dimension_level_code columns.
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#' @return nothing
#' @export
insert_new_series <- function(df, con, schema = "platform") {
  x <- SURSfetchR::sql_function_call(con,
                                "insert_new_series",
                                as.list(prepare_series_table(df, con)),
                                schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo series: ", sum(x))
  sum(x)
}


#' Insert new series levels table
#'
#' Used to insert the new series levels into the database. The input
#' dataframe must have passed through \link[UMARfetchR]{compute_series_codes}. And all the checks of the parser
#' of course.
#'
#' @param df dataframe with table_code, dimensions and dimension_levels_code and
#' series_code columns
#' @param con connection to the database.
#' @param schema db schema, defaults to platfrom
#' @return nothing
#' @export
insert_new_series_levels <- function(df, con, schema = "platform") {
  x <- SURSfetchR::sql_function_call(con,
                                "insert_new_series_levels",
                                as.list(prepare_series_levels_table(df, con)),
                                schema)
  message("\u0160tevilo novih vrstic zapisanih v tabelo series_level: ", sum(x))
  sum(x)
}
