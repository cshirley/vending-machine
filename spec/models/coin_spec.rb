# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vending::Coin, type: :model do
  let(:clazz) { Vending::Product }
  describe 'initializes' do
    it 'raised error with zero value' do
      expect { clazz.new(name: 'coin', value: 0) }.to raise_error ArgumentError
    end

    it 'raised error with negative value' do
      expect { clazz.new(name: 'coin', value: -10) }.to raise_error ArgumentError
    end
  end
end
