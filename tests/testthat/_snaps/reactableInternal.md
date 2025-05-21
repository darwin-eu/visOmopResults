# multiplication works

    Code
      dt$x
    Output
      $tag
      <Reactable data="{&quot;group&quot;:[&quot;A&quot;,&quot;A&quot;,&quot;B&quot;,&quot;B&quot;,&quot;C&quot;,&quot;C&quot;],&quot;name&quot;:[&quot;Alice&quot;,&quot;Bob&quot;,&quot;Charlie&quot;,&quot;David&quot;,&quot;Eve&quot;,&quot;Frank&quot;],&quot;age&quot;:[25,30,35,40,22,28],&quot;score&quot;:[85,90,88,92,95,87]}" columns="list(id = &quot;group&quot;, name = &quot;group&quot;, type = &quot;character&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;name&quot;, name = &quot;name&quot;, type = &quot;character&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;age&quot;, name = &quot;age&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;score&quot;, name = &quot;score&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;))" searchable="TRUE" defaultPageSize="10" showPageSizeOptions="TRUE" defaultExpanded="TRUE" highlight="TRUE" striped="TRUE" dataKey="bdea78eb05bc4e48989730d861cae0f3" static="FALSE"></Reactable>
      
      $class
      [1] "reactR_markup"
      

---

    Code
      dt$x
    Output
      $tag
      <Reactable data="{&quot;group&quot;:[&quot;A&quot;,&quot;A&quot;,&quot;B&quot;,&quot;B&quot;,&quot;C&quot;,&quot;C&quot;],&quot;name&quot;:[&quot;Alice&quot;,&quot;Bob&quot;,&quot;Charlie&quot;,&quot;David&quot;,&quot;Eve&quot;,&quot;Frank&quot;],&quot;age&quot;:[25,30,35,40,22,28],&quot;score&quot;:[85,90,88,92,95,87]}" columns="list(id = &quot;group&quot;, name = &quot;group&quot;, type = &quot;character&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;name&quot;, name = &quot;name&quot;, type = &quot;character&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;age&quot;, name = &quot;age&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;score&quot;, name = &quot;score&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;))" groupBy="group" searchable="TRUE" defaultPageSize="10" showPageSizeOptions="TRUE" defaultExpanded="TRUE" highlight="TRUE" striped="TRUE" dataKey="bdea78eb05bc4e48989730d861cae0f3" static="FALSE"></Reactable>
      
      $class
      [1] "reactR_markup"
      

# Multi-level headers generate correct HTML

    Code
      dt$x
    Output
      $tag
      <Reactable data="{&quot;cdm_name&quot;:[&quot;A&quot;,&quot;A&quot;,&quot;B&quot;,&quot;B&quot;,&quot;C&quot;,&quot;C&quot;],&quot;male&quot;:[1,1,1,1,1,1],&quot;female&quot;:[2,2,2,2,2,2],&quot;cohort1&quot;:[3,3,3,3,3,3],&quot;cohort2&quot;:[4,4,4,4,4,4]}" columns="list(id = &quot;cdm_name&quot;, name = &quot;cdm_name&quot;, type = &quot;character&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;male&quot;, name = &quot;male&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;female&quot;, name = &quot;female&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;cohort1&quot;, name = &quot;cohort1&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;cohort2&quot;, name = &quot;cohort2&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;))" columnGroups="list(headerStyle = list(textAlign = &quot;center&quot;), name = &quot;sex&quot;, columns = list(&quot;male&quot;, &quot;female&quot;)) list(headerStyle = list(textAlign = &quot;center&quot;), name = &quot;cohort_name&quot;, columns = list(&quot;cohort1&quot;, &quot;cohort2&quot;))" searchable="TRUE" defaultPageSize="10" showPageSizeOptions="TRUE" defaultExpanded="TRUE" highlight="TRUE" striped="TRUE" dataKey="da8b4e1ed4f2cabd87c1a27a56aa82a3" static="FALSE"></Reactable>
      
      $class
      [1] "reactR_markup"
      

---

    Code
      dt$x
    Output
      $tag
      <Reactable data="{&quot;cdm_name&quot;:[&quot;A&quot;,&quot;A&quot;,&quot;B&quot;,&quot;B&quot;,&quot;C&quot;,&quot;C&quot;],&quot;male&quot;:[1,1,1,1,1,1],&quot;female&quot;:[2,2,2,2,2,2],&quot;cohort1&quot;:[3,3,3,3,3,3],&quot;cohort2&quot;:[4,4,4,4,4,4]}" columns="list(id = &quot;cdm_name&quot;, name = &quot;cdm_name&quot;, type = &quot;character&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;male&quot;, name = &quot;male&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;female&quot;, name = &quot;female&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;cohort1&quot;, name = &quot;cohort1&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;)) list(id = &quot;cohort2&quot;, name = &quot;cohort2&quot;, type = &quot;numeric&quot;, sortable = TRUE, resizable = TRUE, filterable = TRUE, headerStyle = list(textAlign = &quot;center&quot;))" columnGroups="list(headerStyle = list(textAlign = &quot;center&quot;), name = &quot;sex&quot;, columns = list(&quot;male&quot;, &quot;female&quot;)) list(headerStyle = list(textAlign = &quot;center&quot;), name = &quot;cohort_name&quot;, columns = list(&quot;cohort1&quot;, &quot;cohort2&quot;))" groupBy="cdm_name" searchable="TRUE" defaultPageSize="10" showPageSizeOptions="TRUE" defaultExpanded="TRUE" highlight="TRUE" striped="TRUE" dataKey="da8b4e1ed4f2cabd87c1a27a56aa82a3" static="FALSE"></Reactable>
      
      $class
      [1] "reactR_markup"
      

