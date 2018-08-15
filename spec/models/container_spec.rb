require 'spec_helper'

RSpec.describe Vending::Container, type: :model do

  CLAZZ = Vending::Container

  class MockItem < Vending::ContainerItem; end

  class MockContainer < Vending::Container

    def initialize(raise_error = false)
      @raise_error = raise_error
      super(item_type: MockItem, items: [])
    end

    def validate(item)
      raise Vending::InvalidItemError.new if @raise_error
    end

  end

  def build_mock_item(id)
    MockItem.new(id: id, name: "item #{id}")
  end

  def build_mock_items
    10.times.inject([]) { |arr, i| arr << build_mock_item(i)  }
  end

  let(:subject) { CLAZZ.new(item_type: MockItem, items: build_mock_items) }

  describe 'initializes' do
    it 'with no params' do
      expect{CLAZZ.new}.to raise_error ArgumentError
    end

    it 'with valid items' do
      expect{ CLAZZ.new(item_type: MockItem, items: items.dup) }.not_to raise_error(Vending::InvalidItemError)
    end

    it 'throws error with invalid type array'  do
      expect{ CLAZZ.new(item_type: MockItem, items: [Object.new]) }.to raise_error Vending::InvalidItemError
    end

  end

  context 'Mutable Operation' do

    it 'Raises Error when Add item with incorrect type' do
      expect { subject.add(Object.new) }.to raise_error Vending::InvalidItemError
    end

    it 'Raises Error when removing item with incorrect type' do
      expect { subject.remove(Object.new) }.to raise_error Vending::InvalidItemError
    end

    describe 'Add new unique item' do
      before(:all) {
        @item = build_mock_item(11)
        @subject = CLAZZ.new(item_type: MockItem, items: build_mock_items)
        @original_count = @subject.all.count
        @subject.add(@item.dup)
      }
      it { expect(@subject[@item.id].name).to eq @item.name }
      it { expect(@subject.all.count).to eq @original_count + 1 }
      it { expect(@subject.find_all(@item.id).count).to eq 1 }
    end

    describe 'Add item with duplicate id' do

      before(:all) {
        @item = build_mock_item(1)
        @subject = CLAZZ.new(item_type: MockItem, items:build_mock_items)
        @original_count = @subject.all.count
        @subject.add(@item.dup)
      }
      it { expect(@subject[@item.id].name).to eq @item.name }
      it { expect(@subject.all.count).to eq @original_count + 1 }
      it { expect(@subject.find_all(@item.id).count).to eq 2 }
    end

    describe 'Remove existing item' do
      before(:all) {
        @subject = CLAZZ.new(item_type: MockItem, items:build_mock_items)
        @item = @subject[1]
        @original_count = @subject.all.count
        @removed_item = @subject.remove(@item)
      }

      it { expect(@removed_item.id).to eq "1" }
      it { expect(@subject[@removed_item.id]).to be nil }
      it { expect(@subject.all.count).to eq @original_count - 1 }
      it { expect(@subject.find_all(@removed_item.id).count).to eq 0 }
    end

    describe 'Remove missing item' do

      before(:all) {
        @item = build_mock_item(111)
        @subject = CLAZZ.new(item_type: MockItem, items:build_mock_items)
        @original_count = @subject.all.count
        @removed_item = @subject.remove(@item)
      }

      it { expect(@removed_item).to be nil }
      it { expect(@subject.all.count).to eq @original_count  }
    end

    it 'Adds Many' do
      original_count = subject.all.length
      subject.add_items([build_mock_item(12), build_mock_item(13)])
      expect(subject.all.length).to eq original_count + 2
    end

    it 'Remove all from container' do
      subject.remove_all
      expect(subject.all.length).to eq 0
    end

    it 'Remove all from container returning flat array of items' do
      original_count = subject.key_item_count.values.sum
      expect(subject.remove_all.length).to eq original_count
    end
  end

  describe 'Retrieve' do
    it 'first item by id' do
      item = build_mock_items.first
      expect(subject[item.id].id).to eq item.id
    end

    it 'fails for missing item' do
      expect(subject['missing']).to eq nil
    end

    it 'first item of many in list (not one just inserted)' do
      item = build_mock_item(1)
      expect(subject.add(item)[item.id]).not_to be item
    end

    it 'all items for id' do
      item = build_mock_item(1)
      expect(subject.add(item).find_all(item.id).count).to eq 2
    end
  end

  describe 'Delegator' do
    it 'customer validator raises error' do
      item = build_mock_item(1)
      expect{MockContainer.new(true).add(item)}.to raise_error Vending::InvalidItemError
    end

    it 'customer validator not to raise error' do
      item = build_mock_item(1)
      expect{MockContainer.new(false).add(item)}.not_to raise_error Vending::InvalidItemError
    end
  end
end
