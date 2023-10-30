
module.exports =
  render : ()->
    div {style : @props.style}
      textarea {ref: "textarea"}
  
  mount_done : ()->
    keymap = clone CodeMirror.keyMap.sublime # LATER
    keymap = {}
    obj_set keymap, {
      "Ctrl-Space": "autocomplete"
      "Ctrl-Q"    : "toggleComment"
      "Ctrl-D"    : (cm)-> # duplicate line
        current_cursor = cm.doc.getCursor()
        selected_text = cm.doc.getSelection()
        line_count = selected_text.split("\n").length
        
        if current_cursor.xRel == 1
          current_cursor.line -= line_count-1
        
        selected_lines = []
        for i in [current_cursor.line ... current_cursor.line + line_count]
          selected_lines.push cm.doc.getLine(i)
        
        cm.doc.setCursor(current_cursor.line + line_count-1, selected_lines.last().length)
        cm.doc.replaceSelection("\n"+selected_lines.join("\n"))
        cm.doc.setSelection({
          line: current_cursor.line + line_count
          ch  : 0
        }, {
          line: current_cursor.line + line_count + line_count-1
          ch  : selected_lines.last().length
        })
        return
      "Ctrl-/"    : "toggleComment"
      "Shift-Tab" : "indentLess"
      "Tab"       : (cm)->
        if cm.doc.somethingSelected()
            return CodeMirror.Pass
        
        spacesPerTab = cm.getOption("indentUnit")
        spacesToInsert = spacesPerTab - (cm.doc.getCursor("start").ch % spacesPerTab)
        spaces = Array(spacesToInsert + 1).join(" ")
        cm.replaceSelection(spaces, "end", "+input")
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
    }
    editor_options =
      lineNumbers       : true
      lineWrapping      : true
      matchBrackets     : true
      showTrailingSpace : true
      continueComments  : true
      styleActiveLine   : true
      placeholder       : @props.placeholder
      tabSize           : 2
      indentWithTabs    : false
      # LATER
      hintOptions       :
        hint : (cm)->
          lists = [
            CodeMirror.hint.css(cm)
            CodeMirror.hint.anyword(cm)
          ]
          list = []
          base = null
          for v in lists
            continue if !v
            base = v
            list.append v.list
          ret =
            from: base.from
            to  : base.to
            list: list
      mode              : "css"
      extraKeys         : keymap
    
    @cm = CodeMirror.fromTextArea @refs.textarea, editor_options
    @cm.on "change", ()=>
      # call_later ()=> # ПОДУМАТЬ
      value = @cm.getValue()
      return if @props.value == value
      @props.on_change value
      return
    @cm.setValue @props.value or ""
    # mods
    @cm.addOverlay window.indentGuidesOverlay
    return
  
  props_change : (new_props)->
    value = @cm.getValue()
    if new_props.value != value
      @cm.setValue new_props.value or ""
    
    return
  
  unmount : ()->
    @cm.toTextArea()
    return
  