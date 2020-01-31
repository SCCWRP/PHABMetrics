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
phabmetrics <- function(data){
  if (!("sampleagencycode" %in% tolower(names(data)))){
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
  
  # calc metrics
  metrics <- list(bankmorph(data), channelmorph(data), channelsinuosity(data),
                  densiometer(data),  habitat(data), disturbance(data), flow(data),
                  misc(data), bankstability(data), quality(data), ripveg(data),
                  substrate(data), algae(data))

  # combine seprate metrics lists 
  out <- purrr::map(metrics, function(x){

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
    ~ !any(grepl('[a-z,A-Z]', .x)), as.numeric
    )
  
  
  out <- out %>% 
    dplyr::left_join(
      data %>% 
        dplyr::mutate(
          phab_sampleid = dplyr::case_when(
            toupper(SampleAgencyCode) != 'NOT RECORDED' ~ paste(
              StationCode, SampleDate, SampleAgencyCode, sep = "_"
            ),
            toupper(SampleAgencyCode) == 'NOT RECORDED' ~ paste(StationCode, SampleDate, sep = "_"),
            TRUE ~ NA_character_
          )
        ) %>%
        dplyr::select(
          phab_sampleid, StationCode, SampleDate, SampleAgencyCode
        ) %>%
        dplyr::distinct(phab_sampleid,StationCode,SampleDate,SampleAgencyCode)
      , by = 'phab_sampleid'
    )
  
  out <- out %>%
    dplyr::select(
      c(phab_sampleid,StationCode,SampleDate,SampleAgencyCode,
      names(out)[which(!(names(out) %in% c('StationCode','SampleDate','SampleAgencyCode','phab_sampleid')))]
      )
    )
  
  out <- longformat(out)
  
  return(out)
  
}
