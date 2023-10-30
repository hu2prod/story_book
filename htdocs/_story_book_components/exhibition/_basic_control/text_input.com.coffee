global_router_register __FILE_FULL__.replace(/.*exhibition\//, "").replace(".com.coffee", ""), __FILE__.replace(".com.coffee", "")
module.exports =
  state:
    value : "text"
  render : ()->
    table {class:"table table_code_exhibition"}
      tbody
        tr
          th "code"
          th "render"
        
        tr
          td
            Textarea_coffee_script value:"""
              Text_input {
                value: @state.value
                on_change:(value)=>@set_state {value}
              }
              """#"
          td
            Text_input {
              value: @state.value
              on_change:(value)=>@set_state {value}
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Text_input {
                disabled:true
                value: @state.value
                on_change:(value)=>@set_state {value}
              }
              """#"
          td
            Text_input {
              disabled:true
              value: @state.value
              on_change:(value)=>@set_state {value}
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Text_input {
                value: @state.value
                on_change:(value)=>@set_state {value}
                on_enter:(value)=>alert "on_enter"
              }
              """#"
          td
            Text_input {
              value: @state.value
              on_change:(value)=>@set_state {value}
              on_enter:(value)=>alert "on_enter"
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Text_input bind2 @, "value"
              """#"
          td
            Text_input bind2 @, "value"
