
module Pyrrhonist
  

  # Heavily borrowed from the logic that defines Factors in the PGM class programming assignments.
  class Factor
    
    def initialize
      reset
    end
    
    #
    #
    #
    def reset
      @variables = []
      @variable_names = []
      @table = []
    end
    
    # Given a set of Variables, build a naive table Factor that assumes
    # even distribution of assignments (ie P(A) == P(A | B) for all A,B).
    #   
    # use #set_assignment to override specific assignments
    #
    #
    def variables=(variables)
      reset
      variables.each do |variable|
        if variable.class != Variable
          raise ArgumentError, "#{variable.class} is not of the class Variable"
        end
      end
      @variables = variables
      build_table_from_variables
    end

    #
    # +assignment+:: an array assignment to every Variable in the Factor in
    # order of assignment to the Factor.
    #
    def value_of(hash_of_assignments)
      assignment = ordered_values_from_hash(hash_of_assignments)
      @table[assignment_to_index(assignment)]
    end
    
    def marginalize(variable)
      
    end

    def assign(value, hash_of_assignments)
      assignment = ordered_values_from_hash(hash_of_assignments)
      @table[assignment_to_index(assignment)] = value
    end
    
    def each_assignment
      table_size.times do |index|
        assignment = index_to_assignment(index)
        yield(assignment, index)
      end
    end
    
    private
    
    def ordered_values_from_hash(hash_of_assignments)
      ordered = []
      @variables.each_index do |index|
        variable = @variables[index]
        ordered[index] = hash_of_assignments[variable.name]
      end
      ordered
    end
    
    def build_table_from_variables
      each_assignment do |assignment, index|       
        variable_iterator = @variables.each
        value = assignment.inject(1) do |value, assignment|
          value * (variable_iterator.next.value_of assignment)
        end
        @table[index] = value
      end
    end
    
    def table_size
      @variables.inject(1) do |table_size, variable|
        table_size * variable.cardinality
      end
    end
    
    def assignment_to_index(assignment)
      product = 1
      assignment_iterator = assignment.each
      @variables.inject(0) do |factor_index, variable|
        index = variable.index_for_assignment(assignment_iterator.next)
        variable_index = index*product
        product *= variable.cardinality
        factor_index + variable_index
      end
      
    end
    
    def index_to_assignment(internal_index)
      product = 1
      @variables.collect do |variable|
        variable_index = (internal_index / product) % variable.cardinality
        product *= variable.cardinality
        variable.assignment_for_index(variable_index)
      end
    end
    
  end
  
end