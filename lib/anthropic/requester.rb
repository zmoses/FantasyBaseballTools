require 'net/http'
require 'json'
require 'uri'

module Anthropic
  class Requester
    def self.example
      uri = URI('https://api.anthropic.com/v1/messages')

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request['x-api-key'] = Rails.application.credentials.claude_key
      request['anthropic-version'] = '2023-06-01'

      request.body = JSON.generate({
        model: 'claude-opus-4-6',
        max_tokens: 1000,
        messages: [
          {
            role: 'user',
            content: 'What should I search for to find the latest developments in renewable energy?'
          }
        ]
      })

      response = http.request(request)
      puts JSON.parse(response.body)
    end
  end
end
