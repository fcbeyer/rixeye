require 'nokogiri'

def parse_message(message)
	msg = Hash['issue',"",'complete',message]
	match = message.match(/DEV-\d+/)
	msg['issue'] = match[0] unless match.nil?
	return msg
end

ENV['RAILS_ENV'] = "production" # Set to your desired Rails environment name
require_relative './rixeye/config/environment.rb'

# After this point you have access to your models and other classes from your Rails application

project_list = Project.where(:autopoll => true)
project_list.each do |project|
	rev_from = project.last_revision.nil? ? project.base_revision : project.last_revision + 1
	log_file = project.name + ".xml"
	rev_to = "HEAD"
	response = system "svn log --verbose --username build --password build #{project.url_path} -r#{rev_from}:#{rev_to} --xml > #{log_file}"
	doc = Nokogiri::XML(File.open(log_file))
	if !doc.css('log logentry').empty?
		doc.css('log logentry').each do |entry|
			msg = parse_message(entry.css('msg').text)
			cur_revision = Commit.new
			cur_revision.project_id = project.id
			cur_revision.issue = msg['issue']
			temp = entry.attribute('revision')
			cur_revision.revision_number = temp.to_s
			cur_revision.committed_at = Time.iso8601(entry.css('date').text)
			cur_revision.author = entry.css('author').text
			cur_revision.message = msg['complete']
			cur_revision.save
			entry.css('paths path').each do |path|
				cur_path = Path.new
				cur_path.commits_id = cur_revision.id
				temp = path.attribute('kind')
				cur_path.kind = temp.to_s
				temp = path.attribute('action')
				cur_path.action = temp.to_s
				cur_path.file = path.text
				cur_path.save
			end
		end	
		#update project.last_revision to the last one we found just now
		temp = doc.css('log logentry').last.attribute('revision')
		project.last_revision = temp.to_s
	end
	project.last_run_time = Time.now
	project.save
end