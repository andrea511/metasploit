
jQuery(document).ready(function ($) {
	var fn = function() {
		$.ajax({
			url: '/updates/status',
			type: 'GET',
			success: function(data, textStatus, jqXHR) {
				$('#update_status').html(data);
			},
			complete: function() {
				if ($('#update_status .btn').length == 0) { setTimeout(fn, 3000); }
			}
		});
	};
	setTimeout(fn, 3000);
});
