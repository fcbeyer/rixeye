class Whitelist < ActiveRecord::Base
  attr_accessible :project_id, :num_items, :branch_name, :items_attributes
  has_many :items, :dependent => :destroy
  belongs_to :project
  
  
  def self.create_from_project(project_id,branch_name)
  	whitelist = Whitelist.new(:project_id => project_id,:branch_name => branch_name+" Whitelist")
  	whitelist.save
  end
end
