#' Channel morphology metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @examples 
#' sampdat <- phabformat(sampdat)
#' channelmorph(sampdat)
channelmorph <- function(data){

  data <- data[which(data$AnalyteName %in% c('Cascade/Falls', 'Dry', 'Glide', 'Pool', 'Rapid', 'Riffle', 'Run')),]
  ###Compute PCT_CF###
  
  PCT_CF_data <- data.frame(cbind(data$id[which(data$AnalyteName == "Cascade/Falls")], data$Result[which(data$AnalyteName == "Cascade/Falls")]))
  colnames(PCT_CF_data) <- c("id", "result")
  
  sumna <- function(data)sum(as.numeric(as.character(data)), na.rm = T) 
  sdna <- function(data)sd(data, na.rm = T)
  lengthna <- function(data)sum(!is.na(data))
  
  PCT_CF_sum <- tapply(PCT_CF_data$result, PCT_CF_data$id, sumna)
  PCT_CF.count <- tapply(PCT_CF_data$result, PCT_CF_data$id, lengthna)
  PCT_CF.result <- round(PCT_CF_sum/PCT_CF.count)
  PCT_CF.sd <- tapply(as.numeric(as.character(PCT_CF_data$result)), PCT_CF_data$id, sdna) %>% round(1)
  
  ###PCT_DR###
  
  PCT_DR_data <- data.frame(cbind(data$id[which(data$AnalyteName == "Dry")], data$Result[which(data$AnalyteName == "Dry")]))
  colnames(PCT_DR_data) <- c("id", "result")
  
  PCT_DR_sum <- tapply(PCT_DR_data$result, PCT_DR_data$id, sumna)
  PCT_DR.count <- tapply(PCT_DR_data$result, PCT_DR_data$id, lengthna)
  PCT_DR.result <- PCT_DR_sum/PCT_DR.count
  PCT_DR.sd <- tapply(as.numeric(as.character(PCT_DR_data$result)), PCT_DR_data$id, sdna)  %>% round(1)
  
  ###PCT_GL###
  
  PCT_GL_data <- data.frame(cbind(data$id[which(data$AnalyteName == "Glide")], data$Result[which(data$AnalyteName == "Glide")]))
  colnames(PCT_GL_data) <- c("id", "result")
  
  PCT_GL_sum <- tapply(PCT_GL_data$result, PCT_GL_data$id, sumna)
  PCT_GL.count <- tapply(PCT_GL_data$result, PCT_GL_data$id, lengthna)
  PCT_GL.result <- round(PCT_GL_sum/PCT_GL.count)
  PCT_GL.sd <- tapply(as.numeric(as.character(PCT_GL_data$result)), PCT_GL_data$id, sdna)  %>% round(1)
  
  ###PCT_POOL###
  
  PCT_POOL_data <- data.frame(cbind(data$id[which(data$AnalyteName == "Pool")]
                                    , data$Result[which(data$AnalyteName == "Pool")]))
  colnames(PCT_POOL_data) <- c("id", "result")
  
  PCT_POOL_sum <- tapply(PCT_POOL_data$result, PCT_POOL_data$id, sumna)
  PCT_POOL.count <- tapply(PCT_POOL_data$result, PCT_POOL_data$id, lengthna)
  PCT_POOL.result <- round(PCT_POOL_sum/PCT_POOL.count)
  PCT_POOL.sd <- tapply(as.numeric(as.character(PCT_POOL_data$result)), PCT_POOL_data$id, sdna)  %>% round(1)
  
  ###PCT_RA###
  PCT_RA_data <- data.frame(cbind(data$id[which(data$AnalyteName == "Rapid")], data$Result[which(data$AnalyteName == "Rapid")]))
  colnames(PCT_RA_data) <- c("id", "result")
  
  PCT_RA_sum <- tapply(PCT_RA_data$result, PCT_RA_data$id, sumna)
  PCT_RA.count <- tapply(PCT_RA_data$result, PCT_RA_data$id, lengthna)
  PCT_RA.result <- round(PCT_RA_sum/PCT_RA.count)
  PCT_RA.sd <- tapply(as.numeric(as.character(PCT_RA_data$result)), PCT_RA_data$id, sdna)  %>% round(1)
  
  ###PCT_RI###
  
  PCT_RI_data <- data.frame(cbind(data$id[which(data$AnalyteName == "Riffle")], data$Result[which(data$AnalyteName == "Riffle")]))
  colnames(PCT_RI_data) <- c("id", "result")
  
  PCT_RI_sum <- tapply(PCT_RI_data$result, PCT_RI_data$id, sumna)
  PCT_RI.count <- tapply(PCT_RI_data$result, PCT_RI_data$id, lengthna)
  PCT_RI.result <- round(PCT_RI_sum/PCT_RI.count)
  PCT_RI.sd <- tapply(as.numeric(as.character(PCT_RI_data$result)), PCT_RI_data$id, sdna)  %>% round(1)
  
  ###PCT_RN###
  
  PCT_RN_data <- data.frame(cbind(data$id[which(data$AnalyteName == "Run")], data$Result[which(data$AnalyteName == "Run")]))
  colnames(PCT_RN_data) <- c("id", "result")
  
  PCT_RN_sum <- tapply(PCT_RN_data$result, PCT_RN_data$id, sumna)
  PCT_RN.count <- tapply(PCT_RN_data$result, PCT_RN_data$id, lengthna)
  PCT_RN.result <- round(PCT_RN_sum/PCT_RN.count)
  PCT_RN.sd <- tapply(as.numeric(as.character(PCT_RN_data$result)), PCT_RN_data$id, sdna)  %>% round(1)
  
  ###PCT_FAST###
  
  PCT_FAST.result <- round(PCT_CF.result + PCT_RA.result + PCT_RI.result + PCT_RN.result)
  PCT_FAST.count <- rowSums(!is.na(cbind(PCT_CF.result, PCT_RA.result, PCT_RI.result, PCT_RN.result)))
  
  ###PCT_SLOW###
  
  PCT_SLOW.result <- round(PCT_GL.result + PCT_POOL.result)
  PCT_SLOW.count <- rowSums(!is.na(cbind(PCT_GL.result, PCT_POOL.result)))
  
  ###PCT_CF_WT###
  
  PCT_CF_WT1 <- (PCT_CF_sum + PCT_RA_sum + PCT_RI_sum + PCT_RN_sum + PCT_GL_sum + PCT_POOL_sum)/100
  PCT_CF_WT2 <- PCT_CF_sum*PCT_CF_WT1
  PCT_CF_WT.result <- round(PCT_CF_WT2/(PCT_CF.count*10))
  PCT_CF_WT.count<- PCT_CF.count
  
  ###PCT_GL_WT#
  
  PCT_GL_WT1 <- (PCT_CF_sum + PCT_RA_sum + PCT_RI_sum + PCT_RN_sum + PCT_GL_sum + PCT_POOL_sum)/100
  PCT_GL_WT2 <- PCT_GL_sum*PCT_GL_WT1
  PCT_GL_WT.result <- round(PCT_GL_WT2/(PCT_GL.count*10))
  PCT_GL_WT.count<- PCT_GL.count
  
  ###PCT_POOL_WT###
  
  PCT_POOL_WT1 <- (PCT_CF_sum + PCT_RA_sum + PCT_RI_sum + PCT_RN_sum + PCT_GL_sum + PCT_POOL_sum)/100
  PCT_POOL_WT2 <- PCT_POOL_sum*PCT_POOL_WT1
  PCT_POOL_WT.result <- round(PCT_POOL_WT2/(PCT_POOL.count*10))
  PCT_POOL_WT.count <- PCT_POOL.count
  
  
  ###PCT_RA_WT###
  
  PCT_RA_WT1 <- (PCT_CF_sum + PCT_RA_sum + PCT_RI_sum + PCT_RN_sum + PCT_GL_sum + PCT_POOL_sum)/100
  PCT_RA_WT2 <- PCT_RA_sum*PCT_RA_WT1
  PCT_RA_WT.result <- round(PCT_RA_WT2/(PCT_RA.count*10))
  PCT_RA_WT.count<- PCT_RA.count
  
  
  ###PCT_RI_WT###
  
  PCT_RI_WT1 <- (PCT_CF_sum + PCT_RA_sum + PCT_RI_sum + PCT_RN_sum + PCT_GL_sum + PCT_POOL_sum)/100
  PCT_RI_WT2 <- PCT_RI_sum*PCT_RI_WT1
  PCT_RI_WT.result <- round(PCT_RI_WT2/(PCT_RI.count*10))
  PCT_RI_WT.count<- PCT_RI.count
 
  
  
  ###PCT_RN_WT###
  
  PCT_RN_WT1 <- (PCT_CF_sum + PCT_RA_sum + PCT_RI_sum + PCT_RN_sum + PCT_GL_sum + PCT_POOL_sum)/100
  PCT_RN_WT2 <- PCT_RN_sum*PCT_RN_WT1
  PCT_RN_WT.result <- round(PCT_RN_WT2/(PCT_RN.count*10))
  PCT_RN_WT.count<- PCT_RN.count
  
  
  ###PCT_FAST_WT###
  
  PCT_FAST_WT.result <- round(PCT_CF_WT.result + PCT_RA_WT.result + PCT_RI_WT.result + PCT_RN_WT.result)
  PCT_FAST_WT.count <- rowSums(!is.na(cbind(PCT_CF_WT.result, PCT_RA_WT.result, PCT_RI_WT.result, PCT_RN_WT.result)))
  
  ###PCT_SLOW_WT###
  
  PCT_SLOW_WT.result <- round(PCT_GL_WT.result + PCT_POOL_WT.result)
  PCT_SLOW_WT.count <- rowSums(!is.na(cbind(PCT_GL_WT.result, PCT_POOL_WT.result)))
  
  ###Write to file###
  results <- cbind(PCT_CF.result, PCT_CF.count, PCT_CF.sd, PCT_DR.result, PCT_DR.count, PCT_DR.sd, PCT_GL.result,
                   PCT_GL.count, PCT_GL.sd, PCT_POOL.result, PCT_POOL.count, PCT_POOL.sd, PCT_RA.result, PCT_RA.count,
                   PCT_RA.sd, PCT_RI.result, PCT_RI.count, PCT_RI.sd, PCT_RN.result, PCT_RN.count, PCT_RN.sd,
                   PCT_FAST.result, PCT_SLOW.result, PCT_CF_WT.result, PCT_CF_WT.count, PCT_GL_WT.result, PCT_GL_WT.count,
                   PCT_POOL_WT.result, PCT_POOL_WT.count, PCT_RA_WT.result, PCT_RA_WT.count, PCT_RI_WT.result, 
                   PCT_RI_WT.count, PCT_RN_WT.result, PCT_RN_WT.count, PCT_FAST_WT.result, PCT_SLOW_WT.result, PCT_FAST.count, 
                   PCT_SLOW.count, PCT_FAST_WT.count, PCT_SLOW_WT.count)
  

  
  # H_FlowHab, Ev_FlowHab
  FlowHab <- data %>%
    dplyr::select(id, AnalyteName, Result) %>%
    tidyr::unnest() %>%
    dplyr::group_by(id) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      H_FlowHab.result = purrr::map(data, function(data){
        
        # step 2
        sms <- data %>% 
          dplyr::filter(!AnalyteName %in% 'Dry') %>% 
          dplyr::group_by(AnalyteName) %>% 
          dplyr::summarise(Result = sumna(Result))
        
        # step 3
        smgrz <- sum(sms$Result, na.rm = T)
        
        # step 4
        smspi <- sms$Result / smgrz
        
        # step 5
        smspimlt <- smspi * log(smspi)
        
        # step 6
        res <- sum(smspimlt, na.rm = T) * -1
        
        return(res)

      }
      ),
      H_FlowHab.count = purrr::map(data, function(data){
        
        # get number of analytes greater than zero
        cnt <- data %>% 
          dplyr::filter(!AnalyteName %in% 'Dry') %>% 
          dplyr::group_by(AnalyteName) %>% 
          dplyr::summarise(Result = sumna(Result)) %>% 
          dplyr::filter(Result > 0) %>% 
          nrow()
        
        return(cnt)
        
      }),
      Ev_FlowHab.result = purrr::pmap(list(H_FlowHab.count, H_FlowHab.result), function(H_FlowHab.count, H_FlowHab.result){
      
      if (H_FlowHab.count > 1) {
        return(round(H_FlowHab.result / log(H_FlowHab.count), 2))
      } else {
        return(0)
      }

      }),
      Ev_FlowHab.count = H_FlowHab.count
    ) %>%
    dplyr::select(-data) %>%
    tidyr::unnest() %>%
    as.data.frame(stringsAsFactors = F) %>%
    tibble::column_to_rownames('id')

  # Now we should round the H_FlowHab.result value to 2 decimal places
  FlowHab$H_FlowHab.result <- round(FlowHab$H_FlowHab.result, 2)
  
  # add H_FlowHab, Ev_FlowHab to results
  results <- as.data.frame(results, stringsAsFactors = F)
  

  
  # merge on the row names
  results <- merge(results, FlowHab, by = 'row.names') %>% tibble::column_to_rownames('Row.names')
  

  return(results)
  
}
