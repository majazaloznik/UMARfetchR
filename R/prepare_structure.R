#' Prepare table to insert into `source` table

#' Helper function that manually prepares the new line for the source table.
#' This is only done once.
#'
#' @param con connection to the database.
#' @return a dataframe with the `name`, `name_long`, and `url`, columns.
#' for this table.
#' @export
prepare_source_table <- function(con){
  source <- dplyr::tbl(con, "source") |>
    dplyr::collect()
  if (!"UMAR" %in% source$name){
    id <- source |>
    dplyr::summarise(max = max(id, na.rm = TRUE)) |>
      dplyr::pull() + 1
    data.frame(id = id,
               name = "UMAR",
               name_long = "Urad za makroekonomske analize in razvoj",
               url = "https://www.umar.gov.si/")} else {
    message("UMAR je \u017ee v bazi.")
    FALSE}
}


#' Prepare table to insert into `category` table
#'
#' Helper function that manually prepares the category table with field ids and
#' their names. Returns table ready to insert into the `category` table with the db_writing family
#' of functions from SURSfetchR using \link[SURSfetchR]{sql_function_call}.
#'
#' In the case of `UMARfetchR` the the primary category of each table is the author's
#' full name. But other categories could be added in the future, although that has not
#' been tested.
#'
#' @param con connection to the database
#' @param cat_name character name of the category
#'
#' @return a dataframe with the `id`, `name`, `source_id` for each category that
#' the table is a member of.
#' @export
#'
prepare_category_table <- function(cat_name, con) {
  source_id <- UMARaccessR::get_source_code_from_source_name("UMAR", con)[1,1]
  max_cat <- UMARaccessR::get_max_category_id_for_source(source_id, con)[1,1]
  data.frame(id = max_cat + 1,
             name = cat_name,
             source_id = source_id)
}


#' Prepare table to insert into `category_relationship` table
#'
#' Helper function that manually prepares the category_relationship table for first level only!
#' Returns table ready to insert into the `category_relationship` table with the db_writing family
#' of functions from SURSfetchR using \link[SURSfetchR]{sql_function_call}.
#'
#' As there is currently only first level categories in UMAR, this function cannot
#' do others, but this functionality can be added if the need arises.
#'
#' @param con connection to the database
#' @param cat_name character name of category
#'
#' @return a dataframe with the `id`, `parent_id`, `source_id` for each relationship
#' betweeh categories
#' @export
#'
prepare_category_relationship_table <- function(cat_name, con) {
  source_id <- UMARaccessR::get_source_code_from_source_name("UMAR", con)[1,1]
  id <- dplyr::tbl(con, "category") |>
    dplyr::filter(name == cat_name) |>
    dplyr::pull(id)

  data.frame(id = id,
             parent_id = 0,
             source_id = source_id)
}


#' Prepare table to insert into `table` table
#'
#' Helper function that manually prepares the table table.
#' Returns table ready to insert into the `table` table with the db_writing family
#' of functions from SURSfetchR using \link[SURSfetchR]{sql_function_call}. The input
#' dataframe must have passed through \link[UMARfetchR]{compute_table_codes} so that
#' the table_codes and table_names are aligned.
#'
#' @param df dataframe with table_code and table_name columns
#' @param con connection to the database
#'
#' @return a dataframe with the `code`, `name`, `source_id`, `url`, and `notes` columns
#' for the tables.
#' @export
prepare_table_table <- function(df, con) {
  source_id <- UMARaccessR::get_source_code_from_source_name("UMAR", con)[1,1]
  df |>
    dplyr::arrange(table_code) |>
    dplyr::group_by(table_code, table_name) |>
    dplyr::summarise(.groups = "drop") |>
    dplyr::rename(code = table_code, name = table_name) |>
    dplyr::mutate(source_id = source_id, url = NA,  notes = NA)
}
#
#
# SURSfetchR::sql_function_call(con,
#                               "insert_new_table",
#                               as.list(tb), "test_platform")
