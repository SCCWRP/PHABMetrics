globalVariables(
c('XMIAT_SDSs', 'XMIATP_SDSs', '.', 'AnalyteName', 'LocationCode', 'LocationCode2', 'Replicate', 'Result', 'SampleDate',
  'StationCode', 'VariableResult', 'dup', 'id', 'ind', 'n', 'pull',
  'trans', 'view', 'UnitName', 'val', 'FractionName', 'QACode', 'ResQualCode',
  'H_AqHab.count', 'H_AqHab.result', 'H_FlowHab.count', 'H_FlowHab.result', 
  'H_SubNat.count', 'H_SubNat.result', 'convert',
  # Global Variables from channelsinuosity.R
  'Slope','Proportion','Bearing','Elevation Difference','Length, Segment','p_slope','slope_0','slope_1','slope_2','p_bear',
  'total_proportion','total_bearing','XBEARING.count','angle','cos_','sin_',
  # Global Variables for disturbance
  'Trans','Location','W1H_BLDG.result','W1H_LDFL.result','W1H_LOG.result','W1H_MINE.result','W1H_PARK.result',
  'W1H_PSTR.result','W1H_PVMT.result','W1H_PIPE.result','W1H_ROAD.result','W1H_CROP.result','W1H_WALL.result',
  'W1H_BRDG.result','W1H_ORVY.result','W1H_VEGM.result',
  # GLOBAL VARIABLES FOR FLOW
  'FL_Q_F.result','FL_Q_F.count','MethodName','transect','FL_N_M.result','XWV_F.result','XWV_F.count','XWV_M.result','XWV_M.count',
  'MWV_M.result',
  # Global Variables for phabformat
  'SampleAgencyCode','MethodName',
  # Gloabl Variables for ripveg
  'groundCoverPresence','XPGVEG.count',
  # Global Variables for substrate
  'aggregate','value','value2','indices','median'
))

#' @importFrom stats quantile sd aggregate median na.omit
NULL

#' @importFrom utils head
NULL
