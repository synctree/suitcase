module Suitcase
  class Amenity
    attr_accessor :id, :description
    
    def initialize(info)
      @id, @description = info[:id], info[:description]
    end
  end
end
