global_router_register __FILE_FULL__.replace(/.*exhibition\//, "").replace(".com.coffee", ""), __FILE__.replace(".com.coffee", "")
module.exports =
  state:
    hover1: false
  render : ()->
    window.test = window.copy
    table {class:"table table_code_exhibition"}
      tbody
        tr
          th "code"
          th "render"
        
        tr
          td
            Textarea_coffee_script value:"""
              # auto on hover container or tooltip_container
              Tooltip {
                tooltip_render : ()=>
                  div {
                    style:
                      backgroundColor: "#eee"
                  }
                    nobr "hello world"
              }
                Button {
                  label: "test"
                }
              """#"
          td
            Tooltip {
              tooltip_render : ()=>
                div {
                  style:
                    backgroundColor: "#eee"
                }
                  nobr "hello world"
            }
              Button {
                label: "test"
              }
        # ###################################################################################################
        tr
          td
            Textarea_coffee_script value:"""
              # manual
              Tooltip {
                show : @state.hover1
                tooltip_render : ()=>
                  div {
                    style:
                      backgroundColor: "#eee"
                  }
                    nobr "hello world"
              }
                Button {
                  label: "test"
                  on_hover: ()=>@set_state hover1: true
                  on_blur : ()=>@set_state hover1: false
                }
              """#"
          td
            Tooltip {
              show : @state.hover1
              tooltip_render : ()=>
                div {
                  style:
                    backgroundColor: "#eee"
                }
                  nobr "hello world"
            }
              Button {
                label: "test"
                on_hover: ()=>@set_state hover1: true
                on_blur : ()=>@set_state hover1: false
              }
        # ###################################################################################################
        tr
          td
            Textarea_coffee_script value:"""
              # permanent
              Tooltip {
                show : true
                tooltip_render : ()=>
                  div {
                    style:
                      backgroundColor: "#eee"
                  }
                    nobr "hello world"
              }
                Button {
                  label: "test"
                }
              """#"
          td
            Tooltip {
              show : true
              tooltip_render : ()=>
                div {
                  style:
                    backgroundColor: "#eee"
                }
                  nobr "hello world"
            }
              Button {
                label: "test"
              }
        # ###################################################################################################
        tr
          td
            Textarea_coffee_script value:"""
              # permanent + scroll box
              Tooltip {
                show : true
                tooltip_render : ()=>
                  div {
                    style:
                      backgroundColor: "#eee"
                  }
                    nobr "hello world"
              }
                Button {
                  label: "test"
                }
              """#"
          td
            div {
              style:
                overflow: "scroll"
                width   : 300
                height  : 50
                padding : 50
            }
              Tooltip {
                show : true
                tooltip_render : ()=>
                  div {
                    style:
                      backgroundColor: "#eee"
                  }
                    nobr "hello world"
              }
                Button {
                  label: "test"
                  style:
                    width   : 500
                    height  : 100
                }
        # ###################################################################################################
        tr
          td
            Textarea_coffee_script value:"""
              # demo
              # click to copy to clipboard
              """#"
          td
            table {class:"table"}
              tbody
                tr
                  td {rowSpan:3, colSpan:2}
                tr
                  th {colSpan:3}, "mount_point_x"
                tr
                  for x in ["left", "center", "right"]
                    th x
                tr
                  th {rowSpan:4}, "mount_point_y"
                for y in ["top", "center", "bottom"]
                  tr
                    th y
                    for x in ["left", "center", "right"]
                      td
                        table {class:"table"}
                          tbody
                            tr
                              td {rowSpan:3, colSpan:2}
                            tr
                              th {colSpan:3}, "position_x"
                            tr
                              for p_x in ["left", "center", "right"]
                                th p_x
                            tr
                              th {rowSpan:4}, "position_y"
                            for p_y in ["top", "center", "bottom"]
                              tr
                                th p_y
                                for p_x in ["left", "center", "right"]
                                  td
                                    Tooltip {
                                      show          : true
                                      position_x    : p_x
                                      position_y    : p_y
                                      mount_point_x : x
                                      mount_point_y : y
                                      tooltip_render : ()=>
                                        div {
                                          style:
                                            backgroundColor: "#eee"
                                            border: "1px solid #000"
                                            padding: 3
                                        }, "tx"
                                    }
                                      do (x, y, p_x, p_y)=>
                                        Button {
                                          label: "#{x} #{y}"
                                          style:
                                            width : 55
                                            textAlign: "center"
                                          on_click : ()=>
                                            clipboard_copy """
                                              Tooltip {
                                                position_x    : #{JSON.stringify p_x}
                                                position_y    : #{JSON.stringify p_y}
                                                mount_point_x : #{JSON.stringify x}
                                                mount_point_y : #{JSON.stringify y}
                                                tooltip_render : ()=>
                                                  div {
                                                    style:
                                                      backgroundColor: "#eee"
                                                      border: "1px solid #000"
                                                      padding: 3
                                                  }, "tx"
                                              }
                                                Button {
                                                  label: "#{x} #{y}"
                                                }
                                              """#"
                                        }
        # ###################################################################################################
        
        