module Admin::UsersHelper
	def licensed_users_remaining
		user_limit - Mdm::User.count
	end

	def user_limit
		License.get.users
	end

	def user_limit_reached?
		Mdm::User.count >= user_limit
	end

	def user_workspace_list(workspaces, limit = 5)
		if workspaces.empty?
			""
		elsif workspaces.size == Mdm::Workspace.count
			"All"
		elsif workspaces.size <= limit
			workspaces.map(&:name).join(", ")
		else
			n_more = workspaces.size - limit
			workspaces.map(&:name)[0,limit].join(", ") + ", and #{n_more} more"
		end
	end
end
