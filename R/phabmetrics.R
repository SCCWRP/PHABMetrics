#' Calculate all PHAB metrics
#'
#' @param data Input data
#'
#' @export
#'
#' @importFrom magrittr "%>%"
#'
#' @examples
#' \dontrun{
#' phabmetrics(sampdat)
#' }
phabmetrics <- function(data, output_errors = FALSE) {
  metrics = list()
  err_log = data.frame(
    func = character(),
    msg = character(),
    stringsAsFactors = FALSE
  )

  if (!("sampleagencycode" %in% tolower(names(data)))) {
    data <- data %>%
      dplyr::mutate(
        SampleAgencyCode = 'Not Recorded'
      )
  }

  # format input
  data <- phabformat(data)

  # chkinp threw off values of sinuosity metrics by removing rows of data
  # We should probably let the checker application check the data so users (and us) are aware of any problems with their data
  data <- chkinp(data, purge = TRUE)

  bankmorph_metrics = bankmorph(data)

  metrics_functions = list(
    bankmorph = bankmorph,
    channelmorph = channelmorph,
    channelsinuosity = channelsinuosity,
    densiometer = densiometer,
    habitat = habitat,
    disturbance = disturbance,
    flow = flow,
    misc = misc,
    bankstability = bankstability,
    quality = quality,
    ripveg = ripveg,
    substrate = substrate,
    algae = algae
  )

  for (f_name in names(metrics_functions)) {
    res = tryCatch(
      {
        metrics_functions[[f_name]](data)
      },
      error = function(e) {
        # Capture the error and return a specific indicator
        err_log <<- rbind(err_log, data.frame(func = f_name, msg = e$message))
        return(NULL)
      }
    )

    if (!is.null(res)) {
      metrics[[f_name]] <- res
    }
  }

  # combine seprate metrics lists
  out <- metrics |>
    purrr::compact() |>
    purrr::map(function(x) {
      lnfrm <- x %>%
        as.data.frame(stringsAsFactors = FALSE) %>%
        tibble::rownames_to_column('phab_sampleid') %>%
        dplyr::mutate_if(is.numeric, as.character) %>%
        tidyr::gather('var', 'val', -phab_sampleid)

      return(lnfrm)
    }) %>%
    do.call('rbind', .) %>%
    dplyr::mutate(
      val = gsub('NaN', NA, val)
    ) %>%
    tidyr::spread('var', 'val') %>%
    dplyr::mutate_if(
      ~ !any(grepl('[a-z,A-Z]', .x)),
      as.numeric
    )

  out <- out %>%
    dplyr::left_join(
      data %>%
        dplyr::mutate(
          phab_sampleid = dplyr::case_when(
            toupper(SampleAgencyCode) != 'NOT RECORDED' ~ paste(
              StationCode,
              SampleDate,
              SampleAgencyCode,
              sep = "_"
            ),
            toupper(SampleAgencyCode) == 'NOT RECORDED' ~ paste(
              StationCode,
              SampleDate,
              sep = "_"
            ),
            TRUE ~ NA_character_
          )
        ) %>%
        dplyr::select(
          phab_sampleid,
          StationCode,
          SampleDate,
          SampleAgencyCode
        ) %>%
        dplyr::distinct(
          phab_sampleid,
          StationCode,
          SampleDate,
          SampleAgencyCode
        ),
      by = 'phab_sampleid'
    )

  out <- out %>%
    dplyr::select(
      c(
        phab_sampleid,
        StationCode,
        SampleDate,
        SampleAgencyCode,
        names(out)[which(
          !(names(out) %in%
            c('StationCode', 'SampleDate', 'SampleAgencyCode', 'phab_sampleid'))
        )]
      )
    )

  out <- longformat(out) %>% select(-phab_sampleid)

  if ((out %>% dplyr::distinct(SampleAgencyCode) == 'Not Recorded') %>% all()) {
    out <- out %>%
      dplyr::select(-SampleAgencyCode)
  }

  if (output_errors) {
    # Return the named list structure
    return(list(
      out = out,
      errors = err_log
    ))
  } else {
    return(out)
  }
}
