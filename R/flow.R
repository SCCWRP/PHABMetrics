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

  # This function is used in calculation of FL_Q_F
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

  # Subset the data to the necessary analytes. Otherwise the code breaks when we do the tidyr::spread
  data <- data[which(data$AnalyteName %in% c('Distance from Bank', 'StationWaterDepth', 'Velocity', 'Distance, Float', 'Float Time', 'Wetted Width')),]
  
  # We just knock out all the flow metrics is one go and put in in this variable called FlowMetrics
  FlowMetrics <- data %>% 
    dplyr::group_by(id) %>%
    tidyr::nest() %>%
    dplyr::mutate( 
      FL_Q_F.result = purrr::map(data, function(df){
        # FL_Q_F is only for LocationCode X. Stations that didn't use the Velocity Area method will have zero rows
        # after subsetting it this way
        df <- df[df$LocationCode == 'X',] %>% dplyr::select(-c(UnitName, VariableResult))
        # If they didn't use velocity area method, return NA
        if (df %>% nrow() == 0) {return(NA)}
        # Dealing with factors
        df$Result <- as.numeric(as.character(df$Result))
        # Spreading the data makes the calculation easier here
        df <- df %>% tidyr::spread(key = AnalyteName, value = Result)
        # Have to make sure Replicate is a number. Otherwise it doesn't get ordered correctly when we 
        # do dplyr::arrange
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
        # This is how I will get the number of non null observations that went into the calculation.
        # I'm 99% sure that there is a more efficient way of doing this
        return(sum(!is.na(calcDistances(df[['Distance from Bank']]) * df$StationWaterDepth * 0.001076 * df$Velocity)))
      }),
      FL_Q_M.result = as.numeric(as.character(FL_Q_F.result)) / 35.32, # convert Feet to Meters
      FL_Q_M.count = FL_Q_F.count,
      FL_N_M.result = purrr::map(data, function(df){
        # This code is for those stations that used the Neutral Buoyant Object Method rather than velocity area
        df <- df %>%
          dplyr::filter(MethodName == 'Neutral Buoyant Object') %>%
          dplyr::mutate(
            # Create a new column called transect that allows us to group on Upper, Middle and Lower
            transect = stringr::str_extract(LocationCode, "Upper|Middle|Lower")
          )
        # If they didn't use this method, return NA
        if (df %>% nrow() == 0) {return(NA)}
        
        # I don't know what I should comment here, to be honest. The instructions are somewhat complex
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
      FL_N_F.result = as.numeric(as.character(FL_N_M.result)) * 35.32, # Feet to Meters
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
      XWV_M.result = as.numeric(as.character(XWV_F.result)) / 3.28, # Feet to Meters
      XWV_M.count = XWV_F.count, # The counts for both metrics will be the same
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
      MWVM_F.count = XWV_M.count, # Count is same. Metric is ran on same set of numbers. 
                                  #We're just taking Max instead of Mean, 
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

