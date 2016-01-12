class Page < ActiveRecord::Base
  belongs_to :book
  mount_uploader :pict, PictUploader
end
