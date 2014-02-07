# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rixeye::Application.initialize!

Rixeye::Application.configure do
	 config.rixeye_settings = YAML::load(File.open('./config/settings.yml'))["#{ENV['RAILS_ENV']}"]
end