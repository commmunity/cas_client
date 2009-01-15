module CasClient
  
  class Request
    
    attr_reader :provider
    attr_reader :service_url
    attr_reader :ticket
    
    def initialize(service_url, params = {}, provider = ServiceProvider::Base.new)
      @provider = provider
      @service_url = service_url
      @ticket = params['ticket']
    end
    
    def login_url
      url = provider.login_url
      url.query = "service=#{CGI.escape(service_url)}"
      url
    end
    
    def logout_url
      provider.logout_url
    end
    
    def ticket?
      !ticket.nil?
    end
    
    # TODO SSL
    def validate(options = { :timeout => 10 })
      url = provider.validate_url
      # Building request
      request = Net::HTTP::Post.new(url.path)
      request.set_form_data(:service => service_url, :ticket => ticket)
      # Building connection
      cnx = Net::HTTP.new(url.host, url.port)
      cnx.open_timeout = options[:timeout]
      # Starting connection
      cnx.start do |http|
        http.request(request) do |response|
          response.value # raise if not success
          return CasClient::Response::Base.parse(response.body)
        end
      end
    rescue => e
      raise CasClient::Error.new(e, url)
    end
    
  end
  
end