class Avatar < ActiveRecord::Base

	belongs_to :obj, :polymorphic => true

	has_attachment :content_type => :image,
		:storage => :file_system,
		:max_size => 5.megabytes,
		:resize_to => '320x200>',
		:thumbnails => { :thumb => '100x100>', :small => '50x50>' },
		:processor => :rmagick

	validates_as_attachment 

end
