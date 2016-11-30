require 'csv'
grants = [] # create array


# print each row
CSV.foreach('grants2.csv', headers:true) do |row|
  grant = {
    account_id: row[0],
    grant_number: row[1],
    vestings:[
      {vest_date: row[2], shares: row[3]}
    ]
  }

grants << grant


end

puts grants
