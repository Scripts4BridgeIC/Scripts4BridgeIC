# Script to get a CSV File of notifications for users specified.
# gems to include make sure you have installed these on your computer
# you can verify by going to terminal on your computer and typing in
# gem install <gemname>

require 'csv'
require 'json'
require 'net/http'

# Replace this with the your instance specific authentication token
access_token = "token"

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
bridge_domain = 'domain'

# Path to the CSV file containing the user ID
csv_file = '/location/x.csv'
# Path to the CSV file you would like as the output
csv_file_out = '/location/Notifications.csv'

# If file doesn't exist bail out
unless File.exists?(csv_file)
    raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end

# This script only deals with author api endpoints.
base_url = "https://#{bridge_domain}.bridgeapp.com/api/author"

errors = Array.new

# Starting marker cause sometimes I forget to clear my console before starting scripts
puts "------------------------------------------------------------------Starting"
CSV.open(csv_file_out, "wb") do |csv_out|
  csv_out << ["user_id","notification_id","recipient","subject","sent_at"]
  CSV.foreach(csv_file, headers:true) do |row|

    url = URI("#{base_url}/users/#{row['id']}/notifications")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["authorization"] = "Basic #{access_token}"
    request["content-type"] = 'application/json'
    request["cache-control"] = 'no-cache'
    response = http.request(request)

    puts url
    puts response.code

    unless response.code == "200"
      puts "#{row.to_s}-----------------------------error #{response.code}"
      next
    end

    json = JSON.parse(response.body)

    json["notifications"].each_with_index do |arrayEnroll,i|
      puts "NotificationsID: #{json["notifications"][i]["id"]} Recipient: #{json["notifications"][i]["recipient"]} Subject: #{json["notifications"][i]["subject"]} Sent_at: #{json["notifications"][i]["sent_at"]}"
      csv_out << [row["id"],json["notifications"][i]["id"].to_s,json["notifications"][i]["recipient"].to_s, json["notifications"][i]["subject"].to_s,json["notifications"][i]["sent_at"].to_s]
    end

  end
end

puts errors
puts "number of errors: #{errors.length}"
