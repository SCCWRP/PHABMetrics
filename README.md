
#### *Marcus W. Beck, <marcusb@sccwrp.org>, Robert Butler, <r7butler@yahoo.com>, Raphael D. Mazor, <raphaelm@sccwrp.org>, Mark Engeln*

# PHABMetrics

[![Travis-CI Build
Status](https://travis-ci.org/SCCWRP/PHABMetrics.svg?branch=master)](https://travis-ci.org/SCCWRP/PHABMetrics)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/SCCWRP/PHABMetrics?branch=master&svg=true)](https://ci.appveyor.com/project/SCCWRP/PHABMetrics)

This package provides functions to calculate PHAB metrics using field
data.

# Installing the package

The development version of this package can be installed from Github:

``` r
install.packages('devtools')
library(devtools)
install_github('SCCWRP/PHABMetrics')
library(PHABMetrics)
```

# Usage

Input data format:

``` r
head(sampdat)
```

    ##                             id StationCode SampleDate SampleAgencyCode
    ## 1 308PS0204_2013-05-21_DFW-ABL   308PS0204 2013-05-21          DFW-ABL
    ## 2 308PS0204_2013-05-21_DFW-ABL   308PS0204 2013-05-21          DFW-ABL
    ## 3 308PS0204_2013-05-21_DFW-ABL   308PS0204 2013-05-21          DFW-ABL
    ## 4 308PS0204_2013-05-21_DFW-ABL   308PS0204 2013-05-21          DFW-ABL
    ## 5 308PS0204_2013-05-21_DFW-ABL   308PS0204 2013-05-21          DFW-ABL
    ## 6 308PS0204_2013-05-21_DFW-ABL   308PS0204 2013-05-21          DFW-ABL
    ##   LocationCode Replicate    MethodName AnalyteName FractionName UnitName
    ## 1            X         1  FieldMeasure          pH         None     none
    ## 2            X         1  FieldMeasure Temperature         None    Deg C
    ## 3            X         4 Velocity Area    Velocity         None     ft/s
    ## 4            X         6 Velocity Area    Velocity         None     ft/s
    ## 5            X         8 Velocity Area    Velocity         None     ft/s
    ## 6            X        12 Velocity Area    Velocity         None     ft/s
    ##   Result ResQualCode QACode VariableResult
    ## 1     NA          NR    FEU   Not Recorded
    ## 2  15.20           =   None             NA
    ## 3   0.72           =   None             NA
    ## 4   1.12           =   None             NA
    ## 5   1.01           =   None             NA
    ## 6   0.00           =   None             NA

The core function is `phabmetrics()`. Calulcate PHAB metrics with sample
data:

``` r
alldat <- phabmetrics(sampdat)
```

    ## [1] "XWIDTHdata"
    ## [1] id     result
    ## <0 rows> (or 0-length row.names)
    ## [1] "XWIDTH.sd"
    ##  105PS0231_2013-08-29_DFW-ABL 205PS0202_2013-07-17_MPSL-DFW 
    ##                          4.03                          0.64 
    ##  308PS0204_2013-05-21_DFW-ABL 520PS0455_2013-07-22_MPSL-DFW 
    ##                          3.00                          7.49 
    ## [1] "results"
    ##                               PCT_CF.result PCT_CF.count PCT_CF.sd
    ## 105PS0231_2013-08-29_DFW-ABL              0           10       0.0
    ## 205PS0202_2013-07-17_MPSL-DFW             0           10       0.0
    ## 308PS0204_2013-05-21_DFW-ABL              0           10       0.0
    ## 520PS0455_2013-07-22_MPSL-DFW             1           10       3.2
    ##                               PCT_DR.result PCT_DR.count PCT_DR.sd
    ## 105PS0231_2013-08-29_DFW-ABL              0           10         0
    ## 205PS0202_2013-07-17_MPSL-DFW             0           10         0
    ## 308PS0204_2013-05-21_DFW-ABL              0           10         0
    ## 520PS0455_2013-07-22_MPSL-DFW             0           10         0
    ##                               PCT_GL.result PCT_GL.count PCT_GL.sd
    ## 105PS0231_2013-08-29_DFW-ABL              0           10       0.0
    ## 205PS0202_2013-07-17_MPSL-DFW            71           10      19.8
    ## 308PS0204_2013-05-21_DFW-ABL              3           10       4.8
    ## 520PS0455_2013-07-22_MPSL-DFW            48           10      25.2
    ##                               PCT_POOL.result PCT_POOL.count PCT_POOL.sd
    ## 105PS0231_2013-08-29_DFW-ABL                0             10         0.0
    ## 205PS0202_2013-07-17_MPSL-DFW               0             10         0.0
    ## 308PS0204_2013-05-21_DFW-ABL                1             10         3.2
    ## 520PS0455_2013-07-22_MPSL-DFW              14             10        23.1
    ##                               PCT_RA.result PCT_RA.count PCT_RA.sd
    ## 105PS0231_2013-08-29_DFW-ABL              0           10         0
    ## 205PS0202_2013-07-17_MPSL-DFW             0           10         0
    ## 308PS0204_2013-05-21_DFW-ABL              0           10         0
    ## 520PS0455_2013-07-22_MPSL-DFW             0           10         0
    ##                               PCT_RI.result PCT_RI.count PCT_RI.sd
    ## 105PS0231_2013-08-29_DFW-ABL              0           10       0.0
    ## 205PS0202_2013-07-17_MPSL-DFW            29           10      19.8
    ## 308PS0204_2013-05-21_DFW-ABL             94           10       8.4
    ## 520PS0455_2013-07-22_MPSL-DFW            22           10      31.6
    ##                               PCT_RN.result PCT_RN.count PCT_RN.sd
    ## 105PS0231_2013-08-29_DFW-ABL            100           10       0.0
    ## 205PS0202_2013-07-17_MPSL-DFW             0           10       0.0
    ## 308PS0204_2013-05-21_DFW-ABL              2           10       4.2
    ## 520PS0455_2013-07-22_MPSL-DFW            14           10      19.6
    ##                               PCT_FAST.result PCT_SLOW.result
    ## 105PS0231_2013-08-29_DFW-ABL              100               0
    ## 205PS0202_2013-07-17_MPSL-DFW              29              71
    ## 308PS0204_2013-05-21_DFW-ABL               96               4
    ## 520PS0455_2013-07-22_MPSL-DFW              37              62
    ##                               PCT_CF_WT.result PCT_CF_WT.count
    ## 105PS0231_2013-08-29_DFW-ABL                 0              10
    ## 205PS0202_2013-07-17_MPSL-DFW                0              10
    ## 308PS0204_2013-05-21_DFW-ABL                 0              10
    ## 520PS0455_2013-07-22_MPSL-DFW                1              10
    ##                               PCT_GL_WT.result PCT_GL_WT.count
    ## 105PS0231_2013-08-29_DFW-ABL                 0              10
    ## 205PS0202_2013-07-17_MPSL-DFW               71              10
    ## 308PS0204_2013-05-21_DFW-ABL                 3              10
    ## 520PS0455_2013-07-22_MPSL-DFW               48              10
    ##                               PCT_POOL_WT.result PCT_POOL_WT.count
    ## 105PS0231_2013-08-29_DFW-ABL                   0                10
    ## 205PS0202_2013-07-17_MPSL-DFW                  0                10
    ## 308PS0204_2013-05-21_DFW-ABL                   1                10
    ## 520PS0455_2013-07-22_MPSL-DFW                 14                10
    ##                               PCT_RA_WT.result PCT_RA_WT.count
    ## 105PS0231_2013-08-29_DFW-ABL                 0              10
    ## 205PS0202_2013-07-17_MPSL-DFW                0              10
    ## 308PS0204_2013-05-21_DFW-ABL                 0              10
    ## 520PS0455_2013-07-22_MPSL-DFW                0              10
    ##                               PCT_RI_WT.result PCT_RI_WT.count
    ## 105PS0231_2013-08-29_DFW-ABL                 0              10
    ## 205PS0202_2013-07-17_MPSL-DFW               29              10
    ## 308PS0204_2013-05-21_DFW-ABL                94              10
    ## 520PS0455_2013-07-22_MPSL-DFW               22              10
    ##                               PCT_RN_WT.result PCT_RN_WT.count
    ## 105PS0231_2013-08-29_DFW-ABL               100              10
    ## 205PS0202_2013-07-17_MPSL-DFW                0              10
    ## 308PS0204_2013-05-21_DFW-ABL                 2              10
    ## 520PS0455_2013-07-22_MPSL-DFW               14              10
    ##                               PCT_FAST_WT.result PCT_SLOW_WT.result
    ## 105PS0231_2013-08-29_DFW-ABL                 100                  0
    ## 205PS0202_2013-07-17_MPSL-DFW                 29                 71
    ## 308PS0204_2013-05-21_DFW-ABL                  96                  4
    ## 520PS0455_2013-07-22_MPSL-DFW                 37                 62
    ##                               PCT_FAST.count PCT_SLOW.count
    ## 105PS0231_2013-08-29_DFW-ABL               4              2
    ## 205PS0202_2013-07-17_MPSL-DFW              4              2
    ## 308PS0204_2013-05-21_DFW-ABL               4              2
    ## 520PS0455_2013-07-22_MPSL-DFW              4              2
    ##                               PCT_FAST_WT.count PCT_SLOW_WT.count
    ## 105PS0231_2013-08-29_DFW-ABL                  4                 2
    ## 205PS0202_2013-07-17_MPSL-DFW                 4                 2
    ## 308PS0204_2013-05-21_DFW-ABL                  4                 2
    ## 520PS0455_2013-07-22_MPSL-DFW                 4                 2
    ##                               H_FlowHab.result H_FlowHab.count
    ## 105PS0231_2013-08-29_DFW-ABL              0.00               1
    ## 205PS0202_2013-07-17_MPSL-DFW             0.60               2
    ## 308PS0204_2013-05-21_DFW-ABL              0.29               4
    ## 520PS0455_2013-07-22_MPSL-DFW             1.29               5
    ##                               Ev_FlowHab.result Ev_FlowHab.count
    ## 105PS0231_2013-08-29_DFW-ABL               0.00                1
    ## 205PS0202_2013-07-17_MPSL-DFW              0.87                2
    ## 308PS0204_2013-05-21_DFW-ABL               0.21                4
    ## 520PS0455_2013-07-22_MPSL-DFW              0.80                5
    ## [1] "results$PCT_CF.sd"
    ## [1] 0.0 0.0 0.0 3.2
    ## [1] "results$PCT_DR.sd"
    ## [1] 0 0 0 0
    ## [1] "results$PCT_GL.sd"
    ## [1]  0.0 19.8  4.8 25.2
    ## [1] "W1H_BRDG"
    ## # A tibble: 4 x 6
    ##   id                      AnalyteName            Result Count    sd Metric 
    ##   <chr>                   <chr>                   <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_D~ Riparian Bridges/Abut~      0    22     0 W1H_BR~
    ## 2 205PS0202_2013-07-17_M~ Riparian Bridges/Abut~      0    22     0 W1H_BR~
    ## 3 520PS0455_2013-07-22_M~ Riparian Bridges/Abut~      0    22     0 W1H_BR~
    ## 4 105PS0231_2013-08-29_D~ Riparian Bridges/Abut~      0    22     0 W1H_BR~
    ## [1] "W1H_BLDG"
    ## # A tibble: 4 x 6
    ##   id                          AnalyteName        Result Count    sd Metric 
    ##   <chr>                       <chr>               <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_DFW-A~ Riparian Buildings  0        22 0     W1H_BL~
    ## 2 205PS0202_2013-07-17_MPSL-~ Riparian Buildings  0.728    22 0.131 W1H_BL~
    ## 3 520PS0455_2013-07-22_MPSL-~ Riparian Buildings  0.182    22 0.304 W1H_BL~
    ## 4 105PS0231_2013-08-29_DFW-A~ Riparian Buildings  0        22 0     W1H_BL~
    ## [1] "W1H_LDFL"
    ## # A tibble: 4 x 6
    ##   id                       AnalyteName           Result Count    sd Metric 
    ##   <chr>                    <chr>                  <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_DF~ Riparian Landfill/Tr~  0.25     22 0.551 W1H_LD~
    ## 2 205PS0202_2013-07-17_MP~ Riparian Landfill/Tr~  0.477    22 0.715 W1H_LD~
    ## 3 520PS0455_2013-07-22_MP~ Riparian Landfill/Tr~  0.136    22 0.441 W1H_LD~
    ## 4 105PS0231_2013-08-29_DF~ Riparian Landfill/Tr~  0        22 0     W1H_LD~
    ## [1] "W1H_LOG"
    ## # A tibble: 4 x 6
    ##   id                            AnalyteName      Result Count    sd Metric 
    ##   <chr>                         <chr>             <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_DFW-ABL  Riparian Logging      0    22     0 W1H_LOG
    ## 2 205PS0202_2013-07-17_MPSL-DFW Riparian Logging      0    22     0 W1H_LOG
    ## 3 520PS0455_2013-07-22_MPSL-DFW Riparian Logging      0    22     0 W1H_LOG
    ## 4 105PS0231_2013-08-29_DFW-ABL  Riparian Logging      0    22     0 W1H_LOG
    ## [1] "W1H_MINE"
    ## # A tibble: 4 x 6
    ##   id                            AnalyteName     Result Count    sd Metric  
    ##   <chr>                         <chr>            <dbl> <int> <dbl> <chr>   
    ## 1 308PS0204_2013-05-21_DFW-ABL  Riparian Mining      0    22     0 W1H_MINE
    ## 2 205PS0202_2013-07-17_MPSL-DFW Riparian Mining      0    22     0 W1H_MINE
    ## 3 520PS0455_2013-07-22_MPSL-DFW Riparian Mining      0    22     0 W1H_MINE
    ## 4 105PS0231_2013-08-29_DFW-ABL  Riparian Mining      0    22     0 W1H_MINE
    ## [1] "W1H_ORVY"
    ## # A tibble: 4 x 6
    ##   id                      AnalyteName            Result Count    sd Metric 
    ##   <chr>                   <chr>                   <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_D~ Riparian Orchards/Vin~      0    22     0 W1H_OR~
    ## 2 205PS0202_2013-07-17_M~ Riparian Orchards/Vin~      0    22     0 W1H_OR~
    ## 3 520PS0455_2013-07-22_M~ Riparian Orchards/Vin~      0    22     0 W1H_OR~
    ## 4 105PS0231_2013-08-29_D~ Riparian Orchards/Vin~      0    22     0 W1H_OR~
    ## [1] "W1H_PARK"
    ## # A tibble: 4 x 6
    ##   id                          AnalyteName        Result Count    sd Metric 
    ##   <chr>                       <chr>               <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_DFW-A~ Riparian Park/Lawn  0        22 0     W1H_PA~
    ## 2 205PS0202_2013-07-17_MPSL-~ Riparian Park/Lawn  0.114    22 0.376 W1H_PA~
    ## 3 520PS0455_2013-07-22_MPSL-~ Riparian Park/Lawn  0        22 0     W1H_PA~
    ## 4 105PS0231_2013-08-29_DFW-A~ Riparian Park/Lawn  0        22 0     W1H_PA~
    ## [1] "W1H_PSTR"
    ## # A tibble: 4 x 6
    ##   id                        AnalyteName          Result Count    sd Metric 
    ##   <chr>                     <chr>                 <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_DFW~ Riparian Pasture/Ra~      0    22     0 W1H_PS~
    ## 2 205PS0202_2013-07-17_MPS~ Riparian Pasture/Ra~      0    22     0 W1H_PS~
    ## 3 520PS0455_2013-07-22_MPS~ Riparian Pasture/Ra~      0    22     0 W1H_PS~
    ## 4 105PS0231_2013-08-29_DFW~ Riparian Pasture/Ra~      0    22     0 W1H_PS~
    ## [1] "W1H_PVMT"
    ## # A tibble: 4 x 6
    ##   id                           AnalyteName       Result Count    sd Metric 
    ##   <chr>                        <chr>              <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_DFW-ABL Riparian Pavement 0.0303    22 0.142 W1H_PV~
    ## 2 205PS0202_2013-07-17_MPSL-D~ Riparian Pavement 0         22 0     W1H_PV~
    ## 3 520PS0455_2013-07-22_MPSL-D~ Riparian Pavement 0.273     22 0.336 W1H_PV~
    ## 4 105PS0231_2013-08-29_DFW-ABL Riparian Pavement 0         22 0     W1H_PV~
    ## [1] "W1H_PIPE"
    ## # A tibble: 4 x 6
    ##   id                            AnalyteName    Result Count    sd Metric  
    ##   <chr>                         <chr>           <dbl> <int> <dbl> <chr>   
    ## 1 308PS0204_2013-05-21_DFW-ABL  Riparian Pipes      0    22     0 W1H_PIPE
    ## 2 205PS0202_2013-07-17_MPSL-DFW Riparian Pipes      0    22     0 W1H_PIPE
    ## 3 520PS0455_2013-07-22_MPSL-DFW Riparian Pipes      0    22     0 W1H_PIPE
    ## 4 105PS0231_2013-08-29_DFW-ABL  Riparian Pipes      0    22     0 W1H_PIPE
    ## [1] "W1H_ROAD"
    ## # A tibble: 4 x 6
    ##   id                            AnalyteName   Result Count    sd Metric  
    ##   <chr>                         <chr>          <dbl> <int> <dbl> <chr>   
    ## 1 308PS0204_2013-05-21_DFW-ABL  Riparian Road 0.243     22 0.328 W1H_ROAD
    ## 2 205PS0202_2013-07-17_MPSL-DFW Riparian Road 0         22 0     W1H_ROAD
    ## 3 520PS0455_2013-07-22_MPSL-DFW Riparian Road 0.0455    22 0.213 W1H_ROAD
    ## 4 105PS0231_2013-08-29_DFW-ABL  Riparian Road 0         22 0     W1H_ROAD
    ## [1] "W1H_CROP"
    ## # A tibble: 4 x 6
    ##   id                          AnalyteName        Result Count    sd Metric 
    ##   <chr>                       <chr>               <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_DFW-A~ Riparian Row Crops      0    22     0 W1H_CR~
    ## 2 205PS0202_2013-07-17_MPSL-~ Riparian Row Crops      0    22     0 W1H_CR~
    ## 3 520PS0455_2013-07-22_MPSL-~ Riparian Row Crops      0    22     0 W1H_CR~
    ## 4 105PS0231_2013-08-29_DFW-A~ Riparian Row Crops      0    22     0 W1H_CR~
    ## [1] "W1H_VEGM"
    ## # A tibble: 4 x 6
    ##   id                    AnalyteName              Result Count    sd Metric 
    ##   <chr>                 <chr>                     <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21~ Riparian Vegetation Man~      0    22     0 W1H_VE~
    ## 2 205PS0202_2013-07-17~ Riparian Vegetation Man~      0    22     0 W1H_VE~
    ## 3 520PS0455_2013-07-22~ Riparian Vegetation Man~      0    22     0 W1H_VE~
    ## 4 105PS0231_2013-08-29~ Riparian Vegetation Man~      0    22     0 W1H_VE~
    ## [1] "W1H_WALL"
    ## # A tibble: 4 x 6
    ##   id                          AnalyteName        Result Count    sd Metric 
    ##   <chr>                       <chr>               <dbl> <int> <dbl> <chr>  
    ## 1 308PS0204_2013-05-21_DFW-A~ Riparian Wall/Dike  0.136    22 0.441 W1H_WA~
    ## 2 205PS0202_2013-07-17_MPSL-~ Riparian Wall/Dike  0.545    22 0.575 W1H_WA~
    ## 3 520PS0455_2013-07-22_MPSL-~ Riparian Wall/Dike  0.636    22 0.727 W1H_WA~
    ## 4 105PS0231_2013-08-29_DFW-A~ Riparian Wall/Dike  0        22 0     W1H_WA~

    ## Warning: NAs introduced by coercion
    
    ## Warning: NAs introduced by coercion

    ## Warning in max(df$Result, na.rm = T): no non-missing arguments to max;
    ## returning -Inf

    ## # A tibble: 22 x 8
    ##    SampleAgencyCode LocationCode MethodName `Riparian Groun~
    ##    <chr>            <chr>        <chr>      <chr>           
    ##  1 DFW-ABL          BlockA, Left FieldObse~ 2               
    ##  2 DFW-ABL          BlockA, Rig~ FieldObse~ 3               
    ##  3 DFW-ABL          BlockB, Left FieldObse~ 2               
    ##  4 DFW-ABL          BlockB, Rig~ FieldObse~ 4               
    ##  5 DFW-ABL          BlockC, Left FieldObse~ 2               
    ##  6 DFW-ABL          BlockC, Rig~ FieldObse~ 4               
    ##  7 DFW-ABL          BlockD, Left FieldObse~ 4               
    ##  8 DFW-ABL          BlockD, Rig~ FieldObse~ 4               
    ##  9 DFW-ABL          BlockE, Left FieldObse~ 2               
    ## 10 DFW-ABL          BlockE, Rig~ FieldObse~ 4               
    ## # ... with 12 more rows, and 4 more variables: `Riparian GroundCover Woody
    ## #   Shrubs` <chr>, `Riparian Lower Canopy All Vegetation` <chr>, `Riparian
    ## #   Upper Canopy All Trees` <chr>, GroundCoverPresence <lgl>
    ## [1] 22
    ## [1] 22
    ## # A tibble: 22 x 8
    ##    SampleAgencyCode LocationCode MethodName `Riparian Groun~
    ##    <chr>            <chr>        <chr>      <chr>           
    ##  1 MPSL-DFW         BlockA, Left FieldObse~ 3               
    ##  2 MPSL-DFW         BlockA, Rig~ FieldObse~ 0               
    ##  3 MPSL-DFW         BlockB, Left FieldObse~ 3               
    ##  4 MPSL-DFW         BlockB, Rig~ FieldObse~ 1               
    ##  5 MPSL-DFW         BlockC, Left FieldObse~ 1               
    ##  6 MPSL-DFW         BlockC, Rig~ FieldObse~ 1               
    ##  7 MPSL-DFW         BlockD, Left FieldObse~ 1               
    ##  8 MPSL-DFW         BlockD, Rig~ FieldObse~ 0               
    ##  9 MPSL-DFW         BlockE, Left FieldObse~ 0               
    ## 10 MPSL-DFW         BlockE, Rig~ FieldObse~ 1               
    ## # ... with 12 more rows, and 4 more variables: `Riparian GroundCover Woody
    ## #   Shrubs` <chr>, `Riparian Lower Canopy All Vegetation` <chr>, `Riparian
    ## #   Upper Canopy All Trees` <chr>, GroundCoverPresence <lgl>
    ## [1] 22
    ## [1] 20
    ## # A tibble: 22 x 8
    ##    SampleAgencyCode LocationCode MethodName `Riparian Groun~
    ##    <chr>            <chr>        <chr>      <chr>           
    ##  1 DFW-ABL          BlockA, Left FieldObse~ 1               
    ##  2 DFW-ABL          BlockA, Rig~ FieldObse~ 1               
    ##  3 DFW-ABL          BlockB, Left FieldObse~ 1               
    ##  4 DFW-ABL          BlockB, Rig~ FieldObse~ 2               
    ##  5 DFW-ABL          BlockC, Left FieldObse~ 0               
    ##  6 DFW-ABL          BlockC, Rig~ FieldObse~ 1               
    ##  7 DFW-ABL          BlockD, Left FieldObse~ 1               
    ##  8 DFW-ABL          BlockD, Rig~ FieldObse~ 1               
    ##  9 DFW-ABL          BlockE, Left FieldObse~ 2               
    ## 10 DFW-ABL          BlockE, Rig~ FieldObse~ 1               
    ## # ... with 12 more rows, and 4 more variables: `Riparian GroundCover Woody
    ## #   Shrubs` <chr>, `Riparian Lower Canopy All Vegetation` <chr>, `Riparian
    ## #   Upper Canopy All Trees` <chr>, GroundCoverPresence <lgl>
    ## [1] 22
    ## [1] 17
    ## # A tibble: 22 x 8
    ##    SampleAgencyCode LocationCode MethodName `Riparian Groun~
    ##    <chr>            <chr>        <chr>      <chr>           
    ##  1 MPSL-DFW         BlockA, Left FieldObse~ 2               
    ##  2 MPSL-DFW         BlockA, Rig~ FieldObse~ 3               
    ##  3 MPSL-DFW         BlockB, Left FieldObse~ 3               
    ##  4 MPSL-DFW         BlockB, Rig~ FieldObse~ 2               
    ##  5 MPSL-DFW         BlockC, Left FieldObse~ 3               
    ##  6 MPSL-DFW         BlockC, Rig~ FieldObse~ 1               
    ##  7 MPSL-DFW         BlockD, Left FieldObse~ 1               
    ##  8 MPSL-DFW         BlockD, Rig~ FieldObse~ 2               
    ##  9 MPSL-DFW         BlockE, Left FieldObse~ 2               
    ## 10 MPSL-DFW         BlockE, Rig~ FieldObse~ 1               
    ## # ... with 12 more rows, and 4 more variables: `Riparian GroundCover Woody
    ## #   Shrubs` <chr>, `Riparian Lower Canopy All Vegetation` <chr>, `Riparian
    ## #   Upper Canopy All Trees` <chr>, GroundCoverPresence <lgl>
    ## [1] 22
    ## [1] 21
    ## [1] "PCT_MAP.count"
    ##  105PS0231_2013-08-29_DFW-ABL 205PS0202_2013-07-17_MPSL-DFW 
    ##                           105                           103 
    ##  308PS0204_2013-05-21_DFW-ABL 520PS0455_2013-07-22_MPSL-DFW 
    ##                           103                            90 
    ## [1] "out$PCT_DR.sd"
    ## [1] 0 0 0 0
    ## [1] "out$PCT_CF.sd"
    ## [1] 0.0 0.0 0.0 3.2
    ## [1] "out$PCT_GL.sd"
    ## [1]  0.0 19.8  4.8 25.2

The following 159 metrics are calculated:

    ##   [1] "CFC_ALG"       "CFC_ALL_EMAP"  "CFC_ALL_SWAMP" "CFC_AQM"      
    ##   [5] "CFC_BRS"       "CFC_HUM"       "CFC_LTR"       "CFC_LWD"      
    ##   [9] "CFC_OHV"       "CFC_RCK"       "CFC_UCB"       "Ev_AqHab"     
    ##  [13] "Ev_FlowHab"    "Ev_SubNat"     "FL_N_F"        "FL_N_M"       
    ##  [17] "FL_Q_F"        "FL_Q_M"        "H_AqHab"       "H_FlowHab"    
    ##  [21] "H_SubNat"      "MWVM_F"        "MWVM_M"        "NFC_DLU"      
    ##  [25] "NFC_EFR"       "NFC_ERN"       "PBM_E"         "PBM_S"        
    ##  [29] "PBM_V"         "PCT_BDRK"      "PCT_BIGR"      "PCT_CB"       
    ##  [33] "PCT_CF"        "PCT_CF_WT"     "PCT_CPOM"      "PCT_DR"       
    ##  [37] "PCT_FAST"      "PCT_FAST_WT"   "PCT_FN"        "PCT_GC"       
    ##  [41] "PCT_GF"        "PCT_GL"        "PCT_GL_WT"     "PCT_HP"       
    ##  [45] "PCT_MAA"       "PCT_MAP"       "PCT_MAU"       "PCT_MCP"      
    ##  [49] "PCT_MIAT1"     "PCT_MIAT1P"    "PCT_MIATP"     "PCT_NSA"      
    ##  [53] "PCT_OT"        "PCT_POOL"      "PCT_POOL_WT"   "PCT_RA"       
    ##  [57] "PCT_RA_WT"     "PCT_RC"        "PCT_RI"        "PCT_RI_WT"    
    ##  [61] "PCT_RN"        "PCT_RN_WT"     "PCT_RR"        "PCT_RS"       
    ##  [65] "PCT_SA"        "PCT_SAFN"      "PCT_SB"        "PCT_SFGF"     
    ##  [69] "PCT_SLOW"      "PCT_SLOW_WT"   "PCT_WD"        "PCT_XB"       
    ##  [73] "PWVZ"          "RBP_CHN"       "RBP_EPI"       "RBP_SED"      
    ##  [77] "SB_PP_D10"     "SB_PP_D25"     "SB_PP_D50"     "SB_PP_D75"    
    ##  [81] "SB_PP_D90"     "SB_PT_D10"     "SB_PT_D25"     "SB_PT_D50"    
    ##  [85] "SB_PT_D75"     "SB_PT_D90"     "SINU"          "SLOPE_0"      
    ##  [89] "SLOPE_0_5"     "SLOPE_1"       "SLOPE_2"       "W1_HALL_EMAP" 
    ##  [93] "W1_HALL_SWAMP" "W1H_BLDG"      "W1H_BRDG"      "W1H_CROP"     
    ##  [97] "W1H_LDFL"      "W1H_LOG"       "W1H_MINE"      "W1H_ORVY"     
    ## [101] "W1H_PARK"      "W1H_PIPE"      "W1H_PSTR"      "W1H_PVMT"     
    ## [105] "W1H_ROAD"      "W1H_VEGM"      "W1H_WALL"      "XBEARING"     
    ## [109] "XBKF_H"        "XBKF_W"        "XC"            "XCDENBK"      
    ## [113] "XCDENMID"      "XCM"           "XCMG"          "XEMBED"       
    ## [117] "XFC_ALG"       "XFC_AQM"       "XFC_BIG"       "XFC_BRS"      
    ## [121] "XFC_HUM"       "XFC_LTR"       "XFC_LWD"       "XFC_NAT_EMAP" 
    ## [125] "XFC_NAT_SWAMP" "XFC_OHV"       "XFC_RCK"       "XFC_UCB"      
    ## [129] "XG"            "XGB"           "XGH"           "XGW"          
    ## [133] "XM"            "XMIAT"         "XMIATP"        "XPCAN"        
    ## [137] "XPCM"          "XPCMG"         "XPGVEG"        "XPMGVEG"      
    ## [141] "XPMID"         "XSDGM"         "XSLOPE"        "XSPGM"        
    ## [145] "XWAK"          "XWDA"          "XWDEPTH"       "XWDM"         
    ## [149] "XWDO"          "XWDR"          "XWIDTH"        "XWPH"         
    ## [153] "XWSC"          "XWSL"          "XWTB"          "XWTC"         
    ## [157] "XWTF"          "XWV_F"         "XWV_M"

``` r
alldat
```

    ##                     StationCode CFC_ALG.count CFC_ALG.result
    ## 1  105PS0231_2013-08-29_DFW-ABL            11              2
    ## 2 205PS0202_2013-07-17_MPSL-DFW            11              3
    ## 3  308PS0204_2013-05-21_DFW-ABL            11              4
    ## 4 520PS0455_2013-07-22_MPSL-DFW            11             11
    ##   CFC_ALL_EMAP.count CFC_ALL_EMAP.result CFC_ALL_SWAMP.count
    ## 1                  8                   5                   9
    ## 2                  8                   7                   9
    ## 3                  8                   7                   9
    ## 4                  8                   8                   9
    ##   CFC_ALL_SWAMP.result CFC_AQM.count CFC_AQM.result CFC_BRS.count
    ## 1                    6            11             11            11
    ## 2                    8            11             10            11
    ## 3                    8            11              2            11
    ## 4                    9            11             10            11
    ##   CFC_BRS.result CFC_HUM.count CFC_HUM.result CFC_LTR.count CFC_LTR.result
    ## 1              4            11              0            11              9
    ## 2             10            11              5            11             11
    ## 3             10            11              0            11              6
    ## 4             11            11             11            11              9
    ##   CFC_LWD.count CFC_LWD.result CFC_OHV.count CFC_OHV.result CFC_RCK.count
    ## 1            11              0            11             11            11
    ## 2            11              0            11             10            11
    ## 3            11              3            11              7            11
    ## 4            11             10            11             11            11
    ##   CFC_RCK.result CFC_UCB.count CFC_UCB.result Ev_AqHab.count
    ## 1              0            11              4              6
    ## 2             11            11             11              7
    ## 3             11            11              3              8
    ## 4             11            11             10              8
    ##   Ev_AqHab.result Ev_FlowHab.count Ev_FlowHab.result Ev_SubNat.count
    ## 1            0.50                1              0.00               8
    ## 2            0.89                2              0.87               6
    ## 3            0.78                4              0.21               7
    ## 4            0.77                5              0.80               8
    ##   Ev_SubNat.result FL_N_F.result FL_N_M.result FL_Q_F.count FL_Q_F.result
    ## 1             0.65            NA            NA            0            NA
    ## 2             0.79            NA            NA           11         1.202
    ## 3             0.87            NA            NA           12        17.163
    ## 4             0.71            NA            NA           14        70.402
    ##   FL_Q_M.count FL_Q_M.result H_AqHab.count H_AqHab.result H_FlowHab.count
    ## 1            0            NA             6           0.89               1
    ## 2           11         0.034             7           1.73               2
    ## 3           12         0.486             8           1.63               4
    ## 4           14         1.993             8           1.60               5
    ##   H_FlowHab.result H_SubNat.count H_SubNat.result MWVM_F.count
    ## 1             0.00              8            1.36            0
    ## 2             0.60              6            1.41           11
    ## 3             0.29              7            1.70           12
    ## 4             1.29              8            1.47           14
    ##   MWVM_F.result MWVM_M.count MWVM_M.result   NFC_DLU.result NFC_EFR.result
    ## 1          -Inf            0          -Inf            Range             NO
    ## 2           0.4           11           0.1   Suburban, Town             NO
    ## 3           1.1           12           0.3           Forest             NO
    ## 4           2.7           14           0.8 Urban/Industrial             NO
    ##   NFC_ERN.result PBM_E.count PBM_E.result PBM_S.count PBM_S.result
    ## 1             NO          22           23          22            0
    ## 2             NO          22           86          22            5
    ## 3             NO          22            5          22           82
    ## 4             NO          22            9          22            0
    ##   PBM_V.count PBM_V.result PCT_BDRK.count PCT_BDRK.result PCT_BIGR.count
    ## 1          22           77              2               0              6
    ## 2          22            9              2               0              6
    ## 3          22           14              2               0              6
    ## 4          22           91              2               0              6
    ##   PCT_BIGR.result PCT_CB.count PCT_CB.result PCT_CF.count PCT_CF.result
    ## 1              30          105             5           10             0
    ## 2              71          105            23           10             0
    ## 3              59          105            28           10             0
    ## 4              71          105            45           10             1
    ##   PCT_CF.sd PCT_CF_WT.count PCT_CF_WT.result PCT_CPOM.count
    ## 1       0.0              10                0            105
    ## 2       0.0              10                0            105
    ## 3       0.0              10                0            104
    ## 4       3.2              10                1             95
    ##   PCT_CPOM.result PCT_DR.count PCT_DR.result PCT_DR.sd PCT_FAST.count
    ## 1              19           10             0         0              4
    ## 2              84           10             0         0              4
    ## 3              12           10             0         0              4
    ## 4              82           10             0         0              4
    ##   PCT_FAST.result PCT_FAST_WT.count PCT_FAST_WT.result PCT_FN.count
    ## 1             100                 4                100          105
    ## 2              29                 4                 29          105
    ## 3              96                 4                 96          105
    ## 4              37                 4                 37          105
    ##   PCT_FN.result PCT_GC.count PCT_GC.result PCT_GF.count PCT_GF.result
    ## 1             1          105            23          105            19
    ## 2             3          105            49          105            10
    ## 3             4          105            18          105             9
    ## 4             0          105            17          105             1
    ##   PCT_GL.count PCT_GL.result PCT_GL.sd PCT_GL_WT.count PCT_GL_WT.result
    ## 1           10             0       0.0              10                0
    ## 2           10            71      19.8              10               71
    ## 3           10             3       4.8              10                3
    ## 4           10            48      25.2              10               48
    ##   PCT_HP.count PCT_HP.result PCT_MAA.count PCT_MAA.result PCT_MAP.count
    ## 1          105             1           105              2           105
    ## 2          105             0           105             16           103
    ## 3          105             0           104              9           103
    ## 4          105             1            95             56            90
    ##   PCT_MAP.result PCT_MAU.count PCT_MAU.result PCT_MCP.count PCT_MCP.result
    ## 1              2           105              0           105             82
    ## 2             18           105              0           105              0
    ## 3              9           104              0           104              0
    ## 4             57            95              0            95              2
    ##   PCT_MIAT1.count PCT_MIAT1.result PCT_MIAT1P.count PCT_MIAT1P.result
    ## 1             101                0               26                 0
    ## 2             105                0               41                 0
    ## 3              71                0               59                 0
    ## 4              95                0                3                 0
    ##   PCT_MIATP.count PCT_MIATP.result PCT_NSA.count PCT_NSA.result
    ## 1             101               26           105              2
    ## 2             105               39           102             19
    ## 3              71               83           101              9
    ## 4              95                3            80             64
    ##   PCT_OT.count PCT_OT.result PCT_POOL.count PCT_POOL.result PCT_POOL.sd
    ## 1          105             0             10               0         0.0
    ## 2          105             0             10               0         0.0
    ## 3          105             0             10               1         3.2
    ## 4          105             0             10              14        23.1
    ##   PCT_POOL_WT.count PCT_POOL_WT.result PCT_RA.count PCT_RA.result
    ## 1                10                  0           10             0
    ## 2                10                  0           10             0
    ## 3                10                  1           10             0
    ## 4                10                 14           10             0
    ##   PCT_RA.sd PCT_RA_WT.count PCT_RA_WT.result PCT_RC.count PCT_RC.result
    ## 1         0              10                0          105             0
    ## 2         0              10                0          105             0
    ## 3         0              10                0          105             0
    ## 4         0              10                0          105            10
    ##   PCT_RI.count PCT_RI.result PCT_RI.sd PCT_RI_WT.count PCT_RI_WT.result
    ## 1           10             0       0.0              10                0
    ## 2           10            29      19.8              10               29
    ## 3           10            94       8.4              10               94
    ## 4           10            22      31.6              10               22
    ##   PCT_RN.count PCT_RN.result PCT_RN.sd PCT_RN_WT.count PCT_RN_WT.result
    ## 1           10           100       0.0              10              100
    ## 2           10             0       0.0              10                0
    ## 3           10             2       4.2              10                2
    ## 4           10            14      19.6              10               14
    ##   PCT_RR.count PCT_RR.result PCT_RS.count PCT_RS.result PCT_SA.count
    ## 1          105             0          105             0          105
    ## 2          105             0          105             0          105
    ## 3          105             0          105             0          105
    ## 4          105             0          105             0          105
    ##   PCT_SA.result PCT_SAFN.count PCT_SAFN.result PCT_SB.count PCT_SB.result
    ## 1            49              2              50          105             2
    ## 2            10              2              13          105             0
    ## 3            27              2              30          105            13
    ## 4            12              2              12          105             7
    ##   PCT_SFGF.count PCT_SFGF.result PCT_SLOW.count PCT_SLOW.result
    ## 1              3              69              2               0
    ## 2              3              24              2              71
    ## 3              3              39              2               4
    ## 4              3              13              2              62
    ##   PCT_SLOW_WT.count PCT_SLOW_WT.result PCT_WD.count PCT_WD.result
    ## 1                 2                  0          105             1
    ## 2                 2                 71          105             5
    ## 3                 2                  4          105             2
    ## 4                 2                 62          105             4
    ##   PCT_XB.count PCT_XB.result PWVZ.count PWVZ.result RBP_CHN.result
    ## 1          105             0          0          NA             NA
    ## 2          105             0         11        18.2             13
    ## 3          105             0         12        25.0             19
    ## 4          105             3         14        14.3             16
    ##   RBP_EPI.result RBP_SED.result SB_PP_D10.count SB_PP_D10.result
    ## 1             NA             NA             103             1.03
    ## 2             12             13             100             1.03
    ## 3             20             20             103             1.03
    ## 4             18             13              89             1.03
    ##   SB_PP_D25.count SB_PP_D25.result SB_PP_D50.count SB_PP_D50.result
    ## 1             103             1.03             103             1.03
    ## 2             100            15.00             100            36.00
    ## 3             103             1.03             103            33.00
    ## 4              89            37.00              89            93.00
    ##   SB_PP_D75.count SB_PP_D75.result SB_PP_D90.count SB_PP_D90.result
    ## 1             103               19             103               42
    ## 2             100               60             100               75
    ## 3             103              160             103              625
    ## 4              89              172              89              290
    ##   SB_PT_D10.count SB_PT_D10.result SB_PT_D25.count SB_PT_D25.result
    ## 1             104             1.03             104             1.03
    ## 2             100             1.03             100            15.00
    ## 3             103             1.03             103             1.03
    ## 4             101             1.03             101            43.00
    ##   SB_PT_D50.count SB_PT_D50.result SB_PT_D75.count SB_PT_D75.result
    ## 1             104            3.515             104               20
    ## 2             100           36.500             100               60
    ## 3             103           33.000             103              160
    ## 4             101          111.000             101              210
    ##   SB_PT_D90.count SB_PT_D90.result SINU.NOT_WORKING SLOPE_0.count
    ## 1             104               44         28.64934            10
    ## 2             100               75         28.64934            10
    ## 3             103              625         28.64934            10
    ## 4             101             5660         28.64934            10
    ##   SLOPE_0.result SLOPE_0_5.count SLOPE_0_5.result SLOPE_1.count
    ## 1          10000              10                0            10
    ## 2              0              10            10000            10
    ## 3              0              10            10000            10
    ## 4          10000              10                0            10
    ##   SLOPE_1.result SLOPE_2.count SLOPE_2.result W1_HALL_EMAP.count
    ## 1              0            10              0                 11
    ## 2          10000            10          10000                 11
    ## 3          10000            10          10000                 11
    ## 4              0            10              0                 11
    ##   W1_HALL_EMAP.result W1_HALL_SWAMP.count W1_HALL_SWAMP.result
    ## 1                0.00                  14                 0.00
    ## 2                1.87                  14                 1.87
    ## 3                0.66                  14                 0.66
    ## 4                1.28                  14                 1.28
    ##   W1H_BLDG.count W1H_BLDG.result W1H_BLDG.sd W1H_BRDG.count
    ## 1             22            0.00       0.000             22
    ## 2             22            0.73       0.131             22
    ## 3             22            0.00       0.000             22
    ## 4             22            0.18       0.304             22
    ##   W1H_BRDG.result W1H_BRDG.sd W1H_CROP.count W1H_CROP.result W1H_CROP.sd
    ## 1               0           0             22               0           0
    ## 2               0           0             22               0           0
    ## 3               0           0             22               0           0
    ## 4               0           0             22               0           0
    ##   W1H_LDFL.count W1H_LDFL.result W1H_LDFL.sd W1H_LOG.count W1H_LOG.result
    ## 1             22            0.00       0.000            22              0
    ## 2             22            0.48       0.715            22              0
    ## 3             22            0.25       0.551            22              0
    ## 4             22            0.14       0.441            22              0
    ##   W1H_LOG.sd W1H_MINE.count W1H_MINE.result W1H_MINE.sd W1H_ORVY.count
    ## 1          0             22               0           0             22
    ## 2          0             22               0           0             22
    ## 3          0             22               0           0             22
    ## 4          0             22               0           0             22
    ##   W1H_ORVY.result W1H_ORVY.sd W1H_PARK.count W1H_PARK.result W1H_PARK.sd
    ## 1               0           0             22            0.00       0.000
    ## 2               0           0             22            0.11       0.376
    ## 3               0           0             22            0.00       0.000
    ## 4               0           0             22            0.00       0.000
    ##   W1H_PIPE.count W1H_PIPE.result W1H_PIPE.sd W1H_PSTR.count
    ## 1             22               0           0             22
    ## 2             22               0           0             22
    ## 3             22               0           0             22
    ## 4             22               0           0             22
    ##   W1H_PSTR.result W1H_PSTR.sd W1H_PVMT.count W1H_PVMT.result W1H_PVMT.sd
    ## 1               0           0             22            0.00       0.000
    ## 2               0           0             22            0.00       0.000
    ## 3               0           0             22            0.03       0.142
    ## 4               0           0             22            0.27       0.336
    ##   W1H_ROAD.count W1H_ROAD.result W1H_ROAD.sd W1H_VEGM.count
    ## 1             22            0.00       0.000             22
    ## 2             22            0.00       0.000             22
    ## 3             22            0.24       0.328             22
    ## 4             22            0.05       0.213             22
    ##   W1H_VEGM.result W1H_VEGM.sd W1H_WALL.count W1H_WALL.result W1H_WALL.sd
    ## 1               0           0             22            0.00       0.000
    ## 2               0           0             22            0.55       0.575
    ## 3               0           0             22            0.14       0.441
    ## 4               0           0             22            0.64       0.727
    ##   XBEARING.count XBEARING.result XBEARING.sd XBKF_H.count XBKF_H.result
    ## 1             10            0.01           0           11          0.78
    ## 2             10            0.01           0           11          0.24
    ## 3             10            0.01           0           11          1.24
    ## 4             10            0.01           0           11          0.30
    ##   XBKF_H.sd XBKF_W.count XBKF_W.result XBKF_W.sd XC.count XC.result XC.sd
    ## 1      0.10           11          21.0      7.40       22         8  11.0
    ## 2      0.06           11           3.4      0.55       22        57  13.6
    ## 3      0.44           11          22.2      7.31       22        57  21.6
    ## 4      0.00           11          30.2      7.43       22        34  22.0
    ##   XCDENBK.count XCDENBK.result XCDENBK.sd XCDENMID.count XCDENMID.result
    ## 1            22             67       33.2             44               6
    ## 2             0             NA         NA             44              98
    ## 3            22             97        8.8             44              81
    ## 4            22             90       24.5             44              15
    ##   XCDENMID.sd XCM.count XCM.result XCMG.count XCMG.result XEMBED.count
    ## 1        18.8         2         44          4         132           26
    ## 2         5.3         2         91          4         142           25
    ## 3        17.1         2         92          4         128           27
    ## 4        30.0         2         73          4         123           47
    ##   XEMBED.result XEMBED.sd XFC_ALG.count XFC_ALG.result XFC_ALG.sd
    ## 1            36      19.8            11            0.9        2.0
    ## 2            24      26.8            11            1.4        2.3
    ## 3            36      33.9            11            1.8        2.5
    ## 4             7      14.0            11           27.3       16.9
    ##   XFC_AQM.count XFC_AQM.result XFC_AQM.sd XFC_BIG.count XFC_BIG.result
    ## 1            11           51.6       13.1             4            1.8
    ## 2            11            4.5        1.5             4           35.9
    ## 3            11            0.9        2.0             4           18.7
    ## 4            11            4.5        1.5             4           59.7
    ##   XFC_BRS.count XFC_BRS.result XFC_BRS.sd XFC_HUM.count XFC_HUM.result
    ## 1            11            1.8        2.5            11            0.0
    ## 2            11            4.5        1.5            11            5.9
    ## 3            11            4.5        1.5            11            0.0
    ## 4            11            8.6        8.1            11            5.0
    ##   XFC_HUM.sd XFC_LTR.count XFC_LTR.result XFC_LTR.sd XFC_LWD.count
    ## 1        0.0            11            4.1        2.0            11
    ## 2        9.7            11            6.8        6.0            11
    ## 3        0.0            11            2.7        2.6            11
    ## 4        0.0            11            4.1        2.0            11
    ##   XFC_LWD.result XFC_LWD.sd XFC_NAT_EMAP.count XFC_NAT_EMAP.result
    ## 1            0.0        0.0                  5                12.2
    ## 2            0.0        0.0                  5                40.9
    ## 3            1.4        2.3                  5                28.2
    ## 4            4.5        1.5                  5                68.3
    ##   XFC_NAT_SWAMP.count XFC_NAT_SWAMP.result XFC_OHV.count XFC_OHV.result
    ## 1                   7                 67.9            11            8.6
    ## 2                   7                 52.2            11            6.4
    ## 3                   7                 31.8            11            5.0
    ## 4                   7                 76.9            11            5.0
    ##   XFC_OHV.sd XFC_RCK.count XFC_RCK.result XFC_RCK.sd XFC_UCB.count
    ## 1        8.1            11            0.0        0.0            11
    ## 2        6.4            11           12.3       10.1            11
    ## 3        7.1            11           15.9       10.4            11
    ## 4        0.0            11           45.7       16.4            11
    ##   XFC_UCB.result XFC_UCB.sd XG.count XG.result XGB.count XGB.result XGB.sd
    ## 1            1.8        2.5        2        88        22          8   14.5
    ## 2           17.7       10.1        2        51        22         38   26.3
    ## 3            1.4        2.3        2        36        22         60   24.0
    ## 4            4.5        1.5        2        50        22         36   27.7
    ##   XGH.count XGH.result XGH.sd XGW.count XGW.result XGW.sd XM.count
    ## 1        22         71   26.7        22         17   18.6       22
    ## 2        22          8   16.0        22         43   30.3       22
    ## 3        22         10    9.5        22         26   19.5       22
    ## 4        22         19   18.1        22         31   15.1       22
    ##   XM.result XM.sd XMIAT.count XMIAT.result XMIAT.sd XMIATP.count
    ## 1        36  23.3         101          0.1     0.16           26
    ## 2        34  16.7         105          0.2     0.21           41
    ## 3        35  18.3          71          0.2     0.15           59
    ## 4        39  19.3          95          0.0     0.04            3
    ##   XMIATP.result XMIATP.sd XPCAN.count XPCAN.result XPCM.count XPCM.result
    ## 1           0.3      0.12          22         0.45         22        0.45
    ## 2           0.4      0.12          22         1.00         22        1.00
    ## 3           0.3      0.10          22         1.00         22        1.00
    ## 4           0.2      0.00          22         0.95         22        0.95
    ##   XPCMG.count XPCMG.result XPGVEG.count XPGVEG.result XPMGVEG.count
    ## 1          22         0.45           22             1            22
    ## 2          22         1.00           22             1            22
    ## 3          22         1.00           22             1            22
    ## 4          22         0.95           22             1            22
    ##   XPMGVEG.result XPMID.count XPMID.result XSDGM.count XSDGM.result
    ## 1           1.00          22         0.95         104          5.1
    ## 2           0.91          22         1.00         100         20.6
    ## 3           0.77          22         1.00         103         19.3
    ## 4           0.95          22         1.00         101         97.6
    ##   XSLOPE.count XSLOPE.result XSLOPE.sd XSPGM.result XWAK.count XWAK.result
    ## 1           10          0.00         0     4.776569          1         195
    ## 2           10          0.01         0    20.563869          1         230
    ## 3           10          0.01         0    19.282021          1         140
    ## 4           10          0.00         0    56.476045          1          80
    ##   XWAK.sd XWDA.count XWDA.result XWDEPTH.count XWDEPTH.result XWDEPTH.sd
    ## 1      NA        105   0.2696774           105           41.8      36.16
    ## 2      NA        105   0.2833333           105            6.8       8.01
    ## 3      NA        105   0.1738318           105           18.6      18.65
    ## 4      NA        105   0.1107807           105           29.8      43.73
    ##   XWDM.count XWDM.result XWDM.sd XWDO.count XWDO.result XWDO.sd XWDR.count
    ## 1         21        79.8    15.3          1         9.0      NA         21
    ## 2         21        14.7     9.0          1         9.0      NA         21
    ## 3         21        40.1    14.9          1        15.2      NA         21
    ## 4         21        77.0    53.2          1         8.8      NA         21
    ##   XWDR.result XWIDTH.count XWIDTH.result XWIDTH.sd XWPH.count XWPH.result
    ## 1    37.08134           21          15.5      4.03          1        7.99
    ## 2    35.29412           21           2.4      0.64          1        8.02
    ## 3    57.52688           21          10.7      3.00          0          NA
    ## 4    90.26846           21          26.9      7.49          1        7.83
    ##   XWPH.sd XWSC.count XWSC.result XWSC.sd XWSL.count XWSL.result XWSL.sd
    ## 1      NA          1       423.5      NA          1         0.2      NA
    ## 2      NA          1      1129.0      NA          1         0.6      NA
    ## 3      NA          1       317.3      NA          1         0.2      NA
    ## 4      NA          1       117.0      NA          1         0.0      NA
    ##   XWTB.count XWTB.result XWTB.sd XWTC.count XWTC.result XWTC.sd XWTF.count
    ## 1          0          NA      NA          1        14.7      NA          1
    ## 2          1         3.0      NA          1        15.5      NA          1
    ## 3          1         0.8      NA          1        15.2      NA          1
    ## 4          1         4.7      NA          1        22.4      NA          1
    ##   XWTF.result XWTF.sd XWV_F.count XWV_F.result  XWV_F.sd XWV_M.count
    ## 1        58.5      NA           0           NA        NA           0
    ## 2        59.9      NA          11         0.24 0.1828164          11
    ## 3        59.4      NA          12         0.50 0.4605530          12
    ## 4        72.3      NA          14         1.43 0.8051704          14
    ##   XWV_M.result   XWV_M.sd
    ## 1           NA         NA
    ## 2         0.07 0.05573669
    ## 3         0.15 0.14041251
    ## 4         0.44 0.24547880

# Required data checks

  - For every function, make sure there are no duplicate or conflicting
    values for every unique combination of `id`, `LocationCode`,
    `AnalyteName`, and `VariableResult` (or `Result`). This should be
    specific to the metric classes just to be safe. For example, every
    combination should have only one entry in `VariableResult` for
    `AnalyteName %in% c('Microalgae Thickness', 'Macrophyte Cover',
    'Macroalgae Cover, Attached', 'Macroalgae Cover, Unattached')` for
    the algae metrics. The `algae.R` function will remove duplicate
    entries but a checker should be built that verifies a unique value
    can be determined.

  - Required column names, see those in `sampdat`.

  - Check for required values in `AnalyteName` (note that `chkinp()` can
    check of the columns exist but we’ll need a checker on data input to
    check for these and only these):
    
      - `c('Microalgae Thickness', 'Macrophyte Cover', 'Macroalgae
        Cover, Attached', 'Macroalgae Cover, Unattached')` for `algae()`
      - `c('Bankfull Height', 'Bankfull Width', 'StationWaterDepth',
        'Wetted Width')` for `bankmorph()`
      - `c('Cascade/Falls', 'Dry', 'Glide', 'Pool', 'Rapid', 'Riffle',
        'Run'))` for `channelmorph()`
      - `c(Slope', 'Length, Segment', 'Elevation Difference', 'Bearing',
        'Proportion', 'Length, Reach')` for `channelsinuosity()`
      - `c('Canopy Cover')` for `densiometer()`
      - `c('Distance from Bank', 'StationWaterDepth', 'Velocity',
        'Distance, Float', 'Float Time', 'Wetted Width')` for `flow()`
      - `c('Fish Cover Macrophytes', 'Fish Cover Artificial Structures',
        'Fish Cover Boulders', 'Fish Cover Filamentous Algae', 'Fish
        Cover Woody Debris >0.3 m', 'Fish Cover Live Trees/Roots', 'Fish
        Cover Overhang.Veg', 'Fish Cover Woody Debris <0.3 m', 'Fish
        Cover Undercut Banks')` for `habitat()`
      - `c('Riparian Bridges/Abutments', 'Riparian Buildings', 'Riparian
        Landfill/Trash', 'Riparian Logging', 'Riparian Mining',
        'Riparian Orchards/Vineyards', 'Riparian Park/Lawn', 'Riparian
        Pasture/Range', 'Riparian Pavement', 'Riparian Pipes', 'Riparian
        Road', 'Riparian Row Crops', 'Riparian Vegetation Management',
        'Riparian Wall/Dike')` for `disturbance()`
      - `c('Riffle/Run Channel Alteration', 'Riffle/Run Epifaunal
        Substrate', 'Riffle/Run Sediment Deposition', 'Dominant Land
        Use', 'Evidence of Fire', 'Evidence of Recent Rainfall')` for
        `misc()`
      - `c('Bank Stability')` for `bankstability()`
      - `c("Alkalinity as CaCO3", "Oxygen, Dissolved", "pH", "Salinity",
        "SpecificConductivity", "Temperature", "Turbidity")` for
        `quality()`
      - `c('Riparian GroundCover Barren', 'Riparian GroundCover NonWoody
        Plants', 'Riparian GroundCover Woody Shrubs', 'Riparian Lower
        Canopy All Vegetation', 'Riparian Upper Canopy All Trees',
        'Riparian Lower Canopy All Vegetation', 'Riparian Upper Canopy
        All Trees', 'Riparian GroundCover Woody Shrubs', 'Riparian
        GroundCover NonWoody Plants')` for `ripveg()`
      - `c('Substrate Size Class', 'Embeddedness', 'CPOM')` for
        `substrate()`

  - Check for required values in `LocationCode` (note that `chkinp()`
    can check if the columns exist but we’ll need a checker on data
    input to check for these and only these)

  - Maybe we need to add a checker to make sure all values in each field
    are present but with appropriate NA values for `Result`,
    `VariableResult`, this can be done with `tidyr::complete()` but may
    be unnecessary since this will increase data volume
