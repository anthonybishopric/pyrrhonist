
module Pyrrhonist
  
  describe Variable do
   
    context "with assignments but no values" do
      
      subject do
        Variable.new(:apple_color, [:green, :red])
      end
      
      it "has a cardinality of 2" do
        subject.cardinality.should eq 2
      end
      
      it "indexes assignments by ordinal value" do
        subject.index_for_assignment(:green).should eq(0)
      end
      
      it "can take an index and return the associated assignment" do
        subject.assignment_for_index(1).should eq(:red)
      end
      
      it "equals another variable with the same name and assignments" do
        variable2 = Variable.new(:apple_color, [:green, :red])
        subject.should eq(variable2)
        (subject == variable2).should be_true
        (subject.eql?(variable2)).should be_true
      end
      
    end
    
  end
  
end