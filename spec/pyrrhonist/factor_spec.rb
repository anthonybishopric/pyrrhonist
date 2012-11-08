
module Pyrrhonist
  
  describe Factor do
    
    subject do
      apple_color = Variable.new(:apple_color)
      apple_color.values = {
        red: 0.7,
        green: 0.3
      }
      
      deliciousness = Variable.new(:deliciousness)
      deliciousness.values = {
        high: 0.4,
        low: 0.6
      }
      
      factor = Factor.new
      factor.variables = apple_color, deliciousness
      factor
    end
    
    it "is described by one or more variables" do
      subject.value_of(apple_color: :green, deliciousness: :high).should eq 0.12
      subject.value_of(apple_color: :red, deliciousness: :low).should eq 0.42
    end
    
    it "does not matter what order the keys are in" do
      subject.value_of(deliciousness: :low, apple_color: :red).should eq 0.42
    end
    
    it "has custom assignments for conditional probability" do
      subject.assign 0.8, apple_color: :red, deliciousness: :low
      
      subject.value_of(apple_color: :red, deliciousness: :low).should eq 0.8
    end
    
    it "creates a new factor from its product with another factor" do
      state_grown = Variable.new :state_grown
      state_grown.assignments = :california, :oregon, :washington
      apple_color = Variable.new :apple_color 
      apple_color.assignments = :red, :green
      other_factor = Factor.new
      other_factor.variables = state_grown, apple_color
      other_factor.assign 0.5, state_grown: :oregon, apple_color: :green
      
      factor_product = subject * other_factor
      
      factor_product.value_of({
        apple_color: :green,
        state_grown: :oregon,
        deliciousness: :high
      }).should eq(0.06)
    end 
   
    it "marginalizes specific variables and returns a new factor" do
      marginal_factor = subject.marginalize(:apple_color)
      
      marginal_factor.value_of(deliciousness: :high).should eq(0.4)
    end
    
  end
  
end