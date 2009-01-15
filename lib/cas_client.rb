require 'rubygems'
require 'active_support'
require 'net/http'
require 'open-uri'
require 'cgi'
require 'nokogiri'
require 'cas_client/error'
require 'cas_client/response/base'
require 'cas_client/response/failure'
require 'cas_client/response/profile'
require 'cas_client/response/success'
require 'cas_client/service_provider/base'
require 'cas_client/request'