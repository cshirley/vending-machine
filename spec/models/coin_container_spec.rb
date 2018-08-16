require 'spec_helper'

RSpec.describe Vending::CoinContainer, type: :model do
  let(:coin_clazz) { Vending::Coin }
  let(:clazz) { Vending::CoinContainer}
  let(:deno_units) { Vending::DEFAULT_DENOMINATION_UNITS }
  let(:subject) { clazz.new(denominations: deno_units) }

  describe 'initializes' do
    it 'raises error with nil denomination array' do
      expect{ clazz.new(denominations: nil) }.to raise_error ArgumentError
    end

    it 'raises error with non array denomination' do
      expect{ clazz.new(denominations: Object.new) }.to raise_error ArgumentError
    end

    it 'raises error with non Integer array denomination' do
      expect{ clazz.new(denominations: [1, "aa"] ) }.to raise_error ArgumentError
    end
    it 'Initialises with Zero Balance' do
      expect(subject.balance).to eq 0
    end

    it 'Initialises with a One Pound denomination' do
      expect(clazz.new(denominations: deno_units, coins: [coin_clazz.new(name: 100, value: 100)]).balance).to eq 100
    end
  end

  describe 'Credit' do
    it 'Credit 2 pounds' do expect(subject.add(coin_clazz.new(name: 200,value: 200)).balance).to eq 200 end
    it 'adds 1 pound' do
      subject.add(coin_clazz.new(name: 200,value: 200))
      subject.add(coin_clazz.new(name: 100,value: 100))
      expect(subject.balance).to eq 300
    end
  end

  describe 'Debit' do
    it 'Raise error if InsufficientFunds' do
      expect {subject.debit!(1000)}.to raise_error(Vending::InsufficientFundsError)
    end

    it 'Raise error if InsufficientChange' do
      2.times { subject.add(coin_clazz.new(name: 50, value: 50 )) }
      expect {subject.debit!(20) }.to raise_error(Vending::InsufficientChangeError)
      expect(subject.balance).to eq 100
    end

    it 'returns coin collection' do
      2.times { subject.add(coin_clazz.new(name: 50, value: 50 )) }
      result = subject.debit!(50)
      expect(result.balance).to eq 50
      expect(subject.balance).to eq 50
    end
  end
end
