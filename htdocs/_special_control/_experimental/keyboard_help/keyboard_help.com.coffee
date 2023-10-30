remap_hash =
  pageup    : "pgup"
  pagedown  : "pgdn"
  "num_/"   : "/"
  "num_*"   : "*"
  "num_-"   : "-"
  "num_+"   : "+"
  "num_."   : "."
  num_0     : "0"
  num_1     : "1"
  num_2     : "2"
  num_3     : "3"
  num_4     : "4"
  num_5     : "5"
  num_6     : "6"
  num_7     : "7"
  num_8     : "8"
  num_9     : "9"
  capslock  : "caps lock"
  numlock   : "num"
  up        : "^"
  win_left  : "win"
  win_right : "win"
  left      : "<"
  down      : "V"
  right     : ">"

module.exports =
  render : ()->
    ul {
      class : "__keyboard"
    }
      # TODO remove extra alloc
      tooltip_hash = @props.tooltip_hash or {}
      ch_render = (ch, _class = "letter", li_style = {}, tt_style={}, selected = false)=>
        remap_ch = remap_hash[ch] or ch
        Tooltip {
          style    : tt_style
          show_lag : 100
          hide_lag : 0
          tooltip_render : ()=>
            return if !view_text = tooltip_hash[ch]
            div {class : "keyboard_tooltip"}
              div {class : "keyboard_tooltip-arrow"}
              div {class : "keyboard_tooltip-inner"}, view_text
        }
          li {
            class: "#{_class} #{if selected or tooltip_hash[ch] then 'selected' else ''}"
            style: li_style
          }, remap_ch
      
      spacer_render = ()->div {style:display:"inline-block"}, li {class:"pad"}
      letter_skip_render = ()->div {style:display:"inline-block"}, li {class:"letter_pad"}
      
      # ###################################################################################################
      #    LINE 0
      # ###################################################################################################
      
      ch_render "esc"
      for i in [1 .. 12]
        ch_render "f#{i}"
      
      # TODO scroll lock
      # TODO pause break
      
      br
      # ###################################################################################################
      #    LINE 1
      # ###################################################################################################
      str_norm  = "`1234567890-="
      # str_shift = "~!@#$%^&*()_+"
      for v in str_norm
        ch_render v
      
      ch_render "backspace", "backspace"
      spacer_render()
      # # ###################################################################################################
      for val in ["insert", "home", "pageup"]
        ch_render val
      spacer_render()
      # # ###################################################################################################
      for val in ["numlock", "num_/", "num_*", "num_-"]
        ch_render val
      # ###################################################################################################
      #    LINE 2
      # ###################################################################################################
      ch_render "tab", "tab"
      str_norm  = "qwertyuiop[]\\"
      # str_shift = "qwertyuiop{}\\"
      for ch in str_norm
        ch_render ch
      spacer_render()
      for val in ["delete", "end", "pagedown"]
        ch_render val
      spacer_render()
      # # ###################################################################################################
      for val in "789"
        ch_render "num_#{val}"
      ch_render "num_+", "letter num_key", {height:88}, {position: "absolute"}
      # ###################################################################################################
      #    LINE 3
      # ###################################################################################################
      ch_render "capslock", "capslock"
      str_norm  = "asdfghjkl;'"
      # str_shift = "asdfghjkl:\""
      for ch in str_norm
        ch_render ch
      ch_render "enter", "enter"
      spacer_render()
      # ###################################################################################################
      letter_skip_render()
      letter_skip_render()
      letter_skip_render()
      spacer_render()
      # # ###################################################################################################
      for val in "456"
        ch_render "num_#{val}"
      # ###################################################################################################
      #    LINE 4
      # ###################################################################################################
      ch_render "shift", "left-shift", {}, {}, @props.shift
      str_norm  = "zxcvbnm,./"
      # str_shift = "zxcvbnm<>?"
      for ch in str_norm
        ch_render ch
      ch_render "shift", "right-shift", {}, {}, @props.shift
      spacer_render()
      # ###################################################################################################
      letter_skip_render()
      ch_render "up", "letter", fontSize: 25
      # li {class:"letter", style:fontSize: 25}, "^"
      letter_skip_render()
      spacer_render()
      # # ###################################################################################################
      for val in "123"
        ch_render "num_#{val}"
      ch_render "enter", "letter num_key", {height:88}, {position: "absolute"}
      # ###################################################################################################
      #    LINE 5
      # ###################################################################################################
      ch_render "ctrl", "left-ctrl", null, null, @props.ctrl
      ch_render "win_left"
      ch_render "alt", null, null, null, @props.alt
      ch_render "space", "space"
      ch_render "alt", null, null, null, @props.alt
      ch_render "win_right"
      ch_render "list"
      ch_render "ctrl", "right-ctrl", null, null, @props.ctrl
      spacer_render()
      # # ###################################################################################################
      ch_render "left", "letter", fontWeight: 700
      ch_render "down", "letter", fontWeight: 700
      ch_render "right","letter", fontWeight: 700
      spacer_render()
      # # ###################################################################################################
      ch_render "num_0", "letter2"
      ch_render "num_."
      