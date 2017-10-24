#=============

require 'csv'
require 'typhoeus'
require 'HTTParty'

#==========================Replace these values========================#

# Either provide values at prompt, or provide values between '' marks and remove nil.

# API Token provided by IC or Bridge Support. Token value only! Do not include 'Basic'
access_token = 'token'

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
bridge_domain = 'domain'

# Path to the CSV file containing the session ID and Bridge user ID.
csv_file = 'info.csv'

# Administrator ID
admin_id = 'bridgeId'

#---------------------Do not edit below this line unless you know what you're doing-------------------#

unless File.exists?(csv_file)
  raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end



CSV.foreach(csv_file, {:headers => true}) do |row|

  base_url = "https://#{bridge_domain}.bridgeapp.com/api/author"
  puts base_url

  req_due = Typhoeus.post("#{base_url}/live_course_sessions/#{row['session']}/registrations?as_user_id=#{admin_id}",
                          params: { 'user_id' => row['UserID'] },
                          headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{access_token}"}
  )
  puts req_due.body
  puts req_due.code
  puts "User ID, #{row['UserID']}, has been enrolled into ILT session, #{row['session']}"
end

puts 'Successfully created ILT courses.'
