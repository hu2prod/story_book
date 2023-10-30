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
              Textarea {
                value: @state.value
                on_change:(value)=>@set_state {value}
              }
              """#"
          td
            Textarea {
              value: @state.value
              on_change:(value)=>@set_state {value}
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Textarea {
                disabled:true
                value: @state.value
                on_change:(value)=>@set_state {value}
              }
              """#"
          td
            Textarea {
              disabled:true
              value: @state.value
              on_change:(value)=>@set_state {value}
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Textarea bind2 @, "value"
              """#"
          td
            Textarea bind2 @, "value"
