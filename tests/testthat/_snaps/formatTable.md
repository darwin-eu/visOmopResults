# datatable works

    Code
      dt$x
    Output
      $filter
      [1] "bottom"
      
      $vertical
      [1] FALSE
      
      $filterHTML
      [1] "<tr>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"1\"></div>\n      <span style=\"float: left;\"></span>\n      <span style=\"float: right;\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n</tr>"
      
      $class
      [1] "display"
      
      $extensions
      $extensions[[1]]
      [1] "FixedColumns"
      
      $extensions[[2]]
      [1] "FixedHeader"
      
      $extensions[[3]]
      [1] "Responsive"
      
      $extensions[[4]]
      [1] "RowGroup"
      
      $extensions[[5]]
      [1] "Scroller"
      
      
      $data
         result_id cdm_name  group_name group_level   variable_name variable_level
      1          1     mock cohort_name     cohort1 number subjects           <NA>
      2          1     mock cohort_name     cohort2 number subjects           <NA>
      3          1     mock cohort_name     cohort1             age           <NA>
      4          1     mock cohort_name     cohort1             age           <NA>
      5          1     mock cohort_name     cohort2             age           <NA>
      6          1     mock cohort_name     cohort2             age           <NA>
      7          1     mock cohort_name     cohort1     Medications    Amoxiciline
      8          1     mock cohort_name     cohort2     Medications    Amoxiciline
      9          1     mock cohort_name     cohort1     Medications      Ibuprofen
      10         1     mock cohort_name     cohort2     Medications      Ibuprofen
         estimate_name estimate_type additional_name additional_level
      1              N     character         overall          overall
      2              N     character         overall          overall
      3           mean       numeric         overall          overall
      4             sd       numeric         overall          overall
      5           mean       numeric         overall          overall
      6             sd       numeric         overall          overall
      7          N (%)     character         overall          overall
      8          N (%)     character         overall          overall
      9          N (%)     character         overall          overall
      10         N (%)     character         overall          overall
         strata\nstrata_name\nsex\nstrata_level\nMale
      1                                       8983897
      2                                       7698414
      3                              12.5555095961317
      4                              6.47060193819925
      5                              49.3541307048872
      6                              4.77619622135535
      7                     40683 (38.9989543473348%)
      8                      8425 (71.1121222469956%)
      9                     79731 (43.1473690550774%)
      10                    63349 (48.4349524369463%)
         strata\nstrata_name\nsex\nstrata_level\nFemale
      1                                         9446753
      2                                         4976992
      3                                26.7220668727532
      4                                 7.8293276228942
      5                                18.6217601411045
      6                                  8.612094768323
      7                       91288 (77.7320698834956%)
      8                       87532 (12.1691921027377%)
      9                       45527 (14.8211560677737%)
      10                      21321 (17.3442334868014%)
      
      $container
      [1] "<table class='display'>\n<thead>\n<tr><th rowspan='5' style='text-align:center;'>result_id</th><th rowspan='5' style='text-align:center;'>cdm_name</th><th rowspan='5' style='text-align:center;'>group_name</th><th rowspan='5' style='text-align:center;'>group_level</th><th rowspan='5' style='text-align:center;'>variable_name</th><th rowspan='5' style='text-align:center;'>variable_level</th><th rowspan='5' style='text-align:center;'>estimate_name</th><th rowspan='5' style='text-align:center;'>estimate_type</th><th rowspan='5' style='text-align:center;'>additional_name</th><th rowspan='5' style='text-align:center;'>additional_level</th><th colspan='2' style='text-align:center;'>strata</th></tr>\n<tr><th colspan='2' style='text-align:center;'>strata_name</th></tr>\n<tr><th colspan='2' style='text-align:center;'>sex</th></tr>\n<tr><th colspan='2' style='text-align:center;'>strata_level</th></tr>\n<tr><th style='text-align:center;'>Male</th><th style='text-align:center;'>Female</th></tr>\n</thead>\n</table>"
      
      $options
      $options$scrollX
      [1] TRUE
      
      $options$scrollY
      [1] 400
      
      $options$scrollCollapse
      [1] TRUE
      
      $options$pageLength
      [1] 10
      
      $options$lengthMenu
      [1]   5  10  20  50 100
      
      $options$searchHighlight
      [1] TRUE
      
      $options$scroller
      [1] TRUE
      
      $options$deferRender
      [1] TRUE
      
      $options$fixedColumns
      $options$fixedColumns$leftColumns
      [1] 0
      
      $options$fixedColumns$rightColumns
      [1] 0
      
      
      $options$fixedHeader
      [1] TRUE
      
      $options$columnDefs
      $options$columnDefs[[1]]
      $options$columnDefs[[1]]$className
      [1] "dt-right"
      
      $options$columnDefs[[1]]$targets
      [1] 0
      
      
      $options$columnDefs[[2]]
      $options$columnDefs[[2]]$name
      [1] "result_id"
      
      $options$columnDefs[[2]]$targets
      [1] 0
      
      
      $options$columnDefs[[3]]
      $options$columnDefs[[3]]$name
      [1] "cdm_name"
      
      $options$columnDefs[[3]]$targets
      [1] 1
      
      
      $options$columnDefs[[4]]
      $options$columnDefs[[4]]$name
      [1] "group_name"
      
      $options$columnDefs[[4]]$targets
      [1] 2
      
      
      $options$columnDefs[[5]]
      $options$columnDefs[[5]]$name
      [1] "group_level"
      
      $options$columnDefs[[5]]$targets
      [1] 3
      
      
      $options$columnDefs[[6]]
      $options$columnDefs[[6]]$name
      [1] "variable_name"
      
      $options$columnDefs[[6]]$targets
      [1] 4
      
      
      $options$columnDefs[[7]]
      $options$columnDefs[[7]]$name
      [1] "variable_level"
      
      $options$columnDefs[[7]]$targets
      [1] 5
      
      
      $options$columnDefs[[8]]
      $options$columnDefs[[8]]$name
      [1] "estimate_name"
      
      $options$columnDefs[[8]]$targets
      [1] 6
      
      
      $options$columnDefs[[9]]
      $options$columnDefs[[9]]$name
      [1] "estimate_type"
      
      $options$columnDefs[[9]]$targets
      [1] 7
      
      
      $options$columnDefs[[10]]
      $options$columnDefs[[10]]$name
      [1] "additional_name"
      
      $options$columnDefs[[10]]$targets
      [1] 8
      
      
      $options$columnDefs[[11]]
      $options$columnDefs[[11]]$name
      [1] "additional_level"
      
      $options$columnDefs[[11]]$targets
      [1] 9
      
      
      $options$columnDefs[[12]]
      $options$columnDefs[[12]]$name
      [1] "strata\nstrata_name\nsex\nstrata_level\nMale"
      
      $options$columnDefs[[12]]$targets
      [1] 10
      
      
      $options$columnDefs[[13]]
      $options$columnDefs[[13]]$name
      [1] "strata\nstrata_name\nsex\nstrata_level\nFemale"
      
      $options$columnDefs[[13]]$targets
      [1] 11
      
      
      
      $options$order
      list()
      
      $options$autoWidth
      [1] FALSE
      
      $options$orderClasses
      [1] FALSE
      
      $options$responsive
      [1] TRUE
      
      attr(,"escapeIdx")
      [1] "true"
      
      attr(,"colnames")
       [1] "result_id"                                     
       [2] "cdm_name"                                      
       [3] "group_name"                                    
       [4] "group_level"                                   
       [5] "variable_name"                                 
       [6] "variable_level"                                
       [7] "estimate_name"                                 
       [8] "estimate_type"                                 
       [9] "additional_name"                               
      [10] "additional_level"                              
      [11] "strata\nstrata_name\nsex\nstrata_level\nMale"  
      [12] "strata\nstrata_name\nsex\nstrata_level\nFemale"
      attr(,"rownames")
      [1] FALSE

---

    Code
      dt$x
    Output
      $filter
      [1] "none"
      
      $vertical
      [1] FALSE
      
      $class
      [1] "display"
      
      $extensions
      $extensions[[1]]
      [1] "FixedColumns"
      
      $extensions[[2]]
      [1] "FixedHeader"
      
      $extensions[[3]]
      [1] "Responsive"
      
      $extensions[[4]]
      [1] "RowGroup"
      
      $extensions[[5]]
      [1] "Scroller"
      
      
      $data
            result_id cdm_name  group_name group_level   variable_name variable_level
      1   1         1     mock cohort_name     cohort1 number subjects           <NA>
      2   2         1     mock cohort_name     cohort2 number subjects           <NA>
      3   3         1     mock cohort_name     cohort1             age           <NA>
      4   4         1     mock cohort_name     cohort1             age           <NA>
      5   5         1     mock cohort_name     cohort2             age           <NA>
      6   6         1     mock cohort_name     cohort2             age           <NA>
      7   7         1     mock cohort_name     cohort1     Medications    Amoxiciline
      8   8         1     mock cohort_name     cohort2     Medications    Amoxiciline
      9   9         1     mock cohort_name     cohort1     Medications      Ibuprofen
      10 10         1     mock cohort_name     cohort2     Medications      Ibuprofen
         estimate_name estimate_type additional_name additional_level
      1              N     character         overall          overall
      2              N     character         overall          overall
      3           mean       numeric         overall          overall
      4             sd       numeric         overall          overall
      5           mean       numeric         overall          overall
      6             sd       numeric         overall          overall
      7          N (%)     character         overall          overall
      8          N (%)     character         overall          overall
      9          N (%)     character         overall          overall
      10         N (%)     character         overall          overall
         strata\nstrata_name\nsex\nstrata_level\nMale
      1                                       8983897
      2                                       7698414
      3                              12.5555095961317
      4                              6.47060193819925
      5                              49.3541307048872
      6                              4.77619622135535
      7                     40683 (38.9989543473348%)
      8                      8425 (71.1121222469956%)
      9                     79731 (43.1473690550774%)
      10                    63349 (48.4349524369463%)
         strata\nstrata_name\nsex\nstrata_level\nFemale
      1                                         9446753
      2                                         4976992
      3                                26.7220668727532
      4                                 7.8293276228942
      5                                18.6217601411045
      6                                  8.612094768323
      7                       91288 (77.7320698834956%)
      8                       87532 (12.1691921027377%)
      9                       45527 (14.8211560677737%)
      10                      21321 (17.3442334868014%)
      
      $container
      [1] "<table class='display'>\n<thead>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr><th rowspan='33' style='text-align:center;'>\n</th></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr><th rowspan='22' style='text-align:center;'>\n</th></tr>\n<tr></tr>\n<tr></tr>\n<tr><th rowspan='19' style='text-align:center;'>\n</th></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr><th rowspan='7' style='text-align:center;'>\n</th></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n<tr></tr>\n</thead>\n</table>"
      
      $options
      $options$scrollX
      [1] FALSE
      
      $options$columnDefs
      $options$columnDefs[[1]]
      $options$columnDefs[[1]]$className
      [1] "dt-right"
      
      $options$columnDefs[[1]]$targets
      [1] 1
      
      
      $options$columnDefs[[2]]
      $options$columnDefs[[2]]$orderable
      [1] FALSE
      
      $options$columnDefs[[2]]$targets
      [1] 0
      
      
      $options$columnDefs[[3]]
      $options$columnDefs[[3]]$name
      [1] " "
      
      $options$columnDefs[[3]]$targets
      [1] 0
      
      
      $options$columnDefs[[4]]
      $options$columnDefs[[4]]$name
      [1] "result_id"
      
      $options$columnDefs[[4]]$targets
      [1] 1
      
      
      $options$columnDefs[[5]]
      $options$columnDefs[[5]]$name
      [1] "cdm_name"
      
      $options$columnDefs[[5]]$targets
      [1] 2
      
      
      $options$columnDefs[[6]]
      $options$columnDefs[[6]]$name
      [1] "group_name"
      
      $options$columnDefs[[6]]$targets
      [1] 3
      
      
      $options$columnDefs[[7]]
      $options$columnDefs[[7]]$name
      [1] "group_level"
      
      $options$columnDefs[[7]]$targets
      [1] 4
      
      
      $options$columnDefs[[8]]
      $options$columnDefs[[8]]$name
      [1] "variable_name"
      
      $options$columnDefs[[8]]$targets
      [1] 5
      
      
      $options$columnDefs[[9]]
      $options$columnDefs[[9]]$name
      [1] "variable_level"
      
      $options$columnDefs[[9]]$targets
      [1] 6
      
      
      $options$columnDefs[[10]]
      $options$columnDefs[[10]]$name
      [1] "estimate_name"
      
      $options$columnDefs[[10]]$targets
      [1] 7
      
      
      $options$columnDefs[[11]]
      $options$columnDefs[[11]]$name
      [1] "estimate_type"
      
      $options$columnDefs[[11]]$targets
      [1] 8
      
      
      $options$columnDefs[[12]]
      $options$columnDefs[[12]]$name
      [1] "additional_name"
      
      $options$columnDefs[[12]]$targets
      [1] 9
      
      
      $options$columnDefs[[13]]
      $options$columnDefs[[13]]$name
      [1] "additional_level"
      
      $options$columnDefs[[13]]$targets
      [1] 10
      
      
      $options$columnDefs[[14]]
      $options$columnDefs[[14]]$name
      [1] "strata\nstrata_name\nsex\nstrata_level\nMale"
      
      $options$columnDefs[[14]]$targets
      [1] 11
      
      
      $options$columnDefs[[15]]
      $options$columnDefs[[15]]$name
      [1] "strata\nstrata_name\nsex\nstrata_level\nFemale"
      
      $options$columnDefs[[15]]$targets
      [1] 12
      
      
      
      $options$order
      list()
      
      $options$autoWidth
      [1] FALSE
      
      $options$orderClasses
      [1] FALSE
      
      $options$responsive
      [1] TRUE
      
      attr(,"escapeIdx")
      [1] "true"
      
      attr(,"colnames")
       [1] " "                                             
       [2] "result_id"                                     
       [3] "cdm_name"                                      
       [4] "group_name"                                    
       [5] "group_level"                                   
       [6] "variable_name"                                 
       [7] "variable_level"                                
       [8] "estimate_name"                                 
       [9] "estimate_type"                                 
      [10] "additional_name"                               
      [11] "additional_level"                              
      [12] "strata\nstrata_name\nsex\nstrata_level\nMale"  
      [13] "strata\nstrata_name\nsex\nstrata_level\nFemale"
      attr(,"rownames")
      [1] TRUE

---

    Code
      dt$x
    Output
      $filter
      [1] "bottom"
      
      $vertical
      [1] FALSE
      
      $filterHTML
      [1] "<tr>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"1\"></div>\n      <span style=\"float: left;\"></span>\n      <span style=\"float: right;\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n</tr>"
      
      $class
      [1] "display"
      
      $extensions
      $extensions[[1]]
      [1] "FixedColumns"
      
      $extensions[[2]]
      [1] "FixedHeader"
      
      $extensions[[3]]
      [1] "Responsive"
      
      $extensions[[4]]
      [1] "RowGroup"
      
      $extensions[[5]]
      [1] "Scroller"
      
      
      $caption
      [1] "<caption style=\"caption-side: bottom; text-align: center;\">hi there</caption>"
      
      $data
         group_level result_id cdm_name  group_name   variable_name variable_level
      1      cohort1         1     mock cohort_name number subjects           <NA>
      2      cohort2         1     mock cohort_name number subjects           <NA>
      3      cohort1         1     mock cohort_name             age           <NA>
      4      cohort1         1     mock cohort_name             age           <NA>
      5      cohort2         1     mock cohort_name             age           <NA>
      6      cohort2         1     mock cohort_name             age           <NA>
      7      cohort1         1     mock cohort_name     Medications    Amoxiciline
      8      cohort2         1     mock cohort_name     Medications    Amoxiciline
      9      cohort1         1     mock cohort_name     Medications      Ibuprofen
      10     cohort2         1     mock cohort_name     Medications      Ibuprofen
         estimate_name estimate_type additional_name additional_level
      1              N     character         overall          overall
      2              N     character         overall          overall
      3           mean       numeric         overall          overall
      4             sd       numeric         overall          overall
      5           mean       numeric         overall          overall
      6             sd       numeric         overall          overall
      7          N (%)     character         overall          overall
      8          N (%)     character         overall          overall
      9          N (%)     character         overall          overall
      10         N (%)     character         overall          overall
         strata\nstrata_name\nsex\nstrata_level\nMale
      1                                       8983897
      2                                       7698414
      3                              12.5555095961317
      4                              6.47060193819925
      5                              49.3541307048872
      6                              4.77619622135535
      7                     40683 (38.9989543473348%)
      8                      8425 (71.1121222469956%)
      9                     79731 (43.1473690550774%)
      10                    63349 (48.4349524369463%)
         strata\nstrata_name\nsex\nstrata_level\nFemale
      1                                         9446753
      2                                         4976992
      3                                26.7220668727532
      4                                 7.8293276228942
      5                                18.6217601411045
      6                                  8.612094768323
      7                       91288 (77.7320698834956%)
      8                       87532 (12.1691921027377%)
      9                       45527 (14.8211560677737%)
      10                      21321 (17.3442334868014%)
      
      $container
      [1] "<table class='display'>\n<thead>\n<tr><th rowspan='5' style='text-align:center;'>group_level</th><th rowspan='5' style='text-align:center;'>result_id</th><th rowspan='5' style='text-align:center;'>cdm_name</th><th rowspan='5' style='text-align:center;'>group_name</th><th rowspan='5' style='text-align:center;'>variable_name</th><th rowspan='5' style='text-align:center;'>variable_level</th><th rowspan='5' style='text-align:center;'>estimate_name</th><th rowspan='5' style='text-align:center;'>estimate_type</th><th rowspan='5' style='text-align:center;'>additional_name</th><th rowspan='5' style='text-align:center;'>additional_level</th><th colspan='2' style='text-align:center;'>strata</th></tr>\n<tr><th colspan='2' style='text-align:center;'>strata_name</th></tr>\n<tr><th colspan='2' style='text-align:center;'>sex</th></tr>\n<tr><th colspan='2' style='text-align:center;'>strata_level</th></tr>\n<tr><th style='text-align:center;'>Male</th><th style='text-align:center;'>Female</th></tr>\n</thead>\n</table>"
      
      $options
      $options$scrollX
      [1] TRUE
      
      $options$scrollY
      [1] 400
      
      $options$scrollCollapse
      [1] TRUE
      
      $options$pageLength
      [1] 10
      
      $options$lengthMenu
      [1]   5  10  20  50 100
      
      $options$searchHighlight
      [1] TRUE
      
      $options$scroller
      [1] TRUE
      
      $options$deferRender
      [1] TRUE
      
      $options$fixedColumns
      $options$fixedColumns$leftColumns
      [1] 0
      
      $options$fixedColumns$rightColumns
      [1] 0
      
      
      $options$fixedHeader
      [1] TRUE
      
      $options$rowGroup
      $options$rowGroup$dataSrc
      [1] 0
      
      
      $options$columnDefs
      $options$columnDefs[[1]]
      $options$columnDefs[[1]]$className
      [1] "dt-right"
      
      $options$columnDefs[[1]]$targets
      [1] 1
      
      
      $options$columnDefs[[2]]
      $options$columnDefs[[2]]$name
      [1] "group_level"
      
      $options$columnDefs[[2]]$targets
      [1] 0
      
      
      $options$columnDefs[[3]]
      $options$columnDefs[[3]]$name
      [1] "result_id"
      
      $options$columnDefs[[3]]$targets
      [1] 1
      
      
      $options$columnDefs[[4]]
      $options$columnDefs[[4]]$name
      [1] "cdm_name"
      
      $options$columnDefs[[4]]$targets
      [1] 2
      
      
      $options$columnDefs[[5]]
      $options$columnDefs[[5]]$name
      [1] "group_name"
      
      $options$columnDefs[[5]]$targets
      [1] 3
      
      
      $options$columnDefs[[6]]
      $options$columnDefs[[6]]$name
      [1] "variable_name"
      
      $options$columnDefs[[6]]$targets
      [1] 4
      
      
      $options$columnDefs[[7]]
      $options$columnDefs[[7]]$name
      [1] "variable_level"
      
      $options$columnDefs[[7]]$targets
      [1] 5
      
      
      $options$columnDefs[[8]]
      $options$columnDefs[[8]]$name
      [1] "estimate_name"
      
      $options$columnDefs[[8]]$targets
      [1] 6
      
      
      $options$columnDefs[[9]]
      $options$columnDefs[[9]]$name
      [1] "estimate_type"
      
      $options$columnDefs[[9]]$targets
      [1] 7
      
      
      $options$columnDefs[[10]]
      $options$columnDefs[[10]]$name
      [1] "additional_name"
      
      $options$columnDefs[[10]]$targets
      [1] 8
      
      
      $options$columnDefs[[11]]
      $options$columnDefs[[11]]$name
      [1] "additional_level"
      
      $options$columnDefs[[11]]$targets
      [1] 9
      
      
      $options$columnDefs[[12]]
      $options$columnDefs[[12]]$name
      [1] "strata\nstrata_name\nsex\nstrata_level\nMale"
      
      $options$columnDefs[[12]]$targets
      [1] 10
      
      
      $options$columnDefs[[13]]
      $options$columnDefs[[13]]$name
      [1] "strata\nstrata_name\nsex\nstrata_level\nFemale"
      
      $options$columnDefs[[13]]$targets
      [1] 11
      
      
      
      $options$order
      list()
      
      $options$autoWidth
      [1] FALSE
      
      $options$orderClasses
      [1] FALSE
      
      $options$responsive
      [1] TRUE
      
      attr(,"escapeIdx")
      [1] "true"
      
      attr(,"colnames")
       [1] "group_level"                                   
       [2] "result_id"                                     
       [3] "cdm_name"                                      
       [4] "group_name"                                    
       [5] "variable_name"                                 
       [6] "variable_level"                                
       [7] "estimate_name"                                 
       [8] "estimate_type"                                 
       [9] "additional_name"                               
      [10] "additional_level"                              
      [11] "strata\nstrata_name\nsex\nstrata_level\nMale"  
      [12] "strata\nstrata_name\nsex\nstrata_level\nFemale"
      attr(,"rownames")
      [1] FALSE

