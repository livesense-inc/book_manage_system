class TopController < ApplicationController
    require 'net/http'
    require 'uri'
    require 'json'
    require 'logger'
    def index
    end
    
    def confirm
	url = URI.parse('https://api.openbd.jp/v1/get?isbn=9784063879179')
	p url
	json = Net::HTTP.get(url)
	book_info = JSON.parse(json) 
	
    end
end
