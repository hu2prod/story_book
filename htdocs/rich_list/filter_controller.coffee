class window.Data_filter_controller_full_list
  # config const
  filter_descriptor_list: []
  full_list             : []
  unpaged_filtered_list : []
  filtered_list         : []
  
  page_idx              : 0
  item_per_page_count   : Infinity
  # config const
  item_per_page_count_list : []
  
  view_type             : "table"
  # config const
  view_type_list        : ["table", "widget", "tile"]
  
  constructor:()->
    @filter_descriptor_list = []
    @full_list              = []
    @unpaged_filtered_list  = []
    @filtered_list          = []
    @item_per_page_count_list = []
  
  filtered_list_refresh : ()->
    filtered_list = @full_list
    for v in filtered_list
      v.hover = false
    
    for filter in @filter_descriptor_list
      continue if filter.selected_value_list.length == 0
      filter_selected_value_hash = filter.selected_value_hash
      filter_key = filter.key
      new_filtered_list = []
      
      for item in filtered_list
        filter_value = item[filter_key]
        continue if !filter_selected_value_hash[filter_value]
        new_filtered_list.push item
      
      filtered_list = new_filtered_list
    
    for v,k in filtered_list
      v.idx = k
    
    @unpaged_filtered_list = filtered_list
    page_filtered_list = null
    if filtered_list.length and isFinite @item_per_page_count
      loop
        start_idx = @page_idx*@item_per_page_count
        page_filtered_list = filtered_list.slice start_idx, start_idx + @item_per_page_count
        if page_filtered_list.length == 0
          break if @page_idx == 0
          @page_idx--
          continue
        break
    
    
    @filtered_list = page_filtered_list ? filtered_list
    
    # entropy -> information count
    for filter in @filter_descriptor_list
      filter_key = filter.key
      count_hash = {}
      for v in filtered_list
        val = v[filter_key]
        count_hash[val] ?= 0
        count_hash[val]++
      
      for filter_value in filter.value_list
        filter_value.filtered_count = count_hash[filter_value.value]
      
      total_count = filtered_list.length
      h = 0
      for k,v of count_hash
        prob = v/total_count
        h -= prob * Math.log2 prob
      
      filter.info_val = h
    
    # ###################################################################################################
    #    filtered_group_count_hash
    # ###################################################################################################
    for filter in @filter_descriptor_list
      filter.filtered_group_count_hash = {}
      walk = (tree, nested_key)=>
        if tree instanceof Array
          value_hash = {}
          for v in tree
            value_hash[v.value] = true
          filter_key = filter.key
          
          count = 0
          for v in filtered_list
            count++ if value_hash[v[filter_key]]
          
          filter.filtered_group_count_hash[nested_key] = count
          return count
        
        sum_count = 0
        for k,v of tree
          loc_nested_key = "#{nested_key}_#{k}"
          sum_count += walk v, loc_nested_key
        
        filter.filtered_group_count_hash[nested_key] = sum_count
        return sum_count
      walk filter.value_tree, ""
    
    return
  
  total_page_count_get : ()->
    if isFinite @item_per_page_count
      Math.ceil @unpaged_filtered_list.length / @item_per_page_count
    else
      1