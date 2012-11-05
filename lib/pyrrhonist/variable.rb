
module Pyrrhonist
  
  class Variable
    
    def initialize(name)
      @name = name
    end
    
    def name
      @name
    end
    
    def values=(values)
      if values.class != Hash
        raise ArgumentError, "#{values} should be a Hash of values that #{@name} can take"
      end
      @values = values
    end
    
    def cardinality
      @values.length
    end
    
    # retrieve the unconditional probability of the given assignment for this Variable. 
    def value_of(assignment)
      
      unless @values.key? assignment
        raise ArgumentError, "#{assignment} is not a assignment that #{@name} can take"
      end
      
      return @values[assignment]
      
    end
    
    def assignment_for_index(index)
      @values.keys[index]
    end
    
    def index_for_assignment(assignment)
      index = @values.keys.index(assignment)
      unless index
        raise ArgumentError, "#{assignment} is not a well defined assignment array"
      end
      index
    end
    
  end
  
end