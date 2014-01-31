module ProjectsHelper
	
	def display_time(time)
		if time.nil?
			return "Has not run"
		else
			return time_ago_in_words(time) + " ago"
		end
	end
	
	def total_dev_issues(project)
		dev_issues = project.commits.where("issue LIKE ?","QBE%")
		total = 0
		grouped = dev_issues.group_by { |commit| commit.issue }
		grouped.each do |issue, grouping|
			total += 1
		end
		return total
	end

end
