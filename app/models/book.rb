class Book < ActiveRecord::Base
  has_many :pages
  mount_uploader :zip, ZipUploader
end
