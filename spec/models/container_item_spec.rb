# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vending::ContainerItem, type: :model do
  let(:clazz) { Vending::ContainerItem }
  describe 'initializes' do
    it 'with correct name ' do
      expect(clazz.new(id: 'test id', name: 'test name').id).to eq 'test id'
    end

    it 'with correct price' do
      expect(clazz.new(id: 'test id', name: 'test name').name).to eq 'test name'
    end

    it 'raised error with nil id' do
      expect { clazz.new(id: nil, name: 'test name') }.to raise_error ArgumentError
    end

    it 'raised error with empty id' do
      expect { clazz.new(id: '', name: 'test name') }.to raise_error ArgumentError
    end

    it 'raised error with nil name' do
      expect { clazz.new(id: 'product', name: nil) }.to raise_error ArgumentError
    end

    it 'raised error with empty name' do
      expect { clazz.new(id: 'product', name: '') }.to raise_error ArgumentError
    end
  end
end
