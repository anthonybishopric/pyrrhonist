
module Pyrrhonist
  
  describe Factor do
    
    subject do
      factor = Factor.new
      
      factor.define :apple_color, :deliciousness do 
        {
          [:red, :high]   => 0.24,
          [:green, :high] => 0.16,
          [:red, :low]    => 0.46, 
          [:green, :low]  => 0.14
        }
      end
      
      factor
    end
    
    it "is described by one or more variables" do
      subject.value_of(apple_color: :green, deliciousness: :high).should eq 0.16
      subject.value_of(apple_color: :red, deliciousness: :low).should eq 0.46
    end
    
    it "does not matter what order the keys are in" do
      subject.value_of(deliciousness: :low, apple_color: :red).should eq 0.46
    end
    
    it "has custom assignments for conditional probability" do
      subject.assign 0.8, apple_color: :red, deliciousness: :low
      
      subject.value_of(apple_color: :red, deliciousness: :low).should eq 0.8
    end
    
    it "creates a new factor from its product with another factor" do
      state_grown_factor = Factor.new
      
      state_grown_factor.define :apple_color, :state_grown do
        {
          [:red, :oregon]   => 0.5,
          [:green, :oregon] => 0.5
        }
      end
            
      factor_product = subject * state_grown_factor
      
      factor_product.value_of({
        apple_color: :green,
        state_grown: :oregon,
        deliciousness: :high
      }).should eq(0.08)
    end 
   
    it "marginalizes specific variables and returns a new factor" do
      marginal_factor = subject.marginalize(:apple_color)
      
      marginal_factor.value_of(deliciousness: :high).should eq(0.4)
    end
    
    it "can observe evidence which creates a new factor with reduced cardinality in its variables" do
      observed = subject.observe(apple_color: :red)
      observed.value_of(apple_color: :red, deliciousness: :low).should eq(0.65714285714286)
    end
    
  end
  
end