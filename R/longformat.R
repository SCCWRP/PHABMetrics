#' Melt the phabmetrics output dataframe to long format
#'
#' @param data Input data
#' 
#' @export
#' 
#' @importFrom magrittr "%>%"
#' @importFrom dplyr select full_join
#' @importFrom tidyr gather
#' @importFrom stats setNames
#' 
longformat <- function(data) {
  metrics.sd <- data %>%
    dplyr::select(
      phab_sampleid, StationCode, SampleDate, SampleAgencyCode,
      which(grepl("\\.sd",names(data)))
    ) %>%
    dplyr::rename(setNames(names(.),gsub("\\.sd","",names(.)))) %>%
    tidyr::gather(
      key = 'Variable',value = 'sd', -c(phab_sampleid,StationCode,SampleDate,SampleAgencyCode)
    )
  
  metrics.count <- data %>%
    dplyr::select(
      phab_sampleid, StationCode, SampleDate, SampleAgencyCode,
      which(grepl("\\.count",names(data)))
    ) %>% 
    dplyr::rename(setNames(names(.),gsub("\\.count","",names(.)))) %>%
    tidyr::gather(
      key = 'Variable',value = 'Count_Calc', -c(phab_sampleid,StationCode,SampleDate,SampleAgencyCode)
    )
  
  metrics.result <- data %>%
    dplyr::select(
      phab_sampleid, StationCode, SampleDate, SampleAgencyCode,
      which(grepl("\\.result",names(data)))
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

