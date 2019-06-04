class ApplicationController < ActionController::Base
    require 'nokogiri'
    require 'open-uri'

    add_flash_types :success, :info, :warning, :danger
    
end
