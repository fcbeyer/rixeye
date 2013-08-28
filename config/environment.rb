# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rixeye::Application.initialize!

Rixeye::Application.configure do
	 config.rixeye_settings = YAML::load(File.open('./config/settings.yml'))["#{ENV['RAILS_ENV']}"]
	 # config.svn_user = settings['svn_user']
	 # config.svn_password = settings['svn_password']
	 # config.git_user = settings['git_user']
	 # config.git_password = settings['git_password']
	 # config.jira_url = settings['jira_url']
	 # config.jira_project_list = settings['jira_project_list']
	 # config.fisheye_url = settings['fisheye_url']
end