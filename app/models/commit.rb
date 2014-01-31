class Commit < ActiveRecord::Base
  attr_accessible :author, :committed_at, :issue, :message, :revision_number, :project_id
  
  has_many :paths, :dependent => :destroy	
  
  belongs_to :project
  
  paginates_per 35
  
  def self.parse_xml(logentries,cur_project)
  	logentries.each do |entry|
		  msg = Commit.parse_message_text(entry.xpath('./msg').text)
  		revision_number = entry.attribute('revision')
  		cur_revision = Commit.new({:project_id => cur_project.id,:issue => msg['issue'],:revision_number => revision_number.to_s,:committed_at => Time.iso8601(entry.xpath('./date').text),
  															:author => entry.xpath('./author').text,:message => msg['complete']})
  		cur_revision.save
  		Path.parse_xml(entry.xpath('./paths/path'),cur_revision)
  	end
  end
  
  def self.parse_message_text(message)
		msg = Hash['issue',"",'complete',message]
    Rixeye::Application.config.rixeye_settings['Project_Ket_list'].each do |key|
      match = message.match(/#{key}\d+/)
      if !match.nil?
        msg['issue'] = match[0]
        return msg
      end
    end
    return msg
	end
	 
end