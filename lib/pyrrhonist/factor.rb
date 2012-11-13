require 'set'

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
      @table = []
    end
    
    # define the variables and their values
    def define(*variables)
      if variables
        reset
        value_assignments = yield

        build_table_from_variables_and_values variables, value_assignments       
      end
    end
    
    def variables
      @variables
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
    
    def unique_variables_from_factors(other_factor)
      all_variables = Set.new
      
      get_names = lambda do |variable|
        all_variables.add variable.name
      end
      
      @variables.each &get_names
      other_factor.variables.each &get_names
      
      all_variables.to_a
    end
    
    def ordered_values_from_hash(hash_of_assignments)
      @variables.map do |variable|
        hash_of_assignments[variable.name]
      end
    end
    
    def build_table_from_variables_and_values(variables, values)
      hash_of_assignments = hash_of_assignments_from_values_table variables, values
      build_variable_instances variables, hash_of_assignments

      apply_all_values_to_table values
    end
    
    def hash_of_assignments_from_values_table(variables, values)
      hash_of_assignments = {}
      values.keys.each do |assignments|
        assignments.each_with_index do |assignment, index|
          (hash_of_assignments[variables[index]] ||= Set.new).add(assignment)
        end
      end
      hash_of_assignments
    end
    
    def build_variable_instances(variables, hash_of_assignments)
      @variables = variables.each_with_index.map do |variable, index|
        variable_instance = Variable.new(variable)
        variable_instance.assignments = hash_of_assignments[variable].to_a
        variable_instance
      end
    end
    
    def apply_all_values_to_table(values)
      each_assignment do |assignment, index|
        @table[index] = values[assignment]
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