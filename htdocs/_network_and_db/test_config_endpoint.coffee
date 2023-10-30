###
# enable when needed

@test_config_number =
  get : ()->if localStorage.value? then +localStorage.value else 0
  set : (value)->localStorage.value = value if value?

@test_config_number_or_null =
  get : ()->if localStorage.value? then +localStorage.value else null
  set : (value)->localStorage.value = value if value?

@test_config_string =
  get : ()->localStorage.value ? ""
  set : (value)->localStorage.value = value if value?

@test_config_string_or_null =
  get : ()->if localStorage.value? then localStorage.value else null
  set : (value)->localStorage.value = value if value?

@test_config_json =
  get : ()->if localStorage.value? then JSON.parse(localStorage.value) else {}
  set : (value)->localStorage.value = JSON.stringify(value) if value?

@test_config_json_or_null =
  get : ()->if localStorage.value? then JSON.parse(localStorage.value) else null
  set : (value)->localStorage.value = JSON.stringify(value) if value?

###
