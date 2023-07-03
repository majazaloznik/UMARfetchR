#' Get the initials from a name
#'
#' This function takes a name and returns the initials. It treats both "-" and " "
#' as separators. This function is for internal use and is not exported.
#'
#' @param name name
get_initials <- function(name) {
  words <- unlist(strsplit(name, split = "[ -]"))
  initials <- substring(words, 1, 1)
  paste(initials, collapse = "")
}
