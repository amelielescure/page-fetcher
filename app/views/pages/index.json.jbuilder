json.array!(@pages) do |page|
  json.extract! page, :id, :page_id
  json.url page_url(page, format: :json)
end
