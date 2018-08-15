require 'spec_helper'

RSpec.describe Vending::Container, type: :model do

  class MockItem < Vending::ContainerItem; end

  class MockContainer < Vending::Container

    def initialize(raise_error = false)
      @raise_error = raise_error
      super(MockItem, [])
    end

    def validate(item)
      raise Vending::InvalidItemError.new if @raise_error
    end

  end
  let(:clazz) { Vending::Container}
  let(:items) { 10.times.inject([]) { |arr, i| arr << MockItem.new(id:i.to_s, name: "item #{i}")  } }
  let(:subject) { clazz.new(MockItem, items) }

  describe 'initializes' do
    it 'with no params' do
      expect{clazz.new}.to raise_error ArgumentError
    end

    it 'with valid items' do
      expect{ clazz.new(MockItem, items.dup) }.not_to raise_error(Vending::InvalidItemError)
    end

    it 'throws error with invalid type array'  do
      expect{ clazz.new(MockItem, [Object.new]) }.to raise_error Vending::InvalidItemError
    end

  end

  describe 'Mutable Operation' do

    it 'Add item' do
      item = MockItem.new(id: 11, name: 'item 11')
      expect(subject.add(item)[item.id].name).to eq item.name
    end

    it 'Add item with duplicate id' do
      item = MockItem.new(id: 1, name: 'item 1')
      expect(subject.add(item)[item.id].name).to eq item.name
      expect(subject.add(item)[item.id].name).not_to eq item
    end

    it 'Remove item' do
      item = subject[1]
      removed_item = subject.remove(item)
      expect(removed_item.id).to eq "1"
      expect(subject[1]).to be nil
    end

    it 'Adds Many' do
      subject.add_items([MockItem.new(id: 12, name: 'Item 12'), MockItem.new(id: 13, name: 'Item 13')])
    end

    it 'Remove all from container' do
      subject.remove_all
      expect(subject.key_item_count.values.sum).to eq 0
    end

    it 'Remove all from container returning flat array of items' do
      original_count = subject.key_item_count.values.sum
      expect(subject.remove_all.length).to eq original_count
    end
  end

  describe 'Inventory' do

    it 'has a single element for each item' do
      expect(subject.key_item_count.values.select { |v| v != 1 }.count).to eq 0
    end

    it 'has a more than 1 element for item id 1' do
      item = MockItem.new(id: 1, name: 'item 1')
      subject.add(item)
      expect(subject.key_item_count.values.select { |v| v != 1 }.count).to eq 1
    end

    it 'has a 1 element for item id: 1 after removal' do
      item = MockItem.new(id: 1, name: 'item 1')
      subject.add(item)
      subject.remove(item)
      expect(subject.key_item_count.values.select { |v| v != 1 }.count).to eq 0
    end
  end

  describe 'Find' do
    it 'first item by id' do
      item = items.first
      expect(subject[item.id].id).to eq item.id
    end

    it 'fails for missing item' do
      expect(subject['missing']).to eq nil
    end

    it 'first item of many in list' do
      item = MockItem.new(id: 1, name: 'item 1')
      subject.add(item)
      expect(subject[item.id]).not_to be item
    end

    it 'all items for id' do
      item = MockItem.new(id: 1, name: 'item 1')
      subject.add(item)
      expect(subject.find_all(item.id).count).to eq 2
    end
  end

  describe 'Delegator' do
    it 'customer validator raises error' do
      item = MockItem.new(id: 1, name: 'item 1')
      expect{MockContainer.new(true).add(item)}.to raise_error Vending::InvalidItemError
    end

    it 'customer validator not to raise error' do
      item = MockItem.new(id: 1, name: 'item 1')
      expect{MockContainer.new(false).add(item)}.not_to raise_error Vending::InvalidItemError
    end
  end
end
