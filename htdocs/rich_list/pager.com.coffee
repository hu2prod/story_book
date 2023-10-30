module.exports =
  render : ()->
    # TODO multipage select for infinite scroll
    page             = @props.data_controller.page_idx
    total_page_count = @props.data_controller.total_page_count_get()
    on_change = (page_idx)=>
      @props.data_controller.page_idx = page_idx
      @props.on_change()
    
    div {
      style:
        whiteSpace: "nowrap"
    }
      Button {
        label : "<<"
        disabled : page == 0
        on_click : ()=>
          return if page == 0
          on_change 0
      }
      Button {
        label : "<"
        disabled : page == 0
        on_click : ()=>
          return if page == 0
          on_change page-1
      }
      span " Page #{page+1}/#{total_page_count} "
      Button {
        label : ">"
        disabled : page+1 == total_page_count
        on_click : ()=>
          return if page+1 == total_page_count
          on_change page+1
      }
      Button {
        label : ">>"
        disabled : page+1 == total_page_count
        on_click : ()=>
          return if page+1 == total_page_count
          on_change total_page_count-1
      }
