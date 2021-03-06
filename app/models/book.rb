class Book < ActiveRecord::Base
  has_many :pages
  mount_uploader :zip, ZipUploader

  def save_zip
    num = 0
    pages = []
    ran = SecureRandom.hex(2)

    unzip_file(ran).each do |file|
      file = file.chomp
      img = Magick::Image.read(file).first
      if img.columns > img.rows # 横長の場合:２分割
        name = img.filename.rpartition('.')
        # 右ページ
        p_right = img.crop(Magick::SouthEastGravity, img.columns / 2, img.rows).write(name.first + '_1.' + name.last).filename
        # 左ページ
        p_left = img.crop(Magick::NorthWestGravity, img.columns / 2, img.rows).write(name.first + '_2.' + name.last).filename
        self.pages.new(pict: File.open(p_right))
        self.pages.new(pict: File.open(p_left))
        num += 2
      else
        f = File.open(file)
        self.pages.new(pict: f)
        num += 1
      end
    end
    `rm -rf #{Rails.root}/decomp/#{ran}`
    self.total = num
    save
  end

  private

  # アップロードされたファイルの解凍
  def unzip_file(ran)
    # 一時的に解凍しておくフォルダの生成
    `mkdir #{Rails.root}/decomp/#{ran}`
    if /zip$/ =~ zip.path
      # ZIPファイルの解凍
      `unzip -jo "#{zip.path}" -d #{Rails.root}/decomp/#{ran}`
    else
      # RARファイルの解凍
      `unrar e -y "#{zip.path}" #{Rails.root}/decomp/#{ran}`
    end
    path = `find #{Rails.root}/decomp/#{ran} -type f -iname "*.jpg" -or -type f -iname "*.png" | sort -n`
    path.split
  end
end
