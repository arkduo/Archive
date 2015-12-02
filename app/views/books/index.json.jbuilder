json.array!(@books) do |book|
  json.extract! book, :id, :name, :genre, :regist_at
  json.url book_url(book, format: :json)
end
