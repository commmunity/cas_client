module CasClient
  
  class Request
    
    include CasClient::Logger
    
    class << self
      
      def validable?(params)
        params['ticket'].present?
      end
      
    end
    
    attr_reader :params
    attr_reader :provider
    attr_reader :service_url
        
    def initialize(service_url, params = {}, provider = ServiceProvider::Base.new)
      self.service_url = service_url
      @params = params.with_indifferent_access
      @provider = provider
    end
    
    def edit_profile_url(params = {})
      provider.url_for(:edit_profile, params.reverse_merge(:service => service_url))
    end
    
    def login_url(params = {})
      provider.url_for(:login, params.reverse_merge(:service => service_url))
    end

    def logout_url(params = {})
      provider.url_for(:logout, params)
    end

    def signup_url(params = {})
      provider.url_for(:signup, params.reverse_merge(:service => service_url))
    end
    
    def ticket
      params[:ticket]
    end
    
    def validate(options = { :timeout => 15 })
      defined?(CasServer::Rack::Api::ServiceValidate) ? validate_with_rack : validate_with_http(options)
    rescue Timeout::Error, StandardError => e
      raise CasClient::Error.new(e)
    end
    
    private
    
    def service_url=(url)
      @service_url = url.is_a?(URI) ? url : URI.parse(url)
      @service_url.fragment = nil
      if @service_url.query.present?
        @service_url.query.gsub!(/[\&]?ticket=[^\&]*\&?/, '')
        @service_url.query = nil if @service_url.query.empty?
      end
    rescue => e
      raise CasClient::Error.new(e)
    end
    
    def validate_with_http(options)
      url = provider.url_for(:validate)

      logger.debug("[CAS] Posting request to: #{url}")
      logger.debug("[CAS] Service URL: #{service_url}")
      logger.debug("[CAS] Ticket: #{ticket}")

      # Building request
      request = Net::HTTP::Post.new(url.path)
      request.set_form_data(:service => service_url.to_s, :ticket => ticket)

      # Building connection
      cnx = Net::HTTP.new(url.host, url.port)
      cnx.open_timeout = options[:timeout]
      cnx.read_timeout = options[:timeout]

      # SSL configuration
      if url.scheme == 'https'
        cnx.use_ssl = true
        cnx.verify_mode = OpenSSL::SSL::VERIFY_NONE # TODO we MUST later verify SSL certificate!
        cnx.verify_depth = 5
      end

      # Starting connection
      cnx.start do |http|
        http.request(request) do |response|
          response.value # raise if not success
          return CasClient::Response::Base.parse(response.body)
        end
      end
    end
    
    def validate_with_rack(options = {})
      url = provider.url_for(:validate, :service => service_url.to_s, :ticket => ticket)
      body = Rack::MockRequest.new(CasServer::Rack::Api::ServiceValidate.new).get(url.to_s).body
      CasClient::Response::Base.parse(body)
    end
    
  end
  
end