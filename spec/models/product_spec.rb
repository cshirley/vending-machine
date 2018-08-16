# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vending::Product, type: :model do
  let(:clazz) { Vending::Product }
  describe 'initializes' do
    it 'raised error with zero price' do
      expect { clazz.new(name: 'product', price: 0) }.to raise_error ArgumentError
    end

    it 'raised error with negative price' do
      expect { clazz.new(name: 'product', price: -10) }.to raise_error ArgumentError
    end
  end
end
