#' Channel sinuosity metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @examples 
#' sampdat <- phabformat(sampdat)
#' channelsinuosity(sampdat)
channelsinuosity <- function(data){

  data <- data[which(data$AnalyteName %in% c('Slope', 'Length, Segment', 'Elevation Difference', 'Bearing', 'Proportion', 'Length, Reach')),]
  
  # XSLOPE data ----------------------------------------------------------------------------------
  data_spread <- data %>%
    dplyr::group_by(id) %>%
    arrange(id) %>% 
    dplyr::mutate(
      Result = dplyr::case_when(
        AnalyteName == 'Proportion' ~ Result/100, # convert % to proportion
        AnalyteName == 'Elevation Difference' ~ Result/100,
        TRUE ~ Result
      )
    ) %>% 
    select(id, LocationCode, AnalyteName, Result, FractionName) %>% 
    group_by(id, LocationCode, AnalyteName, FractionName) %>% 
    mutate(grouped_id = row_number()) %>%
    spread(AnalyteName, Result) %>% 
    mutate(
      Slope = if_else(is.na(Slope), `Elevation Difference`/`Length, Segment` * 100, Slope),
      p_slope = Slope * Proportion,
      p_bear = Bearing * Proportion
    )
    
  ## XSLOPE calculation --------------------------------------------------------------------------
  XSLOPE <- data_spread %>% 
    group_by(id, LocationCode) %>%
    summarize(p_slope = sum(p_slope)) %>%
    group_by(id) %>% 
    summarize(
      XSLOPE.count = sum(na.omit(p_slope) <= 0),
      XSLOPE.result = mean(p_slope, na.rm = T),
      XSLOPE.sd = sd(p_slope, na.rm = T)
    )
    
  ## SLOPE_pcnt calculation -------------------------------------------------------------------------
  SLOPE_pcnt <- data_spread %>% 
    group_by(id, LocationCode,`Length, Segment`) %>%
    summarize(p_slope = sum(p_slope)) %>%
    group_by(id) %>% 
    mutate(
      slope_0   = p_slope <= 0,
      slope_0_5 = p_slope <= 0.5,
      slope_1   = p_slope <= 1,
      slope_2   = p_slope <= 2
    ) %>% 
    summarize(
      SLOPE_0.count = sum(slope_0),
      SLOPE_0_5.count = sum(slope_0_5),
      SLOPE_1.count = sum(slope_1),
      SLOPE_2.count = sum(slope_2),
      SLOPE_0.result = sum(`Length, Segment`[slope_0])/sum(`Length, Segment`) * 100,
      SLOPE_0_5.result = sum(`Length, Segment`[slope_0_5])/sum(`Length, Segment`) * 100,
      SLOPE_1.result = sum(`Length, Segment`[slope_1])/sum(`Length, Segment`) * 100,
      SLOPE_2.result = sum(`Length, Segment`[slope_2])/sum(`Length, Segment`) * 100
    )
  
  # XBEAR -------------------------------------------------------------------------------------
  
  XBEAR <- data_spread %>% 
    group_by(id, LocationCode, Proportion) %>%
    summarize(p_bear = sum(p_bear)) %>% 
    group_by(id) %>% 
    summarize(
      XBEARING.count = length(na.omit(p_bear)),
      XBEARING.result = sum(p_bear[Proportion == 1])/XBEARING.count,
      XBEARING.sd = sd(na.omit(p_bear))
    )
  
  # SINUS -------------------------------------------------------------------------------------
  
  SINUS <- data_spread %>% 
    group_by(id, LocationCode, FractionName) %>% 
    mutate(angle = Bearing/360 * 2*pi) %>% 
    group_by(id) %>% 
    summarize(
      cos_ = sum((`Length, Segment` * cos(angle)))^2,
      sin_ = sum((`Length, Segment` * sin(angle)))^2,
      SINUS = sum(`Length, Segment`)/sqrt(sum(cos_, sin_))
    ) %>% 
    mutate(
      cos_ = NULL,
      sin_ = NULL
    )

  
  result <- XSLOPE %>% 
    inner_join(SLOPE_pcnt, by = 'id') %>% 
    inner_join(XBEAR, by = 'id') %>% 
    inner_join(SINUS, by = 'id') %>% 
    column_to_rownames('id')

  return(result)
  
}
