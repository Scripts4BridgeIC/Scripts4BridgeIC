require 'csv'
require 'json'
require 'net/http'
#------------------Replace these values-----------------------------#

# Replace this with the your instance specific authentication token
access_token = "ZDA3ZjNhMGQtMDRjMy00NjE4LThiNWItZjNlMGM0YzFlMDRjOmEzY2M0MDk1LTFhMGYtNGM0Yi1hMDhkLTJhY2E5NzlhMDNjZg=="

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
bridge_domain = 'mistrasbridge'

# Path to the CSV file containing the learner UserID and CourseID
csv_file = '/Users/swasilewski/Desktop/Bridge/Customers/Mistras/historical/realFinalBatch/compilationFINALBatch.csv'

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

   if row['enrollment_id'] == "\#N/A"
     url = URI("#{base_url}/course_templates/#{row["course_id"]}/enrollments")
     http = Net::HTTP.new(url.host, url.port)
     http.use_ssl = true

     request = Net::HTTP::Post.new(url)
     request["authorization"] = "Basic #{access_token}"
     request["content-type"] = 'application/json'
     request["cache-control"] = 'no-cache'

     # Specify which user to add to the course
     payload = {"enrollments" => ["user_id"=>"#{row["user_id"]}","score"=>"#{row['score']}","completed_at"=>"#{row['completed']}"]}

     # Convert payload to JSON
     request.body = payload.to_json

     response = http.request(request)
     unless response.code == "204"
       errors << "#{payload}-----#{response.code}-----#{row["Course_ID"]}"
     end

     #optional text for those who like to know what's happening
     puts "Enrollment has been updated for user #{row['user_id']} in course #{row['course_id']}"
     puts "#{payload}\n#{response.code}"
     puts url
   else
     url = URI("#{base_url}/enrollments/#{row['enrollment_id']}")

     http = Net::HTTP.new(url.host, url.port)
     http.use_ssl = true

     request = Net::HTTP::Patch.new(url)
     request["authorization"] = "Basic #{access_token}"
     request["content-type"] = 'application/json'
     request["cache-control"] = 'no-cache'

     # Specify which user variables to adjust
     payload = {"enrollments" => ["completed_at"=>"#{row['completed']}","score"=>"#{row['score']}"]}

     # Convert payload to JSON
     request.body = payload.to_json

     response = http.request(request)
     unless response.code == "200"
       errors << "Enrollment #{row['enrollment_id']} returned a status code of #{response.code}\n#{payload}"
     end

     #optional text for those who like to know what's happening
     #puts "Enrollment has been updated for user #{row['user_id']} in course #{row['course_id']}"
     puts "#{row['enrollment_id']} ----------- #{payload}\n#{response.code}"
   end
end
puts "------------------------------------------------------------------Finishing"

# Display any items that did not return the correct response code
puts errors
puts "number of errors: #{errors.length}"
puts 'Program finished. You should probably take care of all those errors!'
