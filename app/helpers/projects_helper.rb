module ProjectsHelper
	
	def parse_message(message)
		msg = Hash['issue',"",'complete',message]
		msg['issue'] = $1 if (message =~ /(DEV-[1-9][0-9]*)/)
		return msg
	end
	
end
