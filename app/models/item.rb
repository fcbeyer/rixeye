class Item < ActiveRecord::Base
  attr_accessible :comment, :issue, :whitelist_id, :reporter
  belongs_to :whitelist
  
  before_validation :verify_project_key, :verify_issue_uniqueness
  
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
  
  def verify_issue_uniqueness
  	#for now, make sure this Jira Issue does not already exist on the whitelist (it really should be at all, but that is a simple change later)
	allItems = Whitelist.find(self.whitelist_id).items
	allItems.delete_if{|item| item.id == self.id}
	allItems.each do |cur_item|
  		if (cur_item.issue).eql?(self.issue)
  			errors[:base] << "This Jira issue is already present on the whitelist!"
  			return false
  		end
  	end
  end
  
end
