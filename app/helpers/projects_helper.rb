module ProjectsHelper
	
	def parse_message(message)
		msg = Hash['issue',"",'complete',message]
		msg['issue'] = $1 if (message =~ /(DEV-[1-9][0-9]*)/)
		return msg
	end
	
	def display_time(time)
		if time.nil?
			return "Has not run"
		else
			return time_ago_in_words(time) + " ago"
		end
	end
	
end
