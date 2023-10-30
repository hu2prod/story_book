global_router_register __FILE_FULL__.replace(/.*exhibition\//, "").replace(".com.coffee", ""), __FILE__.replace(".com.coffee", "")
module.exports =
  state:
    value : 1
  render : ()->
    table {class:"table table_code_exhibition"}
      tbody
        tr
          th "code"
          th "render"
        
        tr
          td
            Textarea_coffee_script value:"""
              Number_input {
                value: @state.value
                on_change:(value)=>@set_state {value}
              }
              """#"
          td
            Number_input {
              value: @state.value
              on_change:(value)=>@set_state {value}
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Number_input {
                disabled:true
                value: @state.value
                on_change:(value)=>@set_state {value}
              }
              """#"
          td
            Number_input {
              disabled:true
              value: @state.value
              on_change:(value)=>@set_state {value}
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Number_input {
                value: @state.value
                on_change:(value)=>@set_state {value}
                on_enter:(value)=>alert "on_enter"
              }
              """#"
          td
            Number_input {
              value: @state.value
              on_change:(value)=>@set_state {value}
              on_enter:(value)=>alert "on_enter"
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Number_input bind2 @, "value"
              """#"
          td
            Number_input bind2 @, "value"
