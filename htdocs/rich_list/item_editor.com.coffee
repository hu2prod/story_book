module.exports =
  hover_field : null
  on_change_hover : ()->
    # TODO fixme
    @force_update()
  
  # TODO clear on new selecteed item
  changed_field_list : []
  saved : true
  on_change : (field_list)->
    @changed_field_list.uappend field_list
    need_save = true
    need_save = false if !@props.config.save_on_edit
    need_save = false if !@props.config.save_on_create and !@props.value.id
    if !need_save
      @saved = false
      @force_update()
      return
    
    @on_save()
  
  on_save : ()->
    field_list = @changed_field_list.clone()
    @force_update()
    await @props.on_save field_list, defer(err); throw err if err
    # TODO error in UI
    @changed_field_list.clear()
    @saved = true
  
  render : ()->
    {
      value
      key_width
      value_width
      config
    } = @props
    action_td_style =
      width     : 30
      boxSizing : "border-box"
      paddingLeft  : 0
      paddingRight : 0
      margin       : 0
      textAlign    : "center"
    
    table {
      key   : value.id
      class : "table"
      on_mouse_out : ()=>
        @hover_field = null
        @on_change_hover()
    }
      tbody {
        style:
          verticalAlign : "top"
      }
        tr
          th {
            style:
              width : key_width
              textAlign : "right"
          }, "id"
          td value.id
        for field in config.editor_field_list
          # TODO special control for prefixed filters
          do (field)=>
            filter = config.filter_key_to_filter_descriptor_hash[field.name]
            tr {
              style:
                height: 30 # fix for vertical subpixel issue
              on_hover : ()=>
                @hover_field = field
                @on_change_hover()
            }
              th {
                style:
                  width : key_width
                  textAlign : "right"
              }, filter?.title ? field.name
              td
                if filter
                  if filter.multi
                    Rich_list_dyn_enum_editor {
                      filter: filter
                      value : value[field.name]
                      on_change : (new_value)=>
                        value[field.name] = new_value
                        @on_change [field.name]
                      style:
                        width : value_width
                    }
                  else
                    com = Select
                    com = Select_radio if filter.value_list.length < 5
                    com {
                      value : value[field.name]
                      list  : filter.value_list
                      on_change : (new_value)=>
                        value[field.name] = new_value
                        @on_change [field.name]
                      style:
                        width : value_width
                    }
                else
                  com = null
                  switch field.type
                    when "str"
                      com = Text_input
                    when "text"
                      com = Textarea
                    when "json"
                      com = Textarea_json
                    when "i32", "i64"
                      com = Number_input
                  if com
                    style =
                      boxSizing : "border-box"
                      width : value_width
                    
                    if field.style
                      obj_set style, field.style
                    
                    com {
                      value : value[field.name]
                      on_change : (new_value)=>
                        value[field.name] = new_value
                        @on_change [field.name]
                      style: style
                    }
                    # TODO other types
              td {
                style: action_td_style
              }
                if field.allow_null
                  # TODO respect config allow null
                  Button {
                    label : "x"
                    on_click : ()=>
                      delete value[field.name]
                      @on_change [field.name]
                    style:
                      display : if @hover_field != field then "none" else undefined
                      # microfix for jumping on hover (немногого выше высота чем остальных контролов)
                      height  : 18
                      width   : 18
                      lineHeight: 0
                      padding : 0
                      margin  : 0
                  }
        if !@saved or !@props.value.id?
          tr
            td {colSpan:3}
              Button {
                label : "Save"
                on_click : ()=>@on_save()
                style:
                  width   : "100%"
              }
