require 'csv'
grants = [] # create grants array

# define a method to search for duplicates
# search for grant number in grants array
def grant_search(grants, grant_number)
  # set up location = nil
  return if grant_number == nil
  duplicate_index = nil

  # search grant hash in the array and if find the duplicate, then set up index # location
  grants.each_with_index do |grant, i|
    if grant[:grant_number] == grant_number
      duplicate_index = i
      break
    end
  end
  duplicate_index
end

# read CSV file: Loop to read each row
CSV.foreach('grants.csv', headers:true) do |row|

  grant_number = row[1]

  # remove nil
  if grant_number == nil
    next
  end

  # call the method and store the index # to variable named index.
  index = grant_search(grants, grant_number)

  # if duplicate # exist, then add the vesting hash (grants, dates).
  if index
    # create the vesting variable (vest date and shares)
    vesting = {vest_date: row[2], shares: row[3]}
    # Find the grant to update using the index # in array. This accesses the GRANT HASH in the array.
    grant_to_update = grants[index]
    # Add vesting variable to the vesting hash in the GRANT HASH
    grant_to_update[:vestings] << vesting

  else

    #if duplicate doesn't exists, then create a GRANT HASH in the array
    grant = {
      account_id: row[0],
      grant_number: grant_number,
      vestings:[
        {vest_date: row[2], shares: row[3]}
      ]
    }
    # add grant hash to grants array
    grants << grant
  end

end

# declare rows array
rows = []

# Declare vesting_count = 0
vesting_count = 0

# Create header for first two columns
rows << ["account id", "grant number"]

# loop to grab acct id and # from grant hash in the grants array.
grants.each do |grant|
  # grant account id and grant number from the grant hash and assign to variable "row"
  row = [
    grant[:account_id], grant[:grant_number]
  ]

  # Then if vesting count in each grant # is greater than vesting_count, assign count to vesting_count
  if grant[:vestings].count > vesting_count
    vesting_count = grant[:vestings].count
  end

  # loop to access vesting (shares and vest date) in each grant hash
  grant[:vestings].each do |vesting|
    row << vesting[:vest_date]
    row << vesting[:shares]
  end

  # add above row variable to the rows array
  rows << row
  end

# count the vesting_count
vesting_count.times do
  rows[0] << "vesting date"
  rows[0] << "vesting shares"
end

# create CSV output file.
CSV.open("Output.csv", "w") do |csv|
  # for each rows array change eto CSV.
  rows.each do |row|
    csv << row
  end
end
