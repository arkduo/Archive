json.array!(@serials) do |serial|
  json.extract! serial, :id, :series, :regist_at
  json.url serial_url(serial, format: :json)
end
