document.observe("dom:loaded", function() {

	if ($('user_admin')) {
		//
		// Disable & check all Project Access checkboxes when Administrator is selected
		//
		var set_project_access_state = function() {
			var user_admin = $('user_admin');
			var project_access_checkboxes = $$('#workspaces input[type=checkbox]');
			if (user_admin.checked) {
				project_access_checkboxes.each(function(e) {
					e.checked = true;
					e.disable();
				});
			} else {
				project_access_checkboxes.each(function(e) {
					// check if the current user is the owner of the project before setting disabled property
					if (e.getAttribute('is_owner') == 'true') {
						e.checked = true;
						e.disable();
					} else {
						e.enable();
					}
				});
			}
		};
		set_project_access_state();

		$('user_admin').observe('click', set_project_access_state);
	};
	
});
