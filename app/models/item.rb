class Item < ActiveRecord::Base
  attr_accessible :comment, :issue, :whitelist_id
  belongs_to :whitelist
  
  before_validation :verify_project_key
  
  def verify_project_key
  	match_found = false
  	Rixeye::Application.config.rixeye_settings['Jira_Project_List'].each do |project_key|
  		if self.issue.match(/#{project_key}-\d+/)
  			match_found = true
  		end
  	end
  	if !match_found
  		errors[:base] << "Issue does not have a valid project key.  Please use one of the following " + Rixeye::Application.config.rixeye_settings['Jira_Project_List'].join(", ")
  		return false
  	end
  end
  
end
