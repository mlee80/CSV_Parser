require 'csv'
grants = [] # create array

def grant_search(grants, grant_number)
  return if grant_number == nil
  duplicate_index = nil

  grants.each_with_index do |grant, i|
    if grant[:grant_number] == grant_number
      duplicate_index = i
      break
    end
  end

  duplicate_index

end

# loop
CSV.foreach('grants.csv', headers:true) do |row|
  grant_number = row[1]

  # remove nil
  if grant_number == nil
    next
  end

  index = grant_search(grants, grant_number)

  if index
    vesting = {vest_date: row[2], shares: row[3]}
    grant_to_update = grants[index]
    grant_to_update[:vestings] << vesting

  else

    grant = {
      account_id: row[0],
      grant_number: grant_number,
      vestings:[
        {vest_date: row[2], shares: row[3]}
      ]
    }


    grants << grant

  end

end


CSV.open("Output.csv", "w") do |csv|
  csv << ["account id", "grant number"]
  grants.each do |grant|
    row = [
      grant[:account_id], grant[:grant_number]
    ]


    grant[:vestings].each do |vesting|
      row << vesting[:vest_date]
      row << vesting[:shares]
    end

    csv << row


  end


end
