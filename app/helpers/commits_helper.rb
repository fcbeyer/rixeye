module CommitsHelper
	
	def create_jira_link(commit)
		if commit.issue.nil?
			#no link to create
		else
			#we have something to link
			return raw("<a href=\"#{@jira_url}#{commit.issue}\">#{commit.issue}</a></li>")
		end
	end
	
	def create_fisheye_link(commit,project)
		return raw("<a href=\"#{@fisheye_url}/#{project.name}?cs=#{commit.revision_number}\">#{commit.revision_number}</a></li>")
	end
		
end
