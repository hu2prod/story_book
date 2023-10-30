module.exports = 
  render : ()->
    tab_list = [
      {
        title   : 'Default'
        content : Xbar {
          value : 50
          max : 100
        }
      }
      {
        title   : 'mp'
        content : Xbar_mp {
          value : 50
          max : 100
        }
      }
      {
        title   : 'chan (channeling)'
        content : Xbar_chan {
          value : 50
          max : 100
        }
      }
      {
        title   : 'stun (control)'
        content : Xbar_stun {
          value : 50
          max : 100
        }
      }
      {
        title   : 'xp'
        content : Xbar_xp {
          value : 50
          max : 100
        }
      }
    ]
    Tab_view {
      tab_list
      store_key : @name
      all : true
    }
  