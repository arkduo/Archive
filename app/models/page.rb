class Page < ActiveRecord::Base
  mount_uploader :page_image, PageImageUploader
end
