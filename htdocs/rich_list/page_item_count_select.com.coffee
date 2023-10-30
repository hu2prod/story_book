module.exports =
  render : ()->
    Select {
      list  : @props.data_controller.item_per_page_count_list.map (value)->{title:value, value}
      value : @props.data_controller.item_per_page_count
      on_change : (new_value)=>
        @props.data_controller.item_per_page_count = +new_value
        # TODO mode. recalc page_idx, not reset
        @props.data_controller.page_idx = 0
        
        @props.on_change()
    }
