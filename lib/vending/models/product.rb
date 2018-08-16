# frozen_string_literal: true

module Vending
  class Product < ContainerItem
    attr_reader :price
    def initialize(name:, price:)
      raise ArgumentError, 'price' if price <= 0
      @price = price
      super(id: name, name: name)
    end
  end
end
