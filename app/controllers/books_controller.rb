class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @page = Page.where(:book_id => params[:id])
    @serial = Serial.find_by(:id => @book.serial_id)
  end

  def thumb
    @book = Book.find(params[:id])
    @page = Page.where(:book_id => params[:id])
  end

  # GET /books/new
  def new
    @book = Book.new
    @page = Page.new
    @series = params[:id]
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        #format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.html { redirect_to thumb_book_path(@book), notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end

    # アップロードされたファイルの解凍
    # 一時的に解凍しておくフォルダの生成
    `mkdir #{Dir.home}/muse/decomp`
    if /zip$/ =~ @book.zip.path
      # ZIPファイルの解凍
      `unzip -jo "#{@book.zip.path}" -d #{Dir.home}/muse/decomp`
    else
      # RARファイルの解凍
      `unrar e -y "#{@book.zip.path}" #{Dir.home}/muse/decomp`
    end
    path = `find #{Dir.home}/muse/decomp -type f -iname "*.jpg" -or -type f -iname "*.png" | sort -n`
    arr = path.split
    arr.sort_by do |f|
      f.scan(/[\d]+/).last
    end
    # 解凍したファイルをPageテーブルに保存
    num = 0
    arr.each do |file|
      file = file.chomp

      # 見開き2ページの場合は2分割
      img = Magick::Image.read(file).first
      if(img.columns > img.rows) # 横長の場合:２分割
        name = img.filename.rpartition(".")
        parts = Array.new()
        parts << img.crop(Magick::SouthEastGravity, img.columns/2, img.rows).write(name.first + "_1." + name.last) # 右ページ
        parts << img.crop(Magick::NorthWestGravity, img.columns/2, img.rows).write(name.first + "_2." + name.last) # 左ページ
        
        parts.each do |part|
          @page = Page.new(:book_id => @book.id)
          File.open(part.filename) do |f|
            num += 1
            @page.pict = f
          end
          @page.save
        end
      else # 縦長の場合:そのまま登録
        @page = Page.new(:book_id => @book.id)
        File.open(file) do |f|
          num += 1
          @page.pict = f
        end
        @page.save
      end
    end
    `rm -rf #{Dir.home}/muse/decomp`
    @book.total = num
    @book.save
  end

  def regist_thumb
    # サムネイルの登録
    @thumb = Page.find_by(:id => params[:thumb])
    @book = Book.find_by(:id => @thumb.book_id)
    @book.thumb = @thumb.pict.thumb.url
    @book.save

#    # シリーズ用サムネの作成
#    # 4枚の画像から1枚のサムネを作る
#    urls = Array.new
#    count = 0
#    @img = Book.where(:serial_id => @book.serial_id)
#    @img.each do |t|
#      urls << "#{Dir.home}/muse/public" + t.thumb
#      count += 1
#    end
#    # サムネが4枚分無い=>黒画像で代用
#    while count < 4
#      urls << "#{Dir.home}/muse/app/assets/images/thumb_black.jpg"
#      count += 1
#    end
#
#    images = Magick::ImageList.new(*urls)
#    tile = Magick::ImageList.new
#    page = Magick::Rectangle.new(0,0,0,0)
#    images.scene = 0
#
#    2.times do |i|
#      2.times do |j|
#        tile << images.scale(0.7)
#        page.x = j * tile.columns
#        page.y = i * tile.rows
#        tile.page = page
#        (images.scene += 1) rescue images.scene = 0
#      end
#    end
#
#    `mkdir #{Dir.home}/muse/public/uploads/serial/#{@book.serial_id}`
#    @serial = Serial.find_by(:id => @book.serial_id)
#    @serial.thumb = tile.mosaic.write("#{Dir.home}/muse/public/uploads/serial/#{@book.serial_id}/thumb.jpg")
#    @serial.save

    # シリーズ用サムネ
    # 最新のBookのサムネを流用
    @serial = Serial.find_by(:id => @book.serial_id)
    @serial.thumb = @book.thumb
    # 巻数の更新
    @serial.volume = @serial.volume.to_i + 1
    @serial.save

    redirect_to ({:action => 'show', :id => params[:id]}), :notice => 'Thumbnail was successfully registed.'
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
      #@page.update(:bookid => @book.id, :pageid => 1, :page_image => @book.image)
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @page = Page.where(:book_id => params[:id]).destroy_all
    series = @book.serial_id
    @book.destroy
    respond_to do |format|
      format.html { redirect_to serials_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
    # シリーズ用サムネの更新
    @serial = Serial.find_by(:id => series)
    @serial.volume -= 1
    if Book.where(:serial_id => series).last
      @serial.thumb = Book.where(:serial_id => series).last.thumb
    end
    @serial.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:serial_id, :title, :genre, :zip, :zip_cache)
    end

    #def page_params
    #  params.require(:page).permit(:bookid => :id, :pageid => 1, :page_image => :image)
    #end
end
