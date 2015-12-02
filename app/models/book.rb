class Book < ActiveRecord::Base
  mount_uploader :zip, ZipUploader
end
