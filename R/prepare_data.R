
#' Prepare period values from dates
#'
#' Leaves years if the data is annual, and swaps dates for month (2023M02) or
#' quarterly values (2023Q1)
#'
#' @param data individual sheet data
#'
#' @return with updated period
#' @export
prepare_periods <- function(data) {
  if (!all(grepl("^\\d{4}$", data$period))){ # check not annual
    data$period <-  excel_date_to_r_date(data$period)
    if(all(lubridate::month(data$period) %in% c(1, 4, 7, 10))) { # quarterly data
      data$period <- paste0(lubridate::year(data$period), "Q", lubridate::quarter(data$period))
    } else {
      data$period <- paste0(lubridate::year(data$period), "M",
                            sprintf("%02d", lubridate::month(data$period)))
    }
  }
  data
}


#' Get new vintages ids
#'
#' Helper function preparing vintages to be imported. First checks which
#' series have new data and keeps only those, adding their series_ids
#' and published times to prep for import into the vintage table
#'
#' @param data - checked data from Excel sheet.
#' @param con connection to the database.
#'
#' @return data frame with `series_code`, `series_id` and `published` columns
#' @export

prepare_vintage_table <- function(data, con) {
  # data <- prepare_periods(data)
      selection <- data %>%
        dplyr::summarize_all(~ data$period[max(which(!is.na(.)))]) |>
        dplyr::select(-period) |>
        tidyr::pivot_longer(everything(), names_to = "series_code", values_to = "max_period_new") |>
        dplyr::rowwise() |>
        dplyr::mutate(series_id = UMARaccessR::get_series_id_from_series_code(series_code, con),
                      vint_id = UMARaccessR::get_vintage_from_series(series_id, con)[1,1],
                      max_period_db = ifelse(is.na(vint_id), NA,
                                             UMARaccessR::get_last_period_from_vintage(vint_id, con)[1,1])) |>
        dplyr::ungroup() |>
        dplyr::filter(is.na(max_period_db) | max_period_new > max_period_db ) |>
        dplyr::select(series_code, series_id) |>
        dplyr::mutate(published = Sys.time()) |>
        dplyr::ungroup()
        selection
}

#' Get and prepare data for import
#'
#' Prepares the timeseries data for importing into the database.
#'
#' @param con connection to database
#' @param data dataframe with the data_points
#' @param selection dataframe with selected series / output from \link[UMARfetchR]{prepare_vintage_table}
#' @return a dataframe with the period_id, value and id values for all the vintages in the table.
#'
#' @export
prepare_data_table <- function(data, selection, con){

  selection_series_ids <- selection$series_id

  vintage_filtered <- dplyr::tbl(con, "vintage") %>%
    dplyr::filter(series_id %in% !!selection_series_ids) |>
    dplyr::group_by(series_id) |>
    dplyr::slice_max(published) |>
    dplyr::collect() |>
    dplyr::ungroup()

 data |>
   tidyr::pivot_longer(cols = -period, names_to = "series_code", values_to = "value") |>
   dplyr::left_join(selection, by = "series_code") |>
   dplyr::left_join(vintage_filtered, by = "series_id") |>
   dplyr::select(-series_code, -published.x, -published.y, series_id, -series_id) |>
   dplyr::relocate(vintage_id = id, period_id = period) |>
   dplyr::arrange(vintage_id) |>
   na.omit()

}
