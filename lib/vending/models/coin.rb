module Vending
  class Coin < ContainerItem
    attr_reader :value
     def initialize(name:, value:)
       @value = value.to_i
       super(id: value, name: name)
     end
  end
end
