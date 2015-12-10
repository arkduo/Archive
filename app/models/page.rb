class Page < ActiveRecord::Base
  mount_uploader :pict, PictUploader
end
