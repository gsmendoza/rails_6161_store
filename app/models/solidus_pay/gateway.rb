module SolidusPay
  class Gateway
    API_URL = 'https://soliduspay.com/api/v1'

    attr_reader :api_key

    def initialize(options)
      @api_key = options.fetch(:api_key)
    end

    def authorize(money, auth_token, options = {})
      response = request(
        :post,
        "/charges",
        payload_for_charge(money, auth_token, options).merge(capture: false),
      )

      if response.success?
        ActiveMerchant::Billing::Response.new(
          true,
          "Transaction Authorized",
          {},
          authorization: response.parsed_response['id'],
        )
      else
        ActiveMerchant::Billing::Response.new(
          false,
          response.parsed_response['error'],
        )
      end
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

    def payload_for_charge(money, auth_token, options = {})
      {
        auth_token: auth_token,
        amount: money,
        currency: options[:currency],
        description: "Payment #{options[:order_id]}",
        billing_address: options[:billing_address],
      }
    end
  end
end
