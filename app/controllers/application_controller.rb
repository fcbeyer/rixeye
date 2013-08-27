class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :get_project_list
	
	def get_project_list
		@project_list = Project.active
	end
end
