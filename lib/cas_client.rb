require 'rubygems'
require 'active_support'
require 'net/http'
require 'net/https'
require 'open-uri'
require 'cgi'
require 'nokogiri'

lib_path = File.dirname(__FILE__) + '/cas_client'

require "#{lib_path}/error"
require "#{lib_path}/logger"
require "#{lib_path}/response/base"
require "#{lib_path}/response/failure"
require "#{lib_path}/response/profile"
require "#{lib_path}/response/success"
require "#{lib_path}/service_provider/base"
require "#{lib_path}/request"