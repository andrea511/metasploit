jQuery(function($) {

var hosts_count = parseInt($('meta[name="msp:hosts_count"]').attr('content'));
var hosts_path = $('meta[name="msp:hosts_path"]').attr('content');
var host_states = JSON.parse($('meta[name="msp:host_states"]').attr('content'));

var host_oses = JSON.parse($('meta[name="msp:host_oses"]').attr('content'))
var os_search_url = $('meta[name="msp:os_search_url"]').attr('content');

var host_services = JSON.parse($('meta[name="msp:host_services"]').attr('content'))
var service_search_url = $('meta[name="msp:service_search_url"]').attr('content');

var events_axis = JSON.parse($('meta[name="msp:events_axis"]').attr('content'))
var events_timeline = JSON.parse($('meta[name="msp:events_timeline"]').attr('content'))

var r;

if (hosts_count > 0) {
	r = Raphael(document.getElementById("host_chart"), 400, 100);
	r.g.piechart(50, 50, 50, _.values(host_states), {
		legend: _.map(host_states, function(num, state) { return num + " - " + state }),
		legendpos: "east",
		href: _.map(host_states, function() { return hosts_path })
	});
} else {
	document.getElementById("host_chart").innerHTML = "No host data";
}

if (_.size(host_oses) !== 0) {
	r = Raphael(document.getElementById("os_chart"), 400, 100);
	r.g.piechart(50, 50, 50, _.values(host_oses),{
		legend: _.map(host_oses, function(num, os) { return num + " - " + os }),
		href: _.map(host_oses, function(num, os) { return os_search_url + encodeURIComponent(os) }),
		legendpos: "east"
	});
} else {
	document.getElementById("os_chart").innerHTML = "No operating system data";
}

if (_.size(host_services) !== 0) {
	r = Raphael(document.getElementById("service_chart"), 400, 100);
	r.g.piechart(50, 50, 50, _.values(host_services), {
		legend: _.map(host_services, function(num, service) { return num + " - " + service }),
		href: _.map(host_services, function(num, service) { return service_search_url + service.split(/\s/)[0] }),
		legendpos: "east"
	});
} else {
	document.getElementById("service_chart").innerHTML = "No service data";
}

r = Raphael(document.getElementById("activity_chart"), 400, 140);
var act_x = events_axis;
var act_y = events_timeline;
r.g.linechart(0, 0, 400, 100, act_x, act_y, {nostroke: false, axis: "0 0 0 0", smooth: true});

});

