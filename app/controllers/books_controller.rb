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
    @num = Book.find(params[:id]).total
    @page = Page.where(:book_id => params[:id])
  end

  def thumb
    @book = Book.find(params[:id])
    @page = Page.where(:book_id => params[:id])
  end

  # GET /books/new
  def new
    @book = Book.new
    @page = Page.new
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
    system('mkdir /home/adminer/muse/decomp')
    # ZIPファイルの解凍
    `unzip -jo "#{@book.zip.path}" -d /home/adminer/muse/decomp`
    path = `find /home/adminer/muse/decomp -type f -name "*.jpg" | sort -n`
    arr = path.split
    arr.sort_by do |f|
      f.scan(/[\d]+/).last
    end
    # 解凍したファイルをPageテーブルに保存
    num = 0
    arr.each do |file|
      @page = Page.new(:book_id => @book.id)
      file = file.chomp

      # 見開き2ページの場合は2分割
      img = Magick::Image.read(file).first
      if(img.columns > img.rows) # 横長の場合:２分割
        name = img.filename.rpartition(".")
        parts = Array.new()
        parts << img.crop(Magick::SouthEastGravity, img.columns/2, img.rows).write(name.first + "_1." + name.last) # 左ページ
        parts << img.crop(Magick::NorthWestGravity, img.columns/2, img.rows).write(name.first + "_2." + name.last) # 右ページ
        
        parts.each do |part|
          File.open(part.filename) do |f|
            num += 1
            @page.page_name = part
            @page.page_image = f
          end
          @page.save
        end
      else # 縦長の場合:そのまま登録
        File.open(file) do |f|
          num += 1
          @page.page_name = file
          @page.page_image = f
        end
        @page.save
      end
    end
    # `rm -rf /home/adminer/muse/decomp`
    @book.total = num
    @book.save
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
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:name, :genre, :zip, :zip_cache)
    end

    #def page_params
    #  params.require(:page).permit(:bookid => :id, :pageid => 1, :page_image => :image)
    #end
end
