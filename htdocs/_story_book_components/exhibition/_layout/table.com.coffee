global_router_register __FILE_FULL__.replace(/.*exhibition\//, "").replace(".com.coffee", ""), __FILE__.replace(".com.coffee", "")
module.exports =
  render : ()->
    table {class:"table table_code_exhibition"}
      tbody
        tr
          th "code"
          th "render"
        
        tr
          td
            Textarea_coffee_script value:"""
              col_list = [
                {
                  key   : "name"
                  title : "Name"
                }
                {
                  key   : "count"
                  title : "Quantity"
                }
                {
                  key   : "price"
                  title : "Price"
                }
              ]
              data = [
                {
                  name  : "small"
                  count : 10
                  price : 0.1
                }
                {
                  name  : "big"
                  count : 1
                  price : 100
                }
              ]
              Table {
                data
                col_list
              }
              """#"
          td
            col_list = [
              {
                key   : "name"
                title : "Name"
              }
              {
                key   : "count"
                title : "Quantity"
              }
              {
                key   : "price"
                title : "Price"
              }
            ]
            data = [
              {
                name  : "small"
                count : 10
                price : 0.1
              }
              {
                name  : "big"
                count : 1
                price : 100
              }
            ]
            Table {
              data
              col_list
            }
        # ###################################################################################################
        tr
          td
            Textarea_coffee_script value:"""
              col_list = [
                {
                  key   : "name"
                  title : "Name"
                  renderer : (t)->b t
                }
                {
                  key   : "count"
                  title : "Quantity"
                }
                {
                  key   : "price"
                  title : "Price"
                }
              ]
              data = [
                {
                  name  : "small"
                  count : 10
                  price : 0.1
                }
                {
                  name  : "big"
                  count : 1
                  price : 100
                }
              ]
              Table {
                data
                col_list
              }
              """#"
          td
            col_list = [
              {
                key   : "name"
                title : "Name"
                renderer : (t)->b t
              }
              {
                key   : "count"
                title : "Quantity"
              }
              {
                key   : "price"
                title : "Price"
              }
            ]
            data = [
              {
                name  : "small"
                count : 10
                price : 0.1
              }
              {
                name  : "big"
                count : 1
                price : 100
              }
            ]
            Table {
              data
              col_list
            }
        # ###################################################################################################
        tr
          td
            Textarea_coffee_script value:"""
              col_list = [
                {
                  key   : "checked"
                  title : ""
                  renderer : (t, row, com)->
                    Checkbox {
                      value     : t
                      on_change : (value)->
                        row.checked = value
                        com.force_update()
                        return
                    }
                }
                {
                  key   : "name"
                  title : "Name"
                  renderer : (t)->b t
                }
                {
                  key   : "count"
                  title : "Quantity"
                }
                {
                  key   : "price"
                  title : "Price"
                }
              ]
              data = [
                {
                  name  : "small"
                  count : 10
                  price : 0.1
                }
                {
                  name  : "big"
                  count : 1
                  price : 100
                }
              ]
              Table {
                data
                col_list
              }
              """#"
          td
            col_list = [
              {
                key   : "checked"
                title : ""
                renderer : (t, row, com)->
                  Checkbox {
                    value     : t
                    on_change : (value)->
                      row.checked = value
                      com.force_update()
                      return
                  }
              }
              {
                key   : "name"
                title : "Name"
                renderer : (t)->b t
              }
              {
                key   : "count"
                title : "Quantity"
              }
              {
                key   : "price"
                title : "Price"
              }
            ]
            data = [
              {
                name  : "small"
                count : 10
                price : 0.1
              }
              {
                name  : "big"
                count : 1
                price : 100
              }
            ]
            Table {
              data
              col_list
            }
        # ###################################################################################################
        tr
          td
            Textarea_coffee_script value:"""
              col_list = [
                {
                  key   : "name"
                  title : "Name"
                }
                {
                  key   : "count"
                  title : "Quantity"
                }
                {
                  key   : "price"
                  title : "Price"
                }
              ]
              data = [
                {
                  name  : "small"
                  count : 10
                  price : 0.1
                }
                {
                  name  : "big"
                  count : 1
                  price : 100
                }
                {
                  name  : "big cheap"
                  count : 11
                  price : 10
                }
              ]
              Table {
                data
                col_list
                sort : true
              }
              """#"
          td
            col_list = [
              {
                key   : "name"
                title : "Name"
              }
              {
                key   : "count"
                title : "Quantity"
              }
              {
                key   : "price"
                title : "Price"
              }
            ]
            data = [
              {
                name  : "small"
                count : 10
                price : 0.1
              }
              {
                name  : "big"
                count : 1
                price : 100
              }
              {
                name  : "big cheap"
                count : 11
                price : 10
              }
            ]
            Table {
              data
              col_list
              sort : true
            }
        # ###################################################################################################
        tr
          td
            Textarea_coffee_script value:"""
              col_list = [
                {
                  key   : "name"
                  title : "Name"
                }
                {
                  key   : "count"
                  title : "Quantity"
                }
                {
                  key   : "price"
                  title : "Price"
                }
              ]
              data = [
                {
                  name  : "small"
                  count : 10
                  price : 0.1
                }
                {
                  name  : "big"
                  count : 1
                  price : 100
                }
                {
                  name  : "big cheap"
                  count : 11
                  price : 10
                }
              ]
              Table {
                data
                col_list
                filter : true
              }
              """#"
          td
            col_list = [
              {
                key   : "name"
                title : "Name"
              }
              {
                key   : "count"
                title : "Quantity"
              }
              {
                key   : "price"
                title : "Price"
              }
            ]
            data = [
              {
                name  : "small"
                count : 10
                price : 0.1
              }
              {
                name  : "big"
                count : 1
                price : 100
              }
              {
                name  : "big cheap"
                count : 11
                price : 10
              }
            ]
            Table {
              data
              col_list
              filter : true
            }