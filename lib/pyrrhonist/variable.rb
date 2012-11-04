
module Pyrrhonist
  
  class Variable
    
    def initialize(name)
      @name = name
    end
    
    def values=(values)
      if values.class != Hash
        raise ArgumentError, "#{values} should be a Hash of values that #{@name} can take"
      end
      @values = values
    end
    
    # retrieve the unconditional probability of the given value for this Variable. 
    def value_of(value)
      
      if not @values.key? value
        raise ArgumentError, "#{value} is not a value that #{@name} can take"
      end
      
      return @values[value]
      
    end
    
    
    
  end
  
end