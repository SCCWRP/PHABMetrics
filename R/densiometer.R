#' Densiometer metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @examples 
#' densiometer(sampdat)
densiometer <- function(data){
  
  data <- data[which(data$AnalyteName %in% c('Canopy Cover')),]
  
  x <- as.character(data$LocationCode)
  split <- data.frame(do.call('rbind',strsplit(x, ",")))
  colnames(split) <- c("trans", "view")
  data <- cbind(data, split)
  
  ###Calculate XCDENBK###
  
  a <- c(which(data$view == " LeftViewLeft"), which(data$view == " RightViewRight"))
  XCDENBK_data <- data.frame(cbind(data$id[a], (data$Result[a])))
  colnames(XCDENBK_data) <- c("id", "Result")
  transform <- function(data) as.numeric(as.character(data))*(100/17)
  XCDENBK_data$trans <- 1:length(XCDENBK_data$Result)
  XCDENBK_data$trans <- (transform(XCDENBK_data$Result))
  sumna <- function(data)sum(data, na.rm = T)
  XCDENBK_sum <- tapply(XCDENBK_data$trans, XCDENBK_data$id, sumna)
  lengthna <- function(data)sum(!is.na(data))
  XCDENBK.count <- tapply(XCDENBK_data$trans, XCDENBK_data$id, lengthna)
  XCDENBK.result <- XCDENBK_sum/XCDENBK.count
  sdna <- function(data)sd(data, na.rm = T)
  XCDENBK.sd <- tapply(XCDENBK_data$trans, XCDENBK_data$id, sdna)
  
  ###Calculate XCDENMID###
  b <- which(!1:length(data$view) %in% a)
  XCDENMID_data <- data.frame(cbind(data$id[b], (data$Result[b])))
  colnames(XCDENMID_data) <- c("id", "Result")
  XCDENMID_data$trans <- 1:length(XCDENMID_data$Result)
  XCDENMID_data$trans <- (transform(XCDENMID_data$Result))
  XCDENMID_sum <- tapply(XCDENMID_data$trans, XCDENMID_data$id, sumna)
  XCDENMID.count <- tapply(XCDENMID_data$trans, XCDENMID_data$id, lengthna)
  XCDENMID.result <- XCDENMID_sum/XCDENMID.count
  XCDENMID.sd <- tapply(XCDENMID_data$trans, XCDENMID_data$id, sdna)
  
  
  ###Write to file###
  results <- cbind(XCDENMID.result, XCDENMID.count, XCDENMID.sd, XCDENBK.result, XCDENBK.count, XCDENBK.sd)

  return(results)
  
}