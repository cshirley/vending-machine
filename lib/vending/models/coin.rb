# frozen_string_literal: true

module Vending
  class Coin < ContainerItem
    attr_reader :value
    def initialize(name:, value:)
      raise ArgumentError, 'value' if value <= 0
      @value = value.to_i
      super(id: value, name: name)
    end
  end
end
