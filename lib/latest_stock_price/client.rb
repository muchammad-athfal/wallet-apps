require 'net/http'
require 'json'

module LatestStockPrice
  class Client
    BASE_URL = 'https://latest-stock-price.p.rapidapi.com'
    API_KEY = Rails.application.credentials.rapid_api_key

    def initialize(api_key = API_KEY)
      @api_key = api_key
    end

    def price(stock_symbol)
      make_request('/price', { symbol: stock_symbol })
    end

    def prices(stock_symbols)
      make_request('/prices', { symbols: stock_symbols.join(',') })
    end

    def price_all
      make_request('/price_all')
    end

    private

    def make_request(endpoint, params = {})
      uri = URI("#{BASE_URL}#{endpoint}")
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP::Get.new(uri)
      request['X-RapidAPI-Key'] = @api_key

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
      JSON.parse(response.body)
    end
  end
end
