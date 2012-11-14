require 'set'

module Pyrrhonist
  

  # Heavily borrowed from the logic that defines Factors in the PGM class programming assignments.
  class Factor
    
    attr_accessor :variables, :table
    
    def initialize
      reset
    end
    
    #
    #
    #
    def reset
      self.variables = []
      self.table = []
    end
    
    # define the variables and their values
    def define(*variables)
      if variables
        reset
        value_assignments = yield

        build_table_from_variables_and_values variables, value_assignments       
      end
    end
    
    #
    # +assignment+:: an array assignment to every Variable in the Factor in
    # order of assignment to the Factor.
    #
    def value_of(hash_of_assignments)
      assignment = ordered_values_from_hash(hash_of_assignments)
      self.table[assignment_to_index(assignment)]
    end
    
    #
    # +other_factor+:: another Pyrrhonist::Factor
    #
    def *(other_factor)
      all_variables_in_product = unique_variables_from_factors(other_factor)
      
      product_factor = Factor.new
      product_factor.variables = all_variables_in_product

      # calculate local indices for both factors
      my_relative_indices = self.relative_indices_from_all_product_variables all_variables_in_product
      other_factor_relative_incides = other_factor.relative_indices_from_all_product_variables all_variables_in_product

      product_factor.each_assignment do |assignment, index|
        product_factor.table[index] = value_from_product_assignment(my_relative_indices, assignment) *
          other_factor.value_from_product_assignment(other_factor_relative_incides, assignment)
      end
      
      product_factor
    end
    
    def marginalize(variable_name)
      
    end

    def assign(value, hash_of_assignments)
      assignment = ordered_values_from_hash(hash_of_assignments)
      self.table[assignment_to_index(assignment)] = value
    end
    
    def each_assignment
      table_size.times do |index|
        assignment = index_to_assignment(index)
        yield(assignment, index)
      end
    end
    
    def relative_indices_from_all_product_variables(all_variables_in_product)
      my_relative_indices = []
      self.variables.each_with_index do |my_variable, my_index|
        all_variables_in_product.each_with_index do |product_variable, product_index|
          if product_variable == my_variable
            my_relative_indices.push(product_index)
          end
        end
      end
      my_relative_indices
    end
    
    def value_from_product_assignment(my_indices, product_assignment)
      my_assignment = my_indices.map do |my_index|
        product_assignment[my_index]
      end
      self.table[assignment_to_index(my_assignment)]
    end
    
    def unique_variables_from_factors(other_factor)
      all_variables = Set.new
      
      all_variables.merge self.variables
      all_variables.merge other_factor.variables
      
      all_variables.to_a
    end
    
    def ordered_values_from_hash(hash_of_assignments)
      self.variables.map do |variable|
        hash_of_assignments[variable.name]
      end
    end
    
    def build_table_from_variables_and_values(variables, values)
      hash_of_assignments = hash_of_assignments_from_values_table(variables, values)
      build_variable_instances(variables, hash_of_assignments)

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
      self.variables = variables.each_with_index.map do |variable, index|
        Variable.new(variable, hash_of_assignments[variable].to_a)
      end
    end
    
    def apply_all_values_to_table(values)
      each_assignment do |assignment, index|
        self.table[index] = values[assignment]
      end      
    end
    
    def table_size
      self.variables.inject(1) do |table_size, variable|
        table_size * variable.cardinality
      end
    end
    
    def assignment_to_index(assignment)
      product = 1
      assignment_iterator = assignment.each
      self.variables.inject(0) do |factor_index, variable|
        index = variable.index_for_assignment(assignment_iterator.next)
        variable_index = index*product
        product *= variable.cardinality
        factor_index + variable_index
      end
      
    end
    
    def index_to_assignment(internal_index)
      product = 1
      self.variables.collect do |variable|
        variable_index = (internal_index / product) % variable.cardinality
        product *= variable.cardinality
        variable.assignment_for_index(variable_index)
      end
    end
    
  end
  
end