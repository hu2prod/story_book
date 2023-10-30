global_router_register __FILE_FULL__.replace(/.*exhibition\//, "").replace(".com.coffee", ""), __FILE__.replace(".com.coffee", "")
module.exports =
  state:
    value : false
  render : ()->
    table {class:"table table_code_exhibition"}
      tbody
        tr
          th "code"
          th "render"
        
        tr
          td
            Textarea_coffee_script value:"""
              Checkbox {
                label:"label"
                value: @state.value
                on_change:(value)=>@set_state {value}
              }
              """#"
          td
            Checkbox {
              label:"label"
              value: @state.value
              on_change:(value)=>@set_state {value}
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Checkbox {
                label:"label"
                disabled:true
                value: @state.value
                on_change:(value)=>@set_state {value}
              }
              """#"
          td
            Checkbox {
              label:"label"
              disabled:true
              value: @state.value
              on_change:(value)=>@set_state {value}
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Checkbox {
                label:"label"
              }, bind2 @, "value"
              """#"
          td
            Checkbox {
              label:"label"
            }, bind2 @, "value"
