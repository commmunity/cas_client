module CasClient
  
  class Request
    
    include CasClient::Logger
    
    MAX_REDIRECTIONS = 5 unless const_defined?(:MAX_REDIRECTIONS)
    
    attr_reader :params
    attr_reader :provider
    attr_reader :service_url
    
    def initialize(service_url, params = {}, provider = ServiceProvider::Base.new)
      self.service_url = service_url
      @params = params.with_indifferent_access
      @provider = provider
      raise CasClient::Error.new("Max redirections: #{MAX_REDIRECTIONS}") if redirection_count > MAX_REDIRECTIONS
    end
    
    # Available options are: :renew (default: false)
    def login_url(options = {})
      returning(provider.login_url) do |url|
        service = service_url.dup
        service.query << '&' if service.query
        service.query = "#{service.query}redirection_count=#{redirection_count + 1}"
        url.query = "service=#{CGI.escape(service.to_s)}"
        url.query << '&renew=true' if options[:renew]
      end
    end
    
    def logout_url(destination = nil)
      returning(provider.logout_url) do |url|
        url.query = "destination=#{CGI.escape(destination)}" unless destination.blank?
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
      request.set_form_data(:service => service_url, :ticket => ticket)
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
    
    def redirection_count
      params[:redirection_count].to_i
    end
    
    def service_url=(url)
      @service_url = url.is_a?(URI) ? url : URI.parse(url)
    rescue => e
      raise CasClient::Error.new(e)
    end
    
  end
  
end