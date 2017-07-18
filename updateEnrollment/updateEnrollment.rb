# Script to adjust user enrollments to a course based on a CSV
# file. Currently set to grades and completion dates.
# Other attributes can be added as well, as per
# https://docs.bridgeapp.com/doc/api/html/author_enrollments.html

# gems to include make sure you have installed these on your computer
# you can verify by going to terminal on your computer and typing in
# gem install <gemname>

require 'csv'
require 'json'
require 'net/http'
#------------------Replace these values-----------------------------#

# Replace this with the your instance specific authentication token
access_token = "token"

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
bridge_domain = 'domain'

# Path to the CSV file containing the learner UserID and CourseID
csv_file = '/Location/file.csv'

# Verify that the file exists
unless File.exists?(csv_file)
    raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end

# Sets the base URL used in our API calls
base_url = "https://#{bridge_domain}.bridgeapp.com/api/author"

# Array to track and report errors
errors = Array.new

puts "------------------------------------------------------------------Starting"

# Loop through each row in CSV file and create users
CSV.foreach(csv_file, {:headers => true}) do |row|
    url = URI("#{base_url}/enrollments/#{row['enrollmentID']}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Patch.new(url)
    request["authorization"] = "Basic #{access_token}"
    request["content-type"] = 'application/json'
    request["cache-control"] = 'no-cache'

    # Specify which user variables to adjust
    payload = {"enrollments" => ["score"=>"#{row['score']}","completed_at"=>"#{row['date']}"]}

    # Convert payload to JSON
    request.body = payload.to_json

    response = http.request(request)
    unless response.code == "200"
      errors << "#{payload}\n#{response.code}"
    end

    #optional text for those who like to know what's happening
    #puts "Enrollment has been updated for user #{row['user_id']} in course #{row['course_id']}"
    puts "#{payload}\n#{response.code}"
end
puts "------------------------------------------------------------------Finishing"

# Display any items that did not return the correct response code
puts errors
puts "number of errors: #{errors.length}"
puts 'Program finished. You should probably take care of all those errors!'
