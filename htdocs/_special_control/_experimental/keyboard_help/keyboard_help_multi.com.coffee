module.exports =
  # credits http://code.tutsplus.com/tutorials/creating-a-__keyboard-with-css-and-jquery--net-5774
  render : ()->
    div {
      class : "keyboard"
    }
      for ctrl in [false, true]
        for shift in [false, true]
          for alt in [false, true]
            tooltip_hash = {}
            for code,list of @props.scheme.code_map
              for v in list
                continue if (v.ctrl  or v.opt_ctrl ) != ctrl
                continue if (v.alt   or v.opt_alt  ) != alt
                continue if (v.shift or v.opt_shift) != shift
                tooltip_hash[Keymap.rev_map[code]] = v.description
            continue if 0 == h_count tooltip_hash
            div {
              class : "keyboard_mod"
            }
              Keyboard_help {
                tooltip_hash
                ctrl
                shift
                alt
              }
      return # BUG FIX
