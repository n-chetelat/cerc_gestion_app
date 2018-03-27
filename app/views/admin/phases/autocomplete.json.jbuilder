json.array!(@list) do |item|
  json.id item.id
  json.text item.title
end
