module SolidusPay
  class Gateway
    API_URL = 'https://soliduspay.com/api/v1'

    attr_reader :api_key

    def initialize(options)
      @api_key = options.fetch(:api_key)
    end

    private

    def request(method, uri, body = {})
      HTTParty.send(
        method,
        "#{API_URL}#{uri}",
        headers: {
          "Authorization" => "Bearer #{api_key}",
          "Content-Type" => "application/json",
          "Accept" => "application/json",
        },
        body: body.to_json,
      )
    end
  end
end
