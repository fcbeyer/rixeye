module CommitsHelper
	
	def create_issue_tracker_link(commit)
		if commit.issue.nil?
			#no link to create
		else
			#we have something to link
			return raw("<a href=\"#{Rixeye::Application.config.rixeye_settings['Issue_Tracker_Url']}#{commit.issue}\">#{commit.issue}</a></li>")
		end
	end
	
	def create_code_diff_link(commit,project)
	  #TODO: FIX DIFF LINK IT CURRENTLY IS BROKEN WHAT IS THE BEST WAY TO DO THIS?
		return raw("<a href=\"#{Rixeye::Application.config.rixeye_settings['Code_Diff_URL']}/#{project.name}?cs=#{commit.revision_number}\">#{commit.revision_number}</a></li>")
	end
	
	def find_paths(commit)
		paths = Path.where(:commits_id => commit.id)
		return paths.count.to_s
	end
		
end
