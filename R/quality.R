#' Quality metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @examples 
#' quality(sampdat)
quality <- function(data){
  data <- data[which(data$AnalyteName %in% c("Alkalinity as CaCO3", "Oxygen, Dissolved",
                                                      "pH", "Salinity", "SpecificConductivity",
                                                      "Temperature", "Turbidity")),]
  quality_metrics<- data %>% 
                    dplyr::group_by(id) %>%
                    tidyr::nest() %>%
                    dplyr::mutate(
                      XWAK.result = purrr::map(data, function(df){
                        mean(as.numeric(as.character(df[df$AnalyteName == "Alkalinity as CaCO3",]$Result)), na.rm = T) %>% round(1)
                      }),
                      XWDO.result = purrr::map(data, function(df){
                        mean(as.numeric(as.character(df[df$AnalyteName=="Oxygen, Dissolved",]$Result)), na.rm = T) %>% round(1)
                      }),
                      XWPH.result = purrr::map(data, function(df){
                        mean(as.numeric(as.character(df[df$AnalyteName == 'pH',]$Result)), na.rm = T) %>% round(2)
                      }),
                      XWSL.result = purrr::map(data, function(df){
                        mean(as.numeric(as.character(df[df$AnalyteName == "Salinity",]$Result)), na.rm = T) %>% round(1)
                      }),
                      XWSC.result = purrr::map(data, function(df){
                        mean(as.numeric(as.character(df[df$AnalyteName == "SpecificConductivity",]$Result)), na.rm = T) %>% round(1)
                      }),
                      XWTC.result = purrr::map(data, function(df){
                        mean(as.numeric(as.character(df[df$AnalyteName == "Temperature",]$Result)), na.rm = T) %>% round(1)
                      }),
                      XWTF.result = purrr::map(data, function(df){
                        round(mean(as.numeric(as.character(df[df$AnalyteName == "Temperature",]$Result)), na.rm = T) * 1.8 + 32, 1)
                      }),
                      XWTB.result = purrr::map(data, function(df){
                        mean(as.numeric(as.character(df[df$AnalyteName == "Turbidity",]$Result)), na.rm = T) %>% round(1)
                      }),
                      XWAK.count = purrr::map(data, function(df){
                        sum(!is.na(as.numeric(as.character(df[df$AnalyteName == "Alkalinity as CaCO3",]$Result))))
                      }),
                      XWDO.count = purrr::map(data, function(df){
                        sum(!is.na(as.numeric(as.character(df[df$AnalyteName=="Oxygen, Dissolved",]$Result))))
                      }),
                      XWPH.count = purrr::map(data, function(df){
                        sum(!is.na(as.numeric(as.character(df[df$AnalyteName == 'pH',]$Result))))
                      }),
                      XWSL.count = purrr::map(data, function(df){
                        sum(!is.na(as.numeric(as.character(df[df$AnalyteName == "Salinity",]$Result))))
                      }),
                      XWSC.count = purrr::map(data, function(df){
                        sum(!is.na(as.numeric(as.character(df[df$AnalyteName == "SpecificConductivity",]$Result))))
                      }),
                      XWTC.count = purrr::map(data, function(df){
                        sum(!is.na(as.numeric(as.character(df[df$AnalyteName == "Temperature",]$Result))))
                      }),
                      XWTF.count = purrr::map(data, function(df){
                        sum(!is.na(as.numeric(as.character(df[df$AnalyteName == "Temperature",]$Result))))
                      }),
                      XWTB.count = purrr::map(data, function(df){
                        sum(!is.na(as.numeric(as.character(df[df$AnalyteName == "Turbidity",]$Result))))
                      }),
                      XWAK.sd = purrr::map(data, function(df){
                        sd(as.numeric(as.character(df[df$AnalyteName == "Alkalinity as CaCO3",]$Result)), na.rm = T) %>% round(2)
                      }),
                      XWDO.sd = purrr::map(data, function(df){
                        sd(as.numeric(as.character(df[df$AnalyteName=="Oxygen, Dissolved",]$Result)), na.rm = T) %>% round(2)
                      }),
                      XWPH.sd = purrr::map(data, function(df){
                        sd(as.numeric(as.character(df[df$AnalyteName == 'pH',]$Result)), na.rm = T) %>% round(2)
                      }),
                      XWSL.sd = purrr::map(data, function(df){
                        sd(as.numeric(as.character(df[df$AnalyteName == "Salinity",]$Result)), na.rm = T) %>% round(2)
                      }),
                      XWSC.sd = purrr::map(data, function(df){
                        sd(as.numeric(as.character(df[df$AnalyteName == "SpecificConductivity",]$Result)), na.rm = T) %>% round(2)
                      }),
                      XWTC.sd = purrr::map(data, function(df){
                        sd(as.numeric(as.character(df[df$AnalyteName == "Temperature",]$Result)), na.rm = T) %>% round(2)
                      }),
                      XWTF.sd = purrr::map(data, function(df){
                        round(sd(as.numeric(as.character(df[df$AnalyteName == "Temperature",]$Result)) * 1.8 + 32, na.rm = T), 2)
                      }),
                      XWTB.sd = purrr::map(data, function(df){
                        sd(as.numeric(as.character(df[df$AnalyteName == "Turbidity",]$Result)), na.rm = T) %>% round(2)
                      })
                    ) %>% dplyr::select(-data) %>% tidyr::unnest() %>% as.data.frame

  rownames(quality_metrics) <- quality_metrics$id
  quality_metrics <- quality_metrics %>% dplyr::select(-id)
  return(quality_metrics)
  
}
