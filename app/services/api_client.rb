

class ApiClient
  def self.get(endpoint)
    JSON.parse(Net::HTTP.get(URI("#{base_url}#{endpoint}")))
  end

  private

  def base_url
    raise NotImplementedError, "Subclasses must implement the base_url method"
  end
end
