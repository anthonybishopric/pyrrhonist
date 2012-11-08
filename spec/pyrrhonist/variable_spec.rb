
module Pyrrhonist
  
  describe Variable do
   
    context "with assignments but no values" do
      
      subject do
        variable = Variable.new(:apple_color)
        variable.assignments = :green, :red
        variable
      end
      
      it "has a cardinality of 2" do
        subject.cardinality.should eq 2
      end
      
      it "has equal value for any assignment by default" do
        subject.value_of(:green).should eq 1
        subject.value_of(:red).should eq 1
      end
      
      context "and then has specific values assigned" do
        
        before do
          subject.values = {
            green: 0.8,
            red: 1.2
          }
        end
        
        it "takes specific values with a weight" do
          subject.value_of(:green).should eq 0.8
        end
        
        it "normalizes such that the sum of each value in the factor is 1" do
          subject.normalize
          subject.value_of(:green).should eq 0.4
          subject.value_of(:red).should eq 0.6
        end
        
      end
      
    end
    
  end
  
end