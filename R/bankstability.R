#' Bank stability metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @examples 
#' bankstability(sampdat)
bankstability <- function(data){
  data <- data[which(data$AnalyteName %in% c('Bank Stability')),]
  ###PBM_S###
  
  stable <- function(data){
    length(which(data == "stable"))
  }
  total <- function(data){length(c(which(data == "stable"), 
                                   which(data == "vulnerable"), which(data == "eroded")))}
  PBM_S_sum <- tapply(data$VariableResult, data$id, stable)
  total_obs <- tapply(data$VariableResult, data$id, total)
  PBM_S.result <- round((PBM_S_sum/total_obs)*100)
  PBM_S.count <- total_obs
  
  ###PBM_V###
  vulnerable <- function(data){
    length(which(data == "vulnerable"))
  }
  PBM_V_sum <- tapply(data$VariableResult, data$id, vulnerable)
  PBM_V.result <- round((PBM_V_sum/total_obs)*100)
  PBM_V.count <- total_obs
  
  ###PBM_E###
  eroded <- function(data){
    length(which(data == "eroded"))
  }
  PBM_E_sum <- tapply(data$VariableResult, data$id, eroded)
  PBM_E.result <- round((PBM_E_sum/total_obs)*100)
  PBM_E.count <- total_obs
  
  ###Write to file###
  results <- cbind(PBM_S.result, PBM_S.count, PBM_V.result, PBM_V.count, PBM_E.result, PBM_E.count)

  return(results)
  
}
