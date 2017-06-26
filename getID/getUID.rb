# Script to get user id and bridge id in the same csv
# gems to include make sure you have installed these on your computer
# you can verify by going to terminal on your computer and typing in
# gem install <gemname>

require 'csv'
require 'json'
require 'net/http'

# Replace this with the your instance specific authentication token
access_token = "access token"

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
bridge_domain = 'waz'

# Path to the CSV file containing the user ID
csv_file = '/location/users.csv'
# Path to the CSV file you would like as the output
csv_file_out = '/location/usersOutput.csv'

# If file doesn't exist bail out
unless File.exists?(csv_file)
    raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end

# This script only deals with author api endpoints.
base_url = "https://#{bridge_domain}.bridgeapp.com/api/author"

# Starting marker cause sometimes I forget to clear my console before starting scripts
puts "------------------------------------------------------------------Starting"
#csv_file_out = csv_file.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
CSV.open(csv_file_out, "wb") do |csv_out|
  CSV.foreach(csv_file, headers:true) do |row|
    url = URI("#{base_url}/users/#{row['userid']}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["authorization"] = "Basic #{access_token}"
    request["content-type"] = 'application/json'
    request["cache-control"] = 'no-cache'
    response = http.request(request)

    unless response.code == "200"
      puts "#{row.to_s}-----------------------------error #{response.code}"
      next
    end

    json = JSON.parse(response.body)
    
    puts "UserID: #{row['userid']} Unique Identifier: #{json["users"][0]["uid"]}"

    csv_out << [row['userid'],json["users"][0]["uid"].to_s]

  end
end
