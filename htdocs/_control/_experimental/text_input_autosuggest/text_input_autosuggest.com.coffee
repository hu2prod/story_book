module.exports =
  state : {
    has_focus: false
    focus_suggest_option_idx : 0
  }
  ref : null
  render : ()->
    {autosuggest_list} = @props
    if autosuggest_active = autosuggest_list?.length and @state.has_focus
      if autosuggest_list.has @props.value
        autosuggest_active = false
    
    span
      input {
        type        : "text"
        value       : @props.value or ""
        on_change   : @on_change
        onFocus     : ()=>
          @set_state {has_focus: true}
          @ref.has_focus = true
          @props.on_focus?()
        
        onBlur      : ()=>
          @set_state {
            has_focus: false
            focus_suggest_option_idx: 0
          }
          @ref.has_focus = false
          @props.on_blur?()
        
        placeholder : @props.placeholder or ""
        style       : @props.style
        ref         : (ref)=>
          @ref = ref
          @props.text_input_ref? ref
        
        onKeyDown: (event)=>
          if autosuggest_active
            switch event.nativeEvent.which
              when Keymap.UP
                if @state.focus_suggest_option_idx > 0
                  @set_state focus_suggest_option_idx: @state.focus_suggest_option_idx-1
                return
              when Keymap.DOWN
                if @state.focus_suggest_option_idx < autosuggest_list.length-1
                  @set_state focus_suggest_option_idx: @state.focus_suggest_option_idx+1
                return
              when Keymap.ENTER
                suggest_option = autosuggest_list[@state.focus_suggest_option_idx]
                @props.on_change suggest_option
                @set_state {
                  focus_suggest_option_idx : 0
                }
                return
          
          @props.on_key_down? event
        
        onKeyPress: (event)=>    
          @props.on_key_press? event
          if event.nativeEvent.which == Keymap.ENTER
            @props.on_enter?()
          return
      }
      div {
        style : {
          position: "absolute"
        }
      }
        if autosuggest_active
          table {
            style: {
              background: "#fff"
              border    : "1px solid #aaa"
            }
          }
            tbody
              for suggest_option,suggest_option_idx in autosuggest_list
                do (suggest_option, suggest_option_idx)=>
                  tr
                    td {
                      on_hover : ()=>
                        @set_state focus_suggest_option_idx : suggest_option_idx
                      on_mouse_down : ()=>
                        @props.on_change suggest_option
                      style : {
                        background : if suggest_option_idx == @state.focus_suggest_option_idx then "#C9FFFA" else ""
                      }
                    }, suggest_option
  
  on_change : (event)->
    value = event.target.value
    @props.on_change(value)
    return
