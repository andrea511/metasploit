jQuery ($) ->
  $ ->
    # Figure out user's timezone information and preselect it in formtastic
    # standardize timezone offset
    year = new Date().getFullYear()
    jan = new Date(year, 0, 1)
    jul = new Date(year, 6, 1)
    zone = -Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset())/60.0
    # formtastic's <select> elements for timezone look like:
    #   <option value="Midway Island">(GMT-11:00) Midway Island</option>
    # try to match the "(GMT-11:00)" portion to the current timezone offset
    zoneStr = ''+Math.abs(zone)
    zoneStr = '0'+zoneStr if Math.abs(zone) < 10
    zoneStr = '-'+zoneStr if zone < 0
    zoneStr = '+'+zoneStr if zone > 0
    minutes = parseInt(Math.abs(parseInt(Math.abs(zone)) - Math.abs(zone))*60)
    zoneStr += ':'+'0'+minutes if minutes < 10
    zoneStr += ':'+minutes if minutes > 9
    
    $availZones = $("#user_time_zone option:contains('"+zoneStr+"')")
    if $availZones.length > 0
      $("#user_time_zone option:selected").removeAttr('selected')
      # Check for "standard" (name contains 'Time') timezones first
      $stdZones = $("#user_time_zone option:contains('"+zoneStr+"'):contains('Time')")
      if $stdZones.length > 0
        $stdZones.first().attr('selected', 'selected')
      else
        # otherwise default to last 
        $availZones.first().attr('selected', 'selected')