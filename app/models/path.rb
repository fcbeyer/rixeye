class Path < ActiveRecord::Base
  attr_accessible :action, :commits_id, :file, :kind
  
  belongs_to :commit
  
  def self.parse_xml(paths,cur_revision)
  	paths.each do |path|
  		kind = path.attribute('kind')
  		action = path.attribute('action')
			cur_path = Path.new({:commits_id => cur_revision.id,:kind => kind.to_s,:action => action.to_s,:file => path.text})
			cur_path.save
		end
 	end
 	
end
