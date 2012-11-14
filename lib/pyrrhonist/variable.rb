
module Pyrrhonist
  
  class Variable
    
    attr_accessor :name, :assignments
    
    def initialize(name, assignments)
      self.name = name
      self.assignments = assignments
    end
    
    def cardinality
      self.assignments.length
    end
    
    def assignment_for_index(index)
      self.assignments[index]
    end
    
    def index_for_assignment(assignment)
      index = self.assignments.index(assignment)
      unless index
        raise ArgumentError, "#{assignment} is not a well defined assignment; must be one of #{self.assignments}"
      end
      index
    end
   
   def hash
     self.assignments.inject(self.name.hash) do |hash, assignment|
       hash + assignment.hash
     end
   end
   
   def eql?(other_variable)
     self==other_variable
   end
   
   def ==(other_variable)
     if other_variable.nil? or other_variable.class != Variable
       false
     else
       self.name == other_variable.name and self.assignments == other_variable.assignments
     end
   end
    
  end
  
end