require "net/http"

class ApiClient
  def self.get(url)
    JSON.parse(Net::HTTP.get(URI("#{url}")))
  end
end
