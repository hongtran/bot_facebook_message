require 'sinatra'
require 'json'
require 'http'

get '/' do
  if params["hub.verify_token"] == "devfest-token"
    params["hub.challenge"]
  else  
    "Hello world!"
  end  
end

post '/' do
  data = request.body.read
  json = JSON.parse(data)
  puts JSON.pretty_generate(json)
  json['entry'].each do |entry|
    entry['messaging'].each do |message|
      text = message['message']['text']
      user_id = message['sender']['id']
      send_message(user_id, "hey, you said : #{text}")
      #puts user_id + ": " + text
    end  
  end  
  'ok'
end

def send_message(user_id, text)
  url = "https://graph/facebook.com/v2.6/me/messages?access_token=" + ENV['PAGE_ACCESS_TOKEN']
  data = {
    recipient: {id: user_id},
    message: {text: text}
  }
  HTTP.post(url, json: data)
end