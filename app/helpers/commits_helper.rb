module CommitsHelper
	
	def create_jira_link(commit)
		if commit.issue.nil?
			#no link to create
		else
			#we have something to link
			return raw("<a href=\"#{@jira_url}#{commit.issue}\">#{commit.issue}</a></li>")
		end
	end
		
end
