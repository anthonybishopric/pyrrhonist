
module Pyrrhonist
  
  describe Variable do
  
    subject do
      variable = Variable.new(:apple_color)
      variable.values = {
        green: 0.5, 
        red: 0.6
      }
      variable
    end
    
    it "takes specific values with a weight" do
      subject.value_of(:green).should eq (0.5)
    end
    
  end
  
end