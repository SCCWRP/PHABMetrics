#' Calculate all PHAB metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @importFrom magrittr "%>%"
#' 
#' @examples 
#' \dontrun{
#' phabmetrics(sampdat)
#' }
phabmetrics <- function(data){
  
  # format input
  data <- phabformat(data)
  
  # chkinp threw off values of sinuosity metrics by removing rows of data
  # We should probably let the checker application check the data so users (and us) are aware of any problems with their data
  data <- chkinp(data, purge = TRUE)
  
  # calc metrics
  metrics <- list(bankmorph(data), channelmorph(data), channelsinuosity(data),
                  densiometer(data),  habitat(data), disturbance(data), flow(data),
                  misc(data), bankstability(data), quality(data), ripveg(data),
                  substrate(data), algae(data))

  # combine seprate metrics lists 
  out <- purrr::map(metrics, function(x){

    lnfrm <- x %>% 
      as.data.frame(stringsAsFactors = FALSE) %>% 
      tibble::rownames_to_column('StationCode') %>% 
      dplyr::mutate_if(is.numeric, as.character) %>% 
      tidyr::gather('var', 'val', -StationCode)
    
    return(lnfrm)
    
  }) %>% 
  do.call('rbind', .) %>% 
  dplyr::mutate(
    val = gsub('NaN', NA, val)
  ) %>% 
  tidyr::spread('var', 'val') %>% 
  dplyr::mutate_if(
    ~ !any(grepl('[a-z,A-Z]', .x)), as.numeric
    )
  
  print("out")
  print(out %>% head())
  
  #print("out$PCT_DR.sd")
  #print(out$PCT_DR.sd)
  #print("out$PCT_CF.sd")
  #print(out$PCT_CF.sd)
  #print("out$PCT_GL.sd")
  #print(out$PCT_GL.sd)
  
  return(out)
  
}
