global_router_register __FILE_FULL__.replace(/.*exhibition\//, "").replace(".com.coffee", ""), __FILE__.replace(".com.coffee", "")
module.exports =
  render : ()->
    table {class:"table table_code_exhibition"}
      tbody
        tr
          th "code"
          th "render"
        
        tr
          td
            Textarea_coffee_script value:"""
              Button {
                label:"label"
              }
              """#"
          td
            Button {
              label:"label"
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Button {
                label:"label"
                disabled:true
              }
              """#"
          td
            Button {
              label:"label"
              disabled:true
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Button {
                label:"label"
                on_click:()->alert 1
              }
              """#"
          td
            Button {
              label:"label"
              on_click:()->alert 1
            }
