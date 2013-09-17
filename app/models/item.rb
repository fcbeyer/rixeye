class Item < ActiveRecord::Base
  attr_accessible :comment, :issue, :whitelist_id
  belongs_to :whitelist
end
