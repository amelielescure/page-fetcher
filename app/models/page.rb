class Page < ActiveRecord::Base
	validates :page_id, presence: true
end
