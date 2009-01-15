module CasClient
  
  module Response
    
    class Profile
      
      def initialize(values)
        @values = values.with_indifferent_access
      end
      
      def [](key)
        @values[key.to_sym]
      end
      
    end
    
  end
  
end