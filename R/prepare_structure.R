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

#' Prepare table to insert into `table_dimensions` table
#'
#' Helper function that manually prepares the table_dimensions table.
#' Returns table ready to insert into the `table_dimensions`table with the
#' db_writing family of functions.
#'
#' @param con connection to the database
#' @param df dataframe with table_code and dimensions
#' @return a dataframe with the `table_id`, `dimension_name`, `time` columns for
#' each dimension of this table.
#' @export
prepare_table_dimensions_table <- function(df, con){
  df |>
    dplyr::arrange(table_code) |>
    dplyr::group_by(table_code, dimensions) |>
    dplyr::summarise(.groups = "drop") |>
    dplyr::rowwise() |>
    dplyr::mutate(table_id = UMARaccessR::get_table_id_from_table_code(table_code, con),
                  is_time = rep(0)) |>
    tidyr::separate_longer_delim(dimensions, delim ="--") |>
    dplyr::mutate(dimensions = trimws(dimensions)) |>
    dplyr::rename(dimension = dimensions) |>
    dplyr::select(-table_code) |>
    dplyr::arrange(table_id)
}



#' Prepare table to insert into `dimension_levels` table
#'
#' Helper function that manually prepares the dimension_levels for each
#' table and get their codes and text.
#' Returns table ready to insert into the `dimension_levels`table with the
#' db_writing family of functions.
#'
#' @param df dataframe with table_code, dimensions and dimension_levels_code
#' @param con connection to the database
#' @return a dataframe with the `dimension_id`, `values` and `valueTexts`
#' columns for this table.
#' @export
#' @importFrom stats na.omit
prepare_dimension_levels_table <- function(df, con) {
  dimz <- df |>
    tidyr::separate_longer_delim(dimensions, delim ="--") |>
    dplyr::mutate(dimensions = trimws(dimensions)) |>
    dplyr::pull(dimensions)
  dim_txt <- df |>
    tidyr::separate_longer_delim(dimension_levels_text, delim ="--") |>
    dplyr::mutate(dimension_levels_text = trimws(dimension_levels_text)) |>
    dplyr::pull(dimension_levels_text)

  df |>
    tidyr::separate_longer_delim(dimension_levels_code, delim ="--") |>
    dplyr::mutate(dimension_levels_code = trimws(dimension_levels_code),) |>
    dplyr::mutate(dimensions = dimz,
                  dimension_levels_text = dim_txt) |>
    dplyr::select(table_code, dimensions, dimension_levels_code, dimension_levels_text) |>
  dplyr::arrange(table_code) |>
    dplyr::group_by(table_code, dimensions, dimension_levels_code, dimension_levels_text) |>
    dplyr::summarise(.groups = "drop") |>
    dplyr::rowwise() |>
    dplyr::mutate(table_id = UMARaccessR::get_table_id_from_table_code(table_code, con),
                  tab_dim_id  = UMARaccessR::get_tab_dim_id_from_table_id_and_dimension(table_id, dimensions, con)) |>
    dplyr::rename(level_value = dimension_levels_code,
                  level_text = dimension_levels_text) |>
    dplyr::select(tab_dim_id, level_value, level_text)
}



#' Prepare table to insert into `series` table
#'
#' Prepare a series table to import into the series table in the database.
#'
#' @param df dataframe with table_code, series_name, series_code, unit, interval
#' @param con connection to the database
#'
#' @return a dataframe with the following columns: `name_long`, `code`,
#' `unit_id`, `table_id` and `interval_id`for each series in the table
#' well as the same number of rows as there are series
#' @export
prepare_series_table <- function(df, con){
  df |>
    dplyr::rowwise() |>
    dplyr::mutate(table_id = UMARaccessR::get_table_id_from_table_code(table_code, con),
                  unit_id = UMARaccessR::get_unit_id_from_unit_name(unit, con)[1,1]) |>
    dplyr::select(table_id, series_name, unit_id, series_code, interval) |>
    dplyr::rename(interval_id = interval,
                  name_long = series_name,
                  code = series_code)
}


#' Prepare table to insert into `series_levels` table
#'
#' Helper function that manually prepares the series_levels for each
#' series and get their ids and values (codes).
#' Returns table ready to insert into the `series_levels`table with the
#' db_writing family of functions.
#'
#' @param df dataframe with table_code, dimensions and dimension_levels_code and series_code
#' @param con connection to the database
#' @return a dataframe with the `series_id`, `tab_dim_id` and `level_value`
#' columns for this table.
#' @export
#' @importFrom stats na.omit
prepare_series_levels_table <- function(df, con) {
  dimz <- df |>
    tidyr::separate_longer_delim(dimensions, delim ="--") |>
    dplyr::mutate(dimensions = trimws(dimensions))  |>
    dplyr::pull(dimensions)

  df |>
    tidyr::separate_longer_delim(dimension_levels_code, delim ="--") |>
    dplyr::mutate(dimension_levels_code = trimws(dimension_levels_code),) |>
    dplyr::mutate(dimensions = dimz) |>
    dplyr::select(table_code, dimensions, dimension_levels_code, series_code) |>
    dplyr::rowwise() |>
    dplyr::mutate(table_id = UMARaccessR::get_table_id_from_table_code(table_code, con),
                  tab_dim_id = UMARaccessR::get_tab_dim_id_from_table_id_and_dimension(table_id, dimensions, con),
                  series_id = UMARaccessR::get_series_id_from_series_code(series_code, con)) |>
    dplyr::select(series_id, tab_dim_id, level_value = dimension_levels_code)
}
