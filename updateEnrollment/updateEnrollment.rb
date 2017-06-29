# Script to update user enrollments based on CSV
# file. Currently set to update completion date and score but you can update
# other attributes as well as per
# https://docs.bridgeapp.com/doc/api/html/author_enrollments.html

# gems to include make sure you have installed these on your computer
# you can verify by going to terminal on your computer and typing in
# gem install <gemname>
require 'csv'
require 'json'
require 'net/http'

# Replace this with the your instance specific authentication token
access_token = "MGMzMzY0NjQtNDM2Ni00MzFkLTliNTQtNTA1N2NkNjE4NTFiOjdjY2I3YzlhLTJjNDUtNDZkYS05OThjLWMwZDNjMjM5Zjc5Mg=="

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
bridge_domain = 'waz'

# Path to the CSV file containing the learner enrollment ID, score, and completion date.
csv_file = '/Users/swasilewski/Desktop/Bridge/RubyScripts/wazEnrollmentTest/users.csv'

#---------------------Do not edit below this line unless you know what you're doing-------------------#

# If file doesn't exist bail out
unless File.exists?(csv_file)
    raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end

# This script only deals with author api endpoints.
base_url = "https://#{bridge_domain}.bridgeapp.com/api/author"

# Starting marker cause sometimes I forget to clear my console before starting scripts
puts "------------------------------------------------------------------Starting"


# Loop through each row is CSV file, search for enrollment and update that enrollment
CSV.foreach(csv_file, headers:true) do |row|

  url = URI("#{base_url}/enrollments/#{row['enrollmentID']}")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  request = Net::HTTP::Patch.new(url)
  request["authorization"] = "Basic #{access_token}"
  request["content-type"] = 'application/json'
  request["cache-control"] = 'no-cache'

  # Added this because formatting of CSV for the school this script was written for
  # was a bit... wonky so I just clipped out the bad bits rather than reformating the csv manually
  stringDate = row['completed']
  stringDate.slice! "+AC0"
  stringDate.slice! "+AC0"

  # Create payload for API call
  payload = {"enrollments" => ["completed_at" => stringDate,"score" => row['score']]}
  request.body = payload.to_json
  # Send request and log the response
  response = http.request(request)

  puts payload
  puts url

  # If call has an error, report it back in terminal and move on to the next row
  unless response.code == "200"
    puts "#{row.to_s}-----------------------------error #{response.code}"
  end
end

# Some markers so I know when I'm done.
puts "------------------------------------------------------------------Hopefully done"
puts "------------------------------------------------------------------check for errors"
