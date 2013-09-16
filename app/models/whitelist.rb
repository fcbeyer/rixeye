class Whitelist < ActiveRecord::Base
  attr_accessible :project_id, :num_items, :branch_name
  
  belongs_to :project
end
