require 'csv'
grants = [] # create array

def grant_search(grants, grant_number)
  return if grant_number == nil
  duplicate_found = false

  grants.each do |grant|
    if grant[:grant_number] == grant_number
      duplicate_found = true
      break
    end
  end

  if duplicate_found
    p "duplicate"
  else
    p "not duplicate"
  end

end

# print each row
CSV.foreach('grants.csv', headers:true) do |row|
  grant_number = row[1]
grant_search(grants, grant_number)


  grant = {
    account_id: row[0],
    grant_number: grant_number,
    vestings:[
      {vest_date: row[2], shares: row[3]}
    ]
  }

grants << grant


end

## puts grants
