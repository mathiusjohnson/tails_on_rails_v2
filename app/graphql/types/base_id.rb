module Types
  class BaseId < Types::BaseScalar 
    description "A numeric ID, transported as a String." 

    def self.coerce_input(val, ctx)
      val.to_i 
    end 

    def self.coerce_result(val, ctx)
      val.to_s
    end 
  end 
end