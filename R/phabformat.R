#' Format input data
#'
#' @param data Input data
#'
#' @export
#' 
#' @importFrom magrittr "%>%"
#' 
#' @examples
#' phabformat(sampdat)


phabformat <- function(data){
  
  # format column classes
  data <- data %>% 
    dplyr::mutate(
      StationCode = as.character(StationCode),
      SampleDate = as.character(SampleDate),
      SampleAgencyCode = as.character(SampleAgencyCode),
      Replicate = as.integer(Replicate),
      MethodName = as.character(MethodName),
      LocationCode = as.character(LocationCode),
      AnalyteName = as.character(AnalyteName),
      UnitName = as.character(UnitName),
      VariableResult = as.character(VariableResult),
      FractionName = as.character(FractionName),
      Result = as.numeric(Result),
      ResQualCode = as.character(ResQualCode),
      QACode = as.character(QACode)
      )
  
  
  
  data$VariableResult[data$ResQualCode=="NR"] <- "Not Recorded"
  data$VariableResult[data$VariableResult=="NR"] <- "Not Recorded"
  data$Result[data$ResQualCode=="NR"] <- NA
  data$Result[data$Result == -88] <- NA
  data <- data %>% 
    #tidyr::unite('id', StationCode, SampleDate, SampleAgencyCode, sep = "_", remove = F) %>%
    dplyr::mutate('id' = dplyr::case_when(
        toupper(SampleAgencyCode) != 'NOT RECORDED' ~ paste(
          StationCode, SampleDate, SampleAgencyCode, sep = "_"
        ),
        toupper(SampleAgencyCode) == 'NOT RECORDED' ~ paste(StationCode, SampleDate, sep = "_"),
        TRUE ~ NA_character_
      )
    ) %>% 
    data.frame(stringsAsFactors = F)
  
  return(data)
  
}

