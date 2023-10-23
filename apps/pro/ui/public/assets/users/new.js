(function() {

  jQuery(function($) {
    return $(function() {
      var $availZones, $stdZones, jan, jul, minutes, year, zone, zoneStr;
      year = new Date().getFullYear();
      jan = new Date(year, 0, 1);
      jul = new Date(year, 6, 1);
      zone = -Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset()) / 60.0;
      zoneStr = '' + Math.abs(zone);
      if (Math.abs(zone) < 10) {
        zoneStr = '0' + zoneStr;
      }
      if (zone < 0) {
        zoneStr = '-' + zoneStr;
      }
      if (zone > 0) {
        zoneStr = '+' + zoneStr;
      }
      minutes = parseInt(Math.abs(parseInt(Math.abs(zone)) - Math.abs(zone)) * 60);
      if (minutes < 10) {
        zoneStr += ':' + '0' + minutes;
      }
      if (minutes > 9) {
        zoneStr += ':' + minutes;
      }
      $availZones = $("#user_time_zone option:contains('" + zoneStr + "')");
      if ($availZones.length > 0) {
        $("#user_time_zone option:selected").removeAttr('selected');
        $stdZones = $("#user_time_zone option:contains('" + zoneStr + "'):contains('Time')");
        if ($stdZones.length > 0) {
          return $stdZones.first().attr('selected', 'selected');
        } else {
          return $availZones.first().attr('selected', 'selected');
        }
      }
    });
  });

}).call(this);
