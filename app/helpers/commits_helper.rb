module CommitsHelper
	
	def create_jira_link(commit)
		if commit.issue.nil?
			#no link to create
		else
			#we have something to link
			return raw("<a href=\"#{Rixeye::Application.config.jira_url}#{commit.issue}\">#{commit.issue}</a></li>")
		end
	end
	
	def create_fisheye_link(commit,project)
		return raw("<a href=\"#{Rixeye::Application.config.fisheye_url}/#{project.name}?cs=#{commit.revision_number}\">#{commit.revision_number}</a></li>")
	end
	
	def find_paths(commit)
		paths = Path.where(:commits_id => commit.id)
		return paths.count.to_s
	end
		
end
