
module Pyrrhonist
  
  describe Factor do
    
    it "is described by one or more variables" do
      
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
      
      factor.value_of(:red, :low).should eq(0.42)
      
    end
    
  end
  
end