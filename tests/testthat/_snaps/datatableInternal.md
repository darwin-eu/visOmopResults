# multiplication works

    Code
      dt$x
    Output
      $filter
      [1] "bottom"
      
      $vertical
      [1] FALSE
      
      $filterHTML
      [1] "<tr>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"22\" data-max=\"40\"></div>\n      <span style=\"float: left;\"></span>\n      <span style=\"float: right;\"></span>\n    </div>\n  </td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"85\" data-max=\"95\"></div>\n      <span style=\"float: left;\"></span>\n      <span style=\"float: right;\"></span>\n    </div>\n  </td>\n</tr>"
      
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
        group    name age score
      1     A   Alice  25    85
      2     A     Bob  30    90
      3     B Charlie  35    88
      4     B   David  40    92
      5     C     Eve  22    95
      6     C   Frank  28    87
      
      $container
      [1] "<table class='display'>\n<thead>\n<tr><th style='text-align:center;'>group</th><th style='text-align:center;'>name</th><th style='text-align:center;'>age</th><th style='text-align:center;'>score</th></tr>\n</thead>\n</table>"
      
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
      [1] 2 3
      
      
      $options$columnDefs[[2]]
      $options$columnDefs[[2]]$name
      [1] "group"
      
      $options$columnDefs[[2]]$targets
      [1] 0
      
      
      $options$columnDefs[[3]]
      $options$columnDefs[[3]]$name
      [1] "name"
      
      $options$columnDefs[[3]]$targets
      [1] 1
      
      
      $options$columnDefs[[4]]
      $options$columnDefs[[4]]$name
      [1] "age"
      
      $options$columnDefs[[4]]$targets
      [1] 2
      
      
      $options$columnDefs[[5]]
      $options$columnDefs[[5]]$name
      [1] "score"
      
      $options$columnDefs[[5]]$targets
      [1] 3
      
      
      
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
      [1] "group" "name"  "age"   "score"
      attr(,"rownames")
      [1] FALSE

---

    Code
      dt$x
    Output
      $filter
      [1] "bottom"
      
      $vertical
      [1] FALSE
      
      $filterHTML
      [1] "<tr>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"22\" data-max=\"40\"></div>\n      <span style=\"float: left;\"></span>\n      <span style=\"float: right;\"></span>\n    </div>\n  </td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"85\" data-max=\"95\"></div>\n      <span style=\"float: left;\"></span>\n      <span style=\"float: right;\"></span>\n    </div>\n  </td>\n</tr>"
      
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
        group    name age score
      1     A   Alice  25    85
      2     A     Bob  30    90
      3     B Charlie  35    88
      4     B   David  40    92
      5     C     Eve  22    95
      6     C   Frank  28    87
      
      $container
      [1] "<table class='display'>\n<thead>\n<tr><th style='text-align:center;'>group</th><th style='text-align:center;'>name</th><th style='text-align:center;'>age</th><th style='text-align:center;'>score</th></tr>\n</thead>\n</table>"
      
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
      [1] 2 3
      
      
      $options$columnDefs[[2]]
      $options$columnDefs[[2]]$name
      [1] "group"
      
      $options$columnDefs[[2]]$targets
      [1] 0
      
      
      $options$columnDefs[[3]]
      $options$columnDefs[[3]]$name
      [1] "name"
      
      $options$columnDefs[[3]]$targets
      [1] 1
      
      
      $options$columnDefs[[4]]
      $options$columnDefs[[4]]$name
      [1] "age"
      
      $options$columnDefs[[4]]$targets
      [1] 2
      
      
      $options$columnDefs[[5]]
      $options$columnDefs[[5]]$name
      [1] "score"
      
      $options$columnDefs[[5]]$targets
      [1] 3
      
      
      
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
      [1] "group" "name"  "age"   "score"
      attr(,"rownames")
      [1] FALSE

# Multi-level headers generate correct HTML

    Code
      dt$x
    Output
      $filter
      [1] "bottom"
      
      $vertical
      [1] FALSE
      
      $filterHTML
      [1] "<tr>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n</tr>"
      
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
        cdm_name cohort_name\ncohort1\nsex\nmale cohort_name\ncohort1\nsex\nfemale
      1       NA                              NA                                NA
        cohort_name\ncohort2\nsex\nmale cohort_name\ncohort2\nsex\nfemale
      1                              NA                                NA
      
      $container
      [1] "<table class='display'>\n<thead>\n<tr><th rowspan='4' style='text-align:center;'>cdm_name</th><th colspan='4' style='text-align:center;'>cohort_name</th></tr>\n<tr><th colspan='2' style='text-align:center;'>cohort1</th><th colspan='2' style='text-align:center;'>cohort2</th></tr>\n<tr><th colspan='4' style='text-align:center;'>sex</th></tr>\n<tr><th style='text-align:center;'>male</th><th style='text-align:center;'>female</th><th style='text-align:center;'>male</th><th style='text-align:center;'>female</th></tr>\n</thead>\n</table>"
      
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
      $options$columnDefs[[1]]$name
      [1] "cdm_name"
      
      $options$columnDefs[[1]]$targets
      [1] 0
      
      
      $options$columnDefs[[2]]
      $options$columnDefs[[2]]$name
      [1] "cohort_name\ncohort1\nsex\nmale"
      
      $options$columnDefs[[2]]$targets
      [1] 1
      
      
      $options$columnDefs[[3]]
      $options$columnDefs[[3]]$name
      [1] "cohort_name\ncohort1\nsex\nfemale"
      
      $options$columnDefs[[3]]$targets
      [1] 2
      
      
      $options$columnDefs[[4]]
      $options$columnDefs[[4]]$name
      [1] "cohort_name\ncohort2\nsex\nmale"
      
      $options$columnDefs[[4]]$targets
      [1] 3
      
      
      $options$columnDefs[[5]]
      $options$columnDefs[[5]]$name
      [1] "cohort_name\ncohort2\nsex\nfemale"
      
      $options$columnDefs[[5]]$targets
      [1] 4
      
      
      
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
      [1] "cdm_name"                          "cohort_name\ncohort1\nsex\nmale"  
      [3] "cohort_name\ncohort1\nsex\nfemale" "cohort_name\ncohort2\nsex\nmale"  
      [5] "cohort_name\ncohort2\nsex\nfemale"
      attr(,"rownames")
      [1] FALSE

---

    Code
      dt$x
    Output
      $filter
      [1] "bottom"
      
      $vertical
      [1] FALSE
      
      $filterHTML
      [1] "<tr>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n  </td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\" disabled=\"\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"></span>\n    </div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;true&quot;,&quot;false&quot;,&quot;na&quot;]\"></select>\n    </div>\n  </td>\n</tr>"
      
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
        cdm_name cohort_name\ncohort1\nsex\nmale cohort_name\ncohort1\nsex\nfemale
      1                                       NA                                NA
        cohort_name\ncohort2\nsex\nmale cohort_name\ncohort2\nsex\nfemale
      1                              NA                                NA
      
      $container
      [1] "<table class='display'>\n<thead>\n<tr><th rowspan='4' style='text-align:center;'>cdm_name</th><th colspan='4' style='text-align:center;'>cohort_name</th></tr>\n<tr><th colspan='2' style='text-align:center;'>cohort1</th><th colspan='2' style='text-align:center;'>cohort2</th></tr>\n<tr><th colspan='4' style='text-align:center;'>sex</th></tr>\n<tr><th style='text-align:center;'>male</th><th style='text-align:center;'>female</th><th style='text-align:center;'>male</th><th style='text-align:center;'>female</th></tr>\n</thead>\n</table>"
      
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
      $options$columnDefs[[1]]$name
      [1] "cdm_name"
      
      $options$columnDefs[[1]]$targets
      [1] 0
      
      
      $options$columnDefs[[2]]
      $options$columnDefs[[2]]$name
      [1] "cohort_name\ncohort1\nsex\nmale"
      
      $options$columnDefs[[2]]$targets
      [1] 1
      
      
      $options$columnDefs[[3]]
      $options$columnDefs[[3]]$name
      [1] "cohort_name\ncohort1\nsex\nfemale"
      
      $options$columnDefs[[3]]$targets
      [1] 2
      
      
      $options$columnDefs[[4]]
      $options$columnDefs[[4]]$name
      [1] "cohort_name\ncohort2\nsex\nmale"
      
      $options$columnDefs[[4]]$targets
      [1] 3
      
      
      $options$columnDefs[[5]]
      $options$columnDefs[[5]]$name
      [1] "cohort_name\ncohort2\nsex\nfemale"
      
      $options$columnDefs[[5]]$targets
      [1] 4
      
      
      
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
      [1] "cdm_name"                          "cohort_name\ncohort1\nsex\nmale"  
      [3] "cohort_name\ncohort1\nsex\nfemale" "cohort_name\ncohort2\nsex\nmale"  
      [5] "cohort_name\ncohort2\nsex\nfemale"
      attr(,"rownames")
      [1] FALSE

