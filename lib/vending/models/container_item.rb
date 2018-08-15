module Vending
  class ContainerItem
   attr_accessor :id, :name

   def initialize(id:, name:)
     raise ArgumentError.new('id') unless valid_arg?(id)
     raise ArgumentError.new('name') unless valid_arg?(name)
     @id = id.to_s
     @name = name.to_s
     self
   end

   private

   def valid_arg?(data)
     data && !data.to_s.empty?
   end

  end
end
