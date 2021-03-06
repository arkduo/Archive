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
    @page = Page.where(book_id: params[:id])
    @serial = Serial.find_by(id: @book.serial_id)
  end

  def thumb
    @book = Book.find(params[:id])
    @page = Page.where(book_id: params[:id])
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
      if @book.save_zip
        format.html { redirect_to thumb_book_path(@book), notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def regist_thumb
    # サムネイルの登録
    @thumb = Page.find_by(id: params[:thumb])
    @book = Book.find_by(id: @thumb.book_id)
    @book.thumb = @thumb.pict.thumb.url
    @book.save

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
