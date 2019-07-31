#' Miscellaneous metrics
#'
#' @param data Input data
#' 
#' @importFrom magrittr "%>%"
#' 
#' @export
#' 
#' @examples 
#' sampdat <- phabformat(sampdat)
#' misc(sampdat)
misc <- function(data){

  data <- data[which(data$AnalyteName %in% c('Riffle/Run Channel Alteration', 'Riffle/Run Epifaunal Substrate', 'Riffle/Run Sediment Deposition', 'Dominant Land Use', 'Evidence of Fire', 'Evidence of Recent Rainfall')),]
  ###Report###
  data$VariableResult[data$ResQualCode=="NR"] <- NA
  data$VariableResult <- as.character(data$VariableResult)
  
  # function to get value verbatim from data
  getunival <- function(data, analyt){

    out <- data %>% 
      dplyr::filter(AnalyteName %in% !!analyt) %>% 
      dplyr::select(id, VariableResult) %>%
      unique   
    
    return(out)
    
  }

  NFC_DLU <- getunival(data, 'Dominant Land Use')
  NFC_EFR <- getunival(data, 'Evidence of Fire')
  NFC_ERN <- getunival(data, 'Evidence of Recent Rainfall')
  RBP_CHN <- getunival(data, 'Riffle/Run Channel Alteration')
  RBP_EPI <- getunival(data, 'Riffle/Run Epifaunal Substrate')
  RBP_SED <- getunival(data, 'Riffle/Run Sediment Deposition')
  
  misc_metrics <- NFC_DLU %>% 
    dplyr::full_join(NFC_EFR, by = 'id') %>% 
    dplyr::full_join(NFC_ERN, by = 'id') %>% 
    dplyr::full_join(RBP_CHN, by = 'id') %>% 
    dplyr::full_join(RBP_EPI, by = 'id') %>% 
    dplyr::full_join(RBP_SED, by = 'id') %>% 
    as.data.frame(stringsAsFactors = F)
  
  rownames(misc_metrics) <- misc_metrics$id
  misc_metrics <- misc_metrics[, !names(misc_metrics) %in% 'id']

  colnames(misc_metrics)<- c("NFC_DLU.result", "NFC_EFR.result", "NFC_ERN.result",
                             "RBP_CHN.result", "RBP_EPI.result", "RBP_SED.result")
  
  return(misc_metrics)
  
}