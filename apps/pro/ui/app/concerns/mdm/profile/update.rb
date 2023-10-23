module Mdm::Profile::Update
  # Public: Returns true if an update check should be run, false otherwise.
  def check_for_update?
    (profile.settings["update_last_checked"].nil? ||
        profile.settings["update_last_checked"] < 6.hours.ago ||
        profile.settings["update_last_checked"] > profile.updated_at)
  end

	# TODO: This should be in its own column, not stored on settings.
	def update_available?
		settings['update_available']
	end
end