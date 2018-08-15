require 'spec_helper'

RSpec.describe Vending::Machine, type: :domain do

  let(:clazz) { Vending::Machine }
  let(:valid_coin) { Vending::Coin.new(name: 'valid', value: 100) }
  let(:invalid_coin) { Vending::Coin.new(name: 'invalid', value: 101) }
  let(:products) { mock_product_collection }
  let(:change) { mock_coin_collection }
  let(:subject_with_product) { clazz.new(denomination_units: Vending::DEFAULT_DENOMINATION_UNITS,
                                         products: products,
                                         change: change) }

  describe 'initializes' do

    describe 'with defaults' do
      it 'has zero products' do
        expect(subject.products.count).to eq 0
      end
      it 'has zero balance' do
        expect(subject.machine_balance).to eq 0
      end
    end

    it 'with change and products' do
       expect(subject_with_product.machine_balance).to eq change.map(&:value).sum
    end

  end

  describe 'Insert money' do
    it 'valid coin has correct balance' do
      subject.insert_coin(valid_coin)
      expect(subject.customer_balance).to eq valid_coin.value
    end

    it 'invalid coin has correct balance' do
      expect { subject.insert_coin(invalid_coin) }.to raise_error Vending::InvalidItemError
      expect(subject.customer_balance).to eq 0
    end
  end

  describe 'eject coins' do

    it 'returns nothing if customer balance is 0' do
      expect(subject.eject_coins.length).to eq 0
    end

    it 'returns correct value' do
      subject = subject_with_product
      subject.insert_coin(Vending::Coin.new(name:100, value: 100))
      subject.insert_coin(Vending::Coin.new(name:1, value: 1))
      expect(subject.eject_coins.map(&:value).sort.reverse).to eq [100, 1]
    end

    it 'ejects coins after failed selection' do
      subject = subject_with_product
      subject.insert_coin(Vending::Coin.new(name:100, value: 100))
      expect { subject.vend_product(subject.products.first.id) }.to raise_error Vending::InsufficientFundsError
      expect(subject.eject_coins.map(&:value).sort.reverse).to eq [100]
    end

  end

  describe 'vend' do

    before {
      @subject = subject_with_product
      @product = @subject.products.first
    }

    it 'raise error when product not avaliable' do
      expect{@subject.vend_product('invalid_product')}.to raise_error Vending::ProductNotAvailableError
    end

    describe 'add correct amount and vend' do
      before {
        @subject.insert_coin(Vending::Coin.new(name:100, value: 100))
        @subject.insert_coin(Vending::Coin.new(name:1, value: 1))
        @result = @subject.vend_product(@product.id)
      }

      it { expect(@result[:product].id).to eq @product.id }
      it { expect(@result[:change].empty?).to be true }
    end

    it 'raise error when not enough funds but vends when add sufficient funds' do
      @subject.insert_coin(Vending::Coin.new(name:100, value: 100))

      expect{@subject.vend_product(@product.id)}.to raise_error Vending::InsufficientFundsError

      @subject.insert_coin(Vending::Coin.new(name:1, value: 1))
      result = @subject.vend_product(@product.id)

      expect(result[:product].id).to eq @product.id
      expect(result[:change].empty?).to be true
    end

    describe 'add over amount and vend with change' do
      before {
        @expected_change = [50, 20, 20, 5, 2, 2]
        @subject.load_coin(Vending::Coin.new(name:20, value: 20))
        @subject.load_coin(Vending::Coin.new(name:2, value: 2))

        @subject.insert_coin(Vending::Coin.new(name:100, value: 100))
        @subject.insert_coin(Vending::Coin.new(name:100, value: 100))

        @result = @subject.vend_product(@product.id)
      }
      it { expect(@result[:product].id).to eq @product.id }
      it { expect(@result[:change].count).to eq @expected_change.length }
      it { expect(@result[:change].map(&:value).sum).to eq  99 }
      it { expect(@result[:change].map(&:value).sort.reverse).to eq @expected_change }
    end
  end

  describe 'load machine' do
    it 'loads coin' do
      subject.load_coin(valid_coin)
      expect(subject.machine_balance).to eq valid_coin.value
    end

    it 'loads product' do
      new_product = Vending::Product.new(name: "p1", price: 1000)
      subject.load_product(new_product)
      expect(subject.products.select { |p| p.name == new_product.name }.count).to eq 1
    end
  end
end
