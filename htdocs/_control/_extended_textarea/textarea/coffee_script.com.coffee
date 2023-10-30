###
  bad enter
    AR: go to start line (or random-catched indent)
    ER: indent same as previous line
  [+] ctrl-D should duplicate string, NOT delete
  [+] insert mode should have FAT cursor or temp disable it
  word based code completion
    also should be first suggested in list
  
  [+] 2 Textarea_coffee_script второй падает на инициализации
  При рендере http://192.168.88.189:10000/#/exhibition_table рендерится не весь код
###

module.exports =
  mount_done : ()->
    # keymap = clone CodeMirror.keyMap.sublime # LATER
    keymap = {}
    
    transform_fn = (cb)->
      (cm)->
        return if !selection = cm.getSelection()
        from = cm.getCursor "start"
        to = cm.getCursor "end"
        cm.replaceSelection cb selection
        cm.setSelection from, to
        return
    
    obj_set keymap, {
      "Ctrl-Space": "autocomplete"
      "Ctrl-Q"    : "toggleComment"
      "Ctrl-D"    : (cm)-> # duplicate line
        current_cursor = cm.doc.getCursor("from")
        line_idx = current_cursor.line
        selected_text = cm.doc.getSelection()
        line_count = selected_text.split("\n").length
        
        selected_lines = []
        for i in [line_idx ... line_idx + line_count]
          selected_lines.push cm.doc.getLine(i)
        
        cm.doc.setCursor(line_idx + line_count-1, selected_lines.last().length)
        cm.doc.replaceSelection("\n"+selected_lines.join("\n"))
        cm.doc.setSelection({
          line: line_idx + line_count
          ch  : 0
        }, {
          line: line_idx + line_count + line_count-1
          ch  : selected_lines.last().length
        })
        return
      "Ctrl-/"    : "toggleComment"
      "Tab" : (cm)->
        if cm.getMode().name == "null" or !cm.somethingSelected()
          if cm.getOption "indentWithTabs"
            CodeMirror.commands.defaultTab cm
          else
            cursor = cm.getCursor()
            spaces_to_insert = cm.getOption("indentUnit") - (cursor.ch % cm.getOption("indentUnit"))
            cm.replaceSelection " ".repeat(spaces_to_insert), "end", "+input"
          return
        
        spaces_to_add = " ".repeat cm.getOption("indentUnit")
        selection_list= cm.listSelections()
        
        cm.operation ()->
          for range in selection_list
            from_line = range.from().line
            to_line   = range.to().line
            for i in [from_line .. to_line]
              cm.replaceRange spaces_to_add, {line: i, ch: 0}
          return
        return
      "Shift-Tab" : (cm)->
        decrease_indent = (line, from_ch, to_ch) ->
          cm.replaceRange "", {line: line, ch: from_ch}, {line: line, ch: to_ch}
        
        if cm.getOption("indentWithTabs")
          # never tested
          if cm.getMode().name == "null" or !cm.somethingSelected()
            cursor = cm.getCursor()
            line_content = cm.getLine(cursor.line)
            if line_content.startsWith("\t")
              decrease_indent cursor.line, 0, 1
            return
          
          selection_list = cm.listSelections()
          cm.operation () ->
            for range in selection_list
              from_line = range.from().line
              to_line   = range.to().line
              for line_index in [from_line .. to_line]
                line_content = cm.getLine(line_index)
                if line_content.startsWith("\t")
                  decrease_indent line_index, 0, 1  # remove the tab character
            return
          return
        
        # whitespace
        spaces_to_remove = cm.getOption("indentUnit")
        line_process = (line_index)->
          line_content = cm.getLine line_index
          if reg_ret = /^ +/.exec line_content
            remove_length = Math.min reg_ret[0].length, spaces_to_remove
            decrease_indent line_index, 0, remove_length
          return
        
        if cm.getMode().name == "null" or !cm.somethingSelected()
          cursor = cm.getCursor()
          line_process cursor.line
          return
        
        selection_list = cm.listSelections()
        cm.operation () ->
          for range in selection_list
            from_line = range.from().line
            to_line   = range.to().line
            for line_index in [from_line .. to_line]
              line_process line_index
          return
        return
      "Ctrl-S"    : ()=>
        @props.on_save?()
      
      "Enter" : (cm)->
        selected_text = cm.doc.getSelection()
        if selected_text.length > 0
          cm.doc.replaceSelection("")
        
        current_cursor = cm.doc.getCursor()
        line = cm.doc.getLine(current_cursor.line)
        [spacer] = /^\s*/.exec line
        cm.doc.replaceSelection("\n"+spacer)
        return
      "F3"      : (cm)->CodeMirror.commands.findNext cm
      "Shift-F3": (cm)->CodeMirror.commands.findPrev cm
      "Ctrl-H"  : (cm)->CodeMirror.commands.replace cm
      "Ctrl-U"  : transform_fn (txt)->txt.toUpperCase()
      "Ctrl-L"  : transform_fn (txt)->txt.toLowerCase()
      # TODO Alt-R (en-ru)
    }
    if @props.keymap
      obj_set keymap, @props.keymap
    editor_options =
      lineNumbers       : true
      lineWrapping      : true
      matchBrackets     : true
      showTrailingSpace : true
      lint              : true
      lineComment       : "#"
      continueComments  : true
      styleActiveLine   : true
      placeholder       : @props.placeholder
      tabSize           : 2
      indentWithTabs    : false
      # LATER
      hintOptions       :
        hint : (cm)->
          lists = [
            CodeMirror.hint.anyword(cm)
            CodeMirror.hint.javascript(cm)
          ]
          list = []
          for v in lists
            continue if !v
            list.append v.list
          
          cursor = cm.getCursor()
          
          pos = cursor.ch-1
          curr_line = cm.getLine(cursor.line)
          while pos
            ch = curr_line[pos]
            break if !/[_a-z0-9]/i.test ch
            pos--
          pos++
          
          from = {
            line: cursor.line
            ch  : pos
          }
          
          ret =
            from: from
            to  : cursor
            list: list
      mode              : "coffeescript"
      extraKeys         : keymap
    
    obj_set editor_options, @props.opt if @props.opt
    @cm = CodeMirror.fromTextArea @refs.textarea, editor_options
    @cm.on "change", ()=>
      # call_later ()=> # ПОДУМАТЬ
      value = @cm.getValue()
      # return if @props.value == value
      @props.on_change value
      return
    @cm.setValue @props.value or ""
    # prevent ctrl-Z wipe content
    @cm.clearHistory()
    # mods
    # вот это убивает второй Textarea_coffee_script
    # @cm.addOverlay window.indentGuidesOverlay
    return
  
  props_change : (new_props)->
    value = @cm.getValue()
    if new_props.value != value
      if @cm.getValue() != new_props.value
        @cm.setValue new_props.value or ""
    
    return
  
  unmount : ()->
    @cm.toTextArea()
    return
  
  render : ()->
    div {
      class : @props.class
      style : @props.style
    }
      textarea {
        ref: "textarea"
        style : @props.textarea_style
      }
