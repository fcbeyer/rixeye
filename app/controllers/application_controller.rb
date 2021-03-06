class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :get_nav_bar_data
	
	def get_nav_bar_data
		@project_list = Project.active
		@whitelist_list = Whitelist.all
		@whitelist_list.sort! { |a,b| a.project_id <=> b.project_id}
	end
end
