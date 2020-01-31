#' Melt the phabmetrics output dataframe to long format
#'
#' @param data Input data
#' 
#' @export
#' 
#' @importFrom magrittr "%>%"
#' @importFrom dplyr select
#' 

# Input to the function is the wide form of the metrics dataframe
# hence the argument name metrics
# this code could easily be appended to the end of phabmetrics.R
# But I did this for the sake of readability
longformat <- function(metrics) {
  metrics.sd <- metrics %>%
    dplyr::select(
      phab_sampleid, StationCode, SampleDate, SampleAgencyCode,
      which(grepl("\\.sd",names(metrics)))
    ) %>%
    dplyr::rename(setNames(names(.),gsub("\\.sd","",names(.)))) %>%
    tidyr::gather(
      key = 'Variable',value = 'sd', -c(phab_sampleid,StationCode,SampleDate,SampleAgencyCode)
    )
  
  metrics.count <- metrics %>%
    dplyr::select(
      phab_sampleid, StationCode, SampleDate, SampleAgencyCode,
      which(grepl("\\.count",names(metrics)))
    ) %>% 
    dplyr::rename(setNames(names(.),gsub("\\.count","",names(.)))) %>%
    tidyr::gather(
      key = 'Variable',value = 'Count_Calc', -c(phab_sampleid,StationCode,SampleDate,SampleAgencyCode)
    )
  
  metrics.result <- metrics %>%
    dplyr::select(
      phab_sampleid, StationCode, SampleDate, SampleAgencyCode,
      which(grepl("\\.result",names(metrics)))
    ) %>% 
    dplyr::rename(setNames(names(.),gsub("\\.result","",names(.)))) %>%
    tidyr::gather(
      key = 'Variable',value = 'Result', -c(phab_sampleid,StationCode,SampleDate,SampleAgencyCode)
    )
  
  return(
    metrics.result %>% 
      full_join(
        metrics.count, 
        by = c(
          'phab_sampleid','StationCode','SampleDate','SampleAgencyCode','Variable'
        )
      ) %>% 
      full_join(
        metrics.sd, 
        by = c(
          'phab_sampleid','StationCode','SampleDate','SampleAgencyCode','Variable'
        )
      )
  )
  
}

