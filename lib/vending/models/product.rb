module Vending
  class Product < ContainerItem
    attr_reader :price
    def initialize(name:, price:)
      raise ArgumentError.new('price') if price <= 0
      @price = price
      super(id: name, name: name)
    end
  end
end
