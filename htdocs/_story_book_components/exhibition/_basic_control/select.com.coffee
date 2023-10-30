global_router_register __FILE_FULL__.replace(/.*exhibition\//, "").replace(".com.coffee", ""), __FILE__.replace(".com.coffee", "")
module.exports =
  state:
    value : ""
  render : ()->
    list = [
      {value:""}
      {value:"option a"}
      {value:"option b"}
      {value:"option c"}
    ]
    table {class:"table table_code_exhibition"}
      tbody
        tr
          th "code"
          th "render"
        
        tr
          td
            Textarea_coffee_script value:"""
              Select {
                value: @state.value
                on_change:(value)=>@set_state {value}
                list: list
              }
              """#"
          td
            Select {
              value: @state.value
              on_change:(value)=>@set_state {value}
              list: list
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Select {
                disabled:true
                value: @state.value
                on_change:(value)=>@set_state {value}
                list: list
              }
              """#"
          td
            Select {
              disabled:true
              value: @state.value
              on_change:(value)=>@set_state {value}
              list: list
            }
        
        tr
          td
            Textarea_coffee_script value:"""
              Select {list}, bind2 @, "value"
              """#"
          td
            Select {list}, bind2 @, "value"
