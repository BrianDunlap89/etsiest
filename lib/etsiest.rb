require 'etsy'
require 'pry'
require 'sinatra/base'

require 'etsiest/version'

Etsy.api_key = ENV["ETSY_KEY"]

module Etsiest
  class App < Sinatra::Base

    get "/search" do
    results = Etsy::Request.get("/listings/active", :includes => ["Images", "Shop"], 
                               :keywords => "whiskey")
    results = results.result
    results_num = results.count
    @results_data = []
      results.each do |result|
        result = {
                   title: result["title"],
                   price: result["price"],
                   image: result["Images"][0]["url_fullxfull"],
                   currency_code: result["currency_code"],
                   vendor: result["Shop"]["shop_name"]
                 }
        @results_data.push(result)
      end
    erb :index, locals: { results: @results_data, results_num: results_num }
    end

    run! if app_file == $0 

  end
end
