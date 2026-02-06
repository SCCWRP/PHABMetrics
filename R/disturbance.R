#' Disturbance metrics
#'
#' @param data Input data
#'
#' @export
#'
#' @examples
#' sampdat <- phabformat(sampdat)
#' disturbance(sampdat)
disturbance <- function(data) {
  # Check if we have any relevant analytes
  analytes_present_logical = data$AnalyteName %in%
    c(
      'Riparian Bridges/Abutments',
      'Riparian Buildings',
      'Riparian Landfill/Trash',
      'Riparian Logging',
      'Riparian Mining',
      'Riparian Orchards/Vineyards',
      'Riparian Park/Lawn',
      'Riparian Pasture/Range',
      'Riparian Pavement',
      'Riparian Pipes',
      'Riparian Road',
      'Riparian Row Crops',
      'Riparian Vegetation Management',
      'Riparian Wall/Dike'
    )
  if (all(!analytes_present_logical)) {
    print("Disturbance: no relevant analytes present")
    return
  }

  data <- data[
    which(analytes_present_logical),
  ]

  ###Set up###

  data2 <- gsub("(Block|Channel)(\\w)", "\\2", data$LocationCode)
  data2 <- gsub(",\\sLeft", "", data2)
  data2 <- gsub(",\\sRight", "", data2)

  reformed <- data.frame(
    data$id,
    gsub("(Block|Channel)(\\w)", "\\1", data$LocationCode),
    data2,
    data$AnalyteName,
    data$VariableResult
  )
  colnames(reformed) <- c(
    "id",
    "Location",
    "Trans",
    "AnalyteName",
    "VariableResult"
  )

  reformed$VariableResult <- as.character(reformed$VariableResult)
  reformed <- reformed %>%
    dplyr::group_by(id, AnalyteName, Trans) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      VariableResult = purrr::map(data, function(x) {
        # recode as if channel == no if channel not found
        if (!any(grepl('^Channel', x$Location))) {
          x <- x %>%
            dplyr::mutate(
              VariableResult = dplyr::case_when(
                VariableResult == 'B' ~ '1.5',
                VariableResult == 'P' ~ '0.667',
                VariableResult == 'C' ~ '1',
                VariableResult %in% c('N', 'Y') ~ NA_character_,
                VariableResult == 'Not Recorded' ~ NA_character_,
                TRUE ~ VariableResult
              )
            )

          # otherwise follow y/n ruleset
        } else {
          # get channel y/n
          chn <- x %>%
            dplyr::filter(grepl('Channel', x$Location)) %>%
            dplyr::pull(VariableResult) %>%
            as.character

          # all as 1.5 if channel is n
          if (chn == 'Y') {
            x <- x %>%
              dplyr::mutate(VariableResult = '1.5')
          }

          # recode all if channel is y
          if (chn == 'N') {
            x <- x %>%
              dplyr::mutate(
                VariableResult = dplyr::case_when(
                  VariableResult == 'B' ~ '1.5',
                  VariableResult == 'P' ~ '0.667',
                  VariableResult == 'C' ~ '1',
                  VariableResult %in% c('N', 'Y') ~ NA_character_,
                  VariableResult == 'Not Recorded' ~ NA_character_,
                  TRUE ~ VariableResult
                )
              )
          }

          # remove channel row from locationcode
          x <- x %>%
            dplyr::filter(!Location == 'Channel')
        }

        return(x)
      })
    ) %>%
    dplyr::select(-data) %>%
    tidyr::unnest() %>%
    dplyr::mutate(
      VariableResult = as.numeric(VariableResult)
    )

  sumna <- function(data) {
    sum(data, na.rm = T)
  }
  lengthna <- function(data) {
    sum(!is.na(data))
  }

  reformed <- reformed %>%
    dplyr::group_by(id, AnalyteName) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      Result = purrr::map(data, function(x) {
        sumx <- sumna(x$VariableResult)
        lenx <- lengthna(x$VariableResult)
        out <- sumx / lenx
        return(out)
      })
    ) %>%
    dplyr::mutate(
      Count = purrr::map(data, function(x) {
        return(lengthna(x$VariableResult))
      })
    ) %>%
    dplyr::mutate(
      sd = purrr::map(data, function(x) {
        return(sd(x$VariableResult, na.rm = T))
      })
    ) %>%
    dplyr::select(-data) %>%
    tidyr::unnest()

  reformed$Metric <- dplyr::case_when(
    reformed$AnalyteName == 'Riparian Wall/Dike' ~ 'W1H_WALL',
    reformed$AnalyteName == 'Riparian Buildings' ~ 'W1H_BLDG',
    reformed$AnalyteName == 'Riparian Pavement' ~ 'W1H_PVMT',
    reformed$AnalyteName == 'Riparian Road' ~ 'W1H_ROAD',
    reformed$AnalyteName == 'Riparian Pipes' ~ 'W1H_PIPE',
    reformed$AnalyteName == 'Riparian Landfill/Trash' ~ 'W1H_LDFL',
    reformed$AnalyteName == 'Riparian Park/Lawn' ~ 'W1H_PARK',
    reformed$AnalyteName == 'Riparian Row Crops' ~ 'W1H_CROP',
    reformed$AnalyteName == 'Riparian Pasture/Range' ~ 'W1H_PSTR',
    reformed$AnalyteName == 'Riparian Logging' ~ 'W1H_LOG',
    reformed$AnalyteName == 'Riparian Bridges/Abutments' ~ 'W1H_BRDG',
    reformed$AnalyteName == 'Riparian Vegetation Management' ~ 'W1H_VEGM',
    reformed$AnalyteName == 'Riparian Mining' ~ 'W1H_MINE',
    reformed$AnalyteName == 'Riparian Orchards/Vineyards' ~ 'W1H_ORVY'
  )

  ###Create the data frame###
  analytes <- unique(as.character(reformed$AnalyteName))
  statname <- c(
    "W1H_BRDG",
    "W1H_BLDG",
    "W1H_LDFL",
    "W1H_LOG",
    "W1H_MINE",
    "W1H_ORVY",
    "W1H_PARK",
    "W1H_PSTR",
    "W1H_PVMT",
    "W1H_PIPE",
    "W1H_ROAD",
    "W1H_CROP",
    "W1H_VEGM",
    "W1H_WALL"
  )

  reformed$AnalyteName <- as.character(reformed$AnalyteName)
  reformed$id <- as.character(reformed$id)

  result <- matrix(
    NA,
    nrow = length(unique(reformed$id)),
    ncol = (length(statname) * 3)
  )
  result <- as.data.frame(result)
  rownames(result) <- unique(reformed$id)
  colnames(result) <- paste(
    rep(statname, each = 3),
    c(".result", ".count", ".sd"),
    sep = ""
  )

  for (i in 1:length(statname)) {
<<<<<<< HEAD
    # Skip metric if relevant analyte not present
=======
>>>>>>> 70eda29 (Auto-format disturbance.R)
    tryCatch(
      expr = {
        metric <- as.character(statname[i])
        tmp <- reformed[which(grepl(metric, reformed$Metric)), ]
        rownames(result) <- tmp$id
        result[, paste(metric, '.result', sep = '')] <- round(tmp$Result, 2)
        result[, paste(metric, '.count', sep = '')] <- tmp$Count
        result[, paste(metric, '.sd', sep = '')] <- round(tmp$sd, 3)
      },
      error = function(e) {
        print(paste("Error with metric", metric))
        print(e)
      }
    )
  }

  #result <- result %>% dplyr::mutate_at(dplyr::vars(dplyr::contains(".sd")),round, digits = 3)

  W1_HALL_EMAP.result <- result$W1H_BLDG.result +
    result$W1H_LDFL.result +
    result$W1H_LOG.result +
    result$W1H_MINE.result +
    result$W1H_PARK.result +
    result$W1H_PSTR.result +
    result$W1H_PVMT.result +
    result$W1H_PIPE.result +
    result$W1H_ROAD.result +
    result$W1H_CROP.result +
    result$W1H_WALL.result
  W1_HALL_EMAP.count <- rowSums(
    !is.na(
      result %>%
        dplyr::select(
          W1H_BLDG.result,
          W1H_LDFL.result,
          W1H_LOG.result,
          W1H_MINE.result,
          W1H_PARK.result,
          W1H_PSTR.result,
          W1H_PVMT.result,
          W1H_PIPE.result,
          W1H_ROAD.result,
          W1H_CROP.result,
          W1H_WALL.result
        )
    )
  )

  W1_HALL_SWAMP.result <- result$W1H_BLDG.result +
    result$W1H_LDFL.result +
    result$W1H_LOG.result +
    result$W1H_MINE.result +
    result$W1H_PARK.result +
    result$W1H_PSTR.result +
    result$W1H_PVMT.result +
    result$W1H_PIPE.result +
    result$W1H_ROAD.result +
    result$W1H_CROP.result +
    result$W1H_WALL.result +
    result$W1H_BRDG.result +
    result$W1H_ORVY.result +
    result$W1H_VEGM.result
  W1_HALL_SWAMP.count <- rowSums(
    !is.na(
      result %>%
        dplyr::select(
          W1H_BLDG.result,
          W1H_LDFL.result,
          W1H_LOG.result,
          W1H_MINE.result,
          W1H_PARK.result,
          W1H_PSTR.result,
          W1H_PVMT.result,
          W1H_PIPE.result,
          W1H_ROAD.result,
          W1H_CROP.result,
          W1H_WALL.result,
          W1H_BRDG.result,
          W1H_ORVY.result,
          W1H_VEGM.result
        )
    )
  )

  results <- cbind(
    result,
    W1_HALL_EMAP.result,
    W1_HALL_EMAP.count,
    W1_HALL_SWAMP.result,
    W1_HALL_SWAMP.count
  )

  return(results)
}
