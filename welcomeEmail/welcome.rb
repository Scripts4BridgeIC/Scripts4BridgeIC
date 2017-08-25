#------------------Replace these values-----------------------------#
$access_token = 'token' 
$bridge_domain = 'domain' 
$csv_file = '/location/welcome.csv' 

#-------------------Do not edit below this line---------------------#

require 'csv'
require 'unirest'
require 'rubygems'
require 'json'
require 'httparty'
require 'highline/import'

unless $csv_file
  puts "What should I name your CSV file?\b"
  $csv_file = gets.chomp
end

puts 'retrieving user_ids from '+$bridge_domain
puts 'exporting user_ids to ' +$csv_file+'.csv'


class Get_User_ID

  headers = {'Authorization' => 'Basic '+$access_token, 'Content-Type' => 'application/json', 'Accept' =>
      'application/json'}

  $usr_url = 'https://'+$bridge_domain+'.bridgeapp.com/api/author/users?limit=500'
  $welcome_url = 'https://'+$bridge_domain+'.bridgeapp.com/api/author/notifications/'

  response = HTTParty.get($usr_url, :headers => headers)
  json = JSON.parse(response.body)['users']


  json.each do |x|
    CSV.open($csv_file+'.csv', "ab") do |csv|
      csv << [x['id']]
    end
  end

end


class Welcome_Invitation

  errors = Array.new
  CSV.foreach($csv_file+'.csv') do |row|
    response = Unirest.post("https://#{$bridge_domain}.bridgeapp.com/api/author/notifications/#{row[0]}/welcome", headers:{ 'Authorization' => 'Basic '+$access_token,'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    puts response.code
    unless response.code == "204"
      errors << row[0]
    end
  end

  puts "\n---------------------------------------------------------------------------------------------\n"
  puts "Successfully sent welcome some emails to users"
  puts errors
  puts "number of errors: #{errors.length}"
  puts 'Program finished. You should probably take care of all those errors!'

end
