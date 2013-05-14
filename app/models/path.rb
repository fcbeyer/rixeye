class Path < ActiveRecord::Base
  attr_accessible :action, :commits_id, :file, :kind
  
  belongs_to :commit
end
