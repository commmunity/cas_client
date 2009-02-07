module CasClient
  
  class Request
    
    include CasClient::Logger
    
    attr_reader :params
    attr_reader :provider
    attr_reader :service_url
    
    def initialize(service_url, params = {}, provider = ServiceProvider::Base.new)
      self.service_url = service_url
      @params = params.with_indifferent_access
      @provider = provider
    end
    
    def login_url(params = {})
      url = provider.login_url
      query = params.merge(:service => service_url.to_s).map do |name, value|
        "#{name}=#{CGI.escape(value.to_s)}"
      end.join('&')
      url.query = query if query.present?
      url
    end
    
    # Available options are: destination
    def logout_url(options = {})
      returning(provider.logout_url) do |url|
        url.query = "destination=#{CGI.escape(options[:destination])}" if options[:destination].present?
      end
    end
    
    def ticket
      params[:ticket]
    end
    
    def validable?
      !ticket.nil?
    end
    
    # TODO SSL
    def validate(options = { :timeout => 5 })
      url = provider.validate_url
      logger.debug("[CAS] Posting request to: #{url}")
      logger.debug("[CAS] Ticket: #{ticket}")
      # Building request
      request = Net::HTTP::Post.new(url.path)
      request.set_form_data(:service => service_url.to_s, :ticket => ticket)
      # Building connection
      cnx = Net::HTTP.new(url.host, url.port)
      cnx.open_timeout = options[:timeout]
      cnx.read_timeout = options[:timeout]
      # Starting connection
      cnx.start do |http|
        http.request(request) do |response|
          response.value # raise if not success
          return CasClient::Response::Base.parse(response.body)
        end
      end
    rescue Timeout::Error, StandardError => e
      raise CasClient::Error.new(e, url)
    end
    
    private
    
    def service_url=(url)
      @service_url = url.is_a?(URI) ? url : URI.parse(url)
    rescue => e
      raise CasClient::Error.new(e)
    end
    
  end
  
end