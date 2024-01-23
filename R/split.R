
#' Split strata_name and strata_level into the columns.
#'
#' @param result Omop result object (summarised_result or compared_result).
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param overall Whether to keep overall column if present.
#'
#' @export
#'
#' @examples
#' \donttest{
#' #library(visOmop)
#'
#' mockSummarisedResult() |>
#'   splitStrata()
#' }
#'
splitStrata <- function(result,
                        keep = FALSE,
                        overall = FALSE) {
  splitNameLevel(
    result = result,
    prefix = "strata",
    keep = keep,
    overall = overall
  )
}

#' Split additional_name and additional_level into the columns.
#'
#' @param result Omop result object (summarised_result or compared_result).
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param overall Whether to keep overall column if present.
#'
#' @export
#'
#' @examples
#' \donttest{
#' #library(visOmop)
#'
#' mockSummarisedResult() |>
#'   splitAdditional()
#' }
#'
splitAdditional <- function(result,
                            keep = FALSE,
                            overall = FALSE) {
  splitNameLevel(
    result = result,
    prefix = "additional",
    keep = keep,
    overall = overall
  )
}

splitNameLevel <- function(result, prefix, keep, overall) {
  result <- splitGroup(
    x = result,
    name = paste0(prefix, "_name"),
    level = paste0(prefix, "_level"),
    keep = keep
  )
  if ("overall" %in% colnames(result) & !overall) {
    result <- result |> dplyr::select(-"overall")
  }
  return(result)
}
