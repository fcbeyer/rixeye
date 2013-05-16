module ProjectsHelper
	
	def parse_message(message)
		msg = Hash['issue',"",'complete',message]
		match = message.match(/DEV-\d+/)
		msg['issue'] = match[0] unless match.nil?
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
