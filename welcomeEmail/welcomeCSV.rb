#------------------Replace these values-----------------------------#

access_token = 'token' # place your basic token between '' marks
bridge_domain = 'domain' # place your Bridge domain between '' marks
csv_file = '/location/output.csv' # file path to CSV containing learner session ID and user ID

#-------------------Do not edit below this line---------------------#

#gem install unirest
#gem install json

require 'csv'
require 'unirest'
require 'rubygems'
require 'json'

unless File.exists?(csv_file)
    raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end


errors = Array.new
CSV.foreach(csv_file,headers:true) do |row|
  response = Unirest.post("https://#{bridge_domain}.bridgeapp.com/api/author/notifications/#{row['bridge_id']}/welcome", headers:{ 'Authorization' => 'Basic '+access_token,'Content-Type' => 'application/json', 'Accept' => 'application/json' })

  puts "#{row['bridge_id']} and the response code #{response.code.to_s}"
  unless response.code.to_s == "204"
    errors << row['bridge_id']
  end

end

puts "\n---------------------------------------------------------------------------------------------\n"
puts "Successfully sent welcome some emails to users"
puts errors
puts "number of errors: #{errors.length}"
puts 'Program finished. You should probably take care of all those errors!'
