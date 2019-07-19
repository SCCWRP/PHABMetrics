#' Flow metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @importFrom magrittr "%>%"
#' 
#' @examples 
#' flow(sampdat)
flow <- function(data){

  calcDistances = function(vector) {
  nreps = length(vector) # number of replicates
  res <- array() # result
  if(nreps != 1) {
    for (i in 1:nreps) {
      if (i == 1) {
        res[1] <- (vector[2] - vector[1]) / 2
      } else if (i == nreps){
        res[nreps] <- (vector[nreps] - vector[nreps - 1]) / 2
      } else {
        res[i] <- (vector[i+1] - vector[i-1]) / 2
      }
    }      
  } else {
    res[1] <- vector[1]
  } 
    return(as.vector(res))
  }

  data <- data[which(data$AnalyteName %in% c('Distance from Bank', 'StationWaterDepth', 'Velocity', 'Distance, Float', 'Float Time', 'Wetted Width')),]
  
  FlowMetrics <- data %>% 
    dplyr::group_by(id) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      FL_Q_F.result = purrr::map(data, function(df){
        df <- df[df$LocationCode == 'X',] %>% dplyr::select(-c(UnitName, VariableResult))
        if (df %>% nrow() == 0) {return(NA)}
        df$Result <- as.numeric(as.character(df$Result))
        df <- df %>% tidyr::spread(key = AnalyteName, value = Result)
        df$Replicate <- as.numeric(as.character(df$Replicate))
        df <- dplyr::arrange(df, Replicate)
        return(sum(calcDistances(df[['Distance from Bank']]) * df$StationWaterDepth * 0.001076 * df$Velocity))
      }),
      FL_Q_F.count = purrr::map(data, function(df){
        df <- df[df$LocationCode == 'X',] %>% dplyr::select(-c(UnitName, VariableResult))
        if (df %>% nrow() == 0) {return(NA)}
        df$Result <- as.numeric(as.character(df$Result))
        df <- df %>% tidyr::spread(key = AnalyteName, value = Result)
        df$Replicate <- as.numeric(as.character(df$Replicate))
        df <- dplyr::arrange(df, Replicate)
        return(sum(!is.na(calcDistances(df[['Distance from Bank']]) * df$StationWaterDepth * 0.001076 * df$Velocity)))
      }),
      FL_Q_M.result = as.numeric(as.character(FL_Q_F.result)) / 35.32,
      FL_Q_M.count = FL_Q_F.count,
      FL_N_M.result = purrr::map(data, function(df){
        df <- df %>%
          dplyr::filter(MethodName == 'Neutral Buoyant Object') %>%
          dplyr::mutate(
            transect = stringr::str_extract(LocationCode, "Upper|Middle|Lower")
          )
        if (df %>% nrow() == 0) {return(NA)}
        
        area_dataframe <- df %>% 
          filter(AnalyteName %in% c('StationWaterDepth','Wetted Width')) %>%
          group_by(transect) %>%
          tidyr::nest() %>%
          dplyr::mutate(
            areas = purrr::map(data, function(subdf){
              mean(as.numeric(as.character(subdf[which(subdf$AnalyteName == 'StationWaterDepth'),]$Result)) / 100) * as.numeric(as.character(subdf[which(subdf$AnalyteName == 'Wetted Width'),]$Result))
            })
          ) %>% select(-data) %>%
          tidyr::unnest()
        
        avg_area <- mean(area_dataframe$areas, na.rm = T)
        
        velocity_dataframe <- df %>%
          dplyr::filter(AnalyteName %in% c('Float Time','Distance, Float')) %>%
          dplyr::group_by(Replicate) %>% 
          tidyr::nest() %>% 
          dplyr::mutate(
            velocities = purrr::map(data, function(subdf){
              as.numeric(as.character(subdf[which(subdf$AnalyteName == 'Distance, Float'),]$Result)) / as.numeric(as.character(subdf[which(subdf$AnalyteName == 'Float Time'),]$Result))
            })
          ) %>% select(-data) %>%
          tidyr::unnest()
        avg_velocity <- mean(velocity_dataframe$velocities, na.rm = T)
        return(avg_area * avg_velocity)
      }),
      FL_N_F.result = as.numeric(as.character(FL_N_M.result)) * 35.32,
      XWV_F.result = purrr::map(data, function(df){
        df <- df %>% dplyr::filter(LocationCode == 'X', AnalyteName == 'Velocity')
        if (df %>% nrow() == 0) {return(NA)}
        return(mean(df$Result, na.rm = T))
      }),
      XWV_F.count = purrr::map(data, function(df){
        df <- df %>% dplyr::filter(LocationCode == 'X', AnalyteName == 'Velocity')
        if (df %>% nrow() == 0) {return(NA)}
        return(sum(!is.na(df$Result)))
      }),
      XWV_F.sd = purrr::map(data, function(df){
        df <- df %>% dplyr::filter(LocationCode == 'X', AnalyteName == 'Velocity')
        if (df %>% nrow() == 0) {return(NA)}
        return(sd(df$Result, na.rm = T))
      }),
      XWV_M.result = as.numeric(as.character(XWV_F.result)) / 3.28,
      XWV_M.count = XWV_F.count,
      XWV_M.sd = purrr::map(data, function(df){
        df <- df %>% dplyr::filter(LocationCode == 'X', AnalyteName == 'Velocity')
        if (df %>% nrow() == 0) {return(NA)}
        return(sd(df$Result / 3.28, na.rm = T))
      }),
      MWVM_F.result = purrr::map(data, function(df){
        df <- df %>% dplyr::filter(LocationCode == 'X', AnalyteName == 'Velocity')
        if (df %>% nrow() == 0) {return(NA)}
        return(max(df$Result, na.rm = T))
      }),
      MWVM_F.count = XWV_M.count,
      MWVM_M.result = as.numeric(as.character(MWVM_F.result)) / 3.28,
      MWVM_M.count = XWV_M.count,
      PWVZ.result = purrr::map(data, function(df){
        df <- df %>% dplyr::filter(LocationCode == 'X', AnalyteName == 'Velocity')
        if (df %>% nrow() == 0) {return(NA)}
        return(sum(df$Result == 0, na.rm = T) * 100 / sum(!is.na(df$Result)))
      }),
      PWVZ.count = XWV_M.count
    ) %>% select(-data) %>%
    tidyr::unnest() %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    tibble::column_to_rownames('id')
  
  
  
  FlowMetrics$FL_Q_F.result <- FlowMetrics$FL_Q_F.result %>% round(3)
  FlowMetrics$FL_Q_M.result <- FlowMetrics$FL_Q_M.result %>% round(3)
  FlowMetrics$MWVM_F.result <- FlowMetrics$MWVM_F.result %>% round(1)
  FlowMetrics$MWVM_M.result <- FlowMetrics$MWVM_M.result %>% round(1)
  FlowMetrics$XWV_M.result <- FlowMetrics$XWV_M.result %>% round(2)
  FlowMetrics$XWV_F.result <- FlowMetrics$XWV_F.result %>% round(2)
  FlowMetrics$PWVZ.result <- FlowMetrics$PWVZ.result %>% round(1)

  result <- FlowMetrics
                           
  return(result)
  
}

