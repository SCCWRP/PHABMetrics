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
      SampleDate = as.Date(SampleDate),
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
  data$Result[data$ResQualCode=="NR"] <- NA
  data <- data %>% 
    tidyr::unite('id', StationCode, SampleDate, SampleAgencyCode, remove = F) %>% 
    data.frame(stringsAsFactors = F)
  return(data)
}

