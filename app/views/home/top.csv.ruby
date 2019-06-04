require 'csv'
 
CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv_column_names = ["名前","電話番号","備考","URL"]
  csv << csv_column_names
  @shops.each do |shop|
    csv_column_values = [
      shop.name,
      shop.phone_number,
      shop.address,
    ]
    shop.links.each do |link|
      csv_column_values  << link.url
    end
    csv << csv_column_values
  end
end