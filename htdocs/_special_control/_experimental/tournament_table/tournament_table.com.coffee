module.exports =
  render : ()->
    $col_list = [
      td ''
    ]
    match_result_flip = (t)->
      res = clone t
      
      tmp = res.bot1
      res.bot1 = res.bot2
      res.bot2 = tmp
      
      res.result = -res.result
      
      return res
    for bot in @props.bot_list
      match_result = []
      for match in @props.match_list
        if match.bot1 == bot.name
          match_result.push match
        else if match.bot2 == bot.name
          match_result.push match_result_flip match
      bot.__match_result = match_result
      score = 0
      for match in match_result
        score++ if match.result > 0
      bot.__score = score
    
    # if @props.sort
    bot_list = @props.bot_list.clone()
    bot_list.sort (a,b)->-(a.__score-b.__score)
    
    for bot in bot_list
      $col_list.push td {class : "tournament_table_bot_header"}, bot.name
    
    $col_list.push td {class : "tournament_table_bot_header"}, "score"
    
    
    $row_list = []
    for bot1 in bot_list
      $row_list.push tr =>
        td {class : "tournament_table_bot_header"}, bot1.name
        for bot2 in bot_list
          if bot2 == bot1
            td {class : "tournament_table_same_bot"}
            continue
          win  = 0
          lose = 0
          draw = 0
          for match in bot2.__match_result
            continue if match.bot2 != bot1.name
            win++  if match.result < 0
            lose++ if match.result > 0
            draw++ if match.result == 0
          add_class = ""
          diff = win-lose
          add_class = "tournament_table_win" if diff > 0
          add_class = "tournament_table_lose" if diff < 0
          add_class = "tournament_table_big_win" if diff > 3
          add_class = "tournament_table_big_lose" if diff < -3
          
          td {class : "tournament_table_result "+add_class}, "#{win}:#{lose}:#{draw}"
        
        td {class : "tournament_table_score"}, bot1.__score
    # LATER @props.match_list
    div
      table {class:"tournament_table"}
        tbody
          tr $col_list
          return $row_list
  