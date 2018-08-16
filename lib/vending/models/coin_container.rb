module Vending
  class CoinContainer < Container

    attr_reader :valid_denominations

    def initialize(denominations:, coins:[])
      validate_denominations(denominations)
      @valid_denominations = denominations
      super(item_type: Coin, items: coins)
    end

    def debit!(amount)
      raise InsufficientFundsError.new if (balance - amount) < 0
      debited_coins = debit_coins(amount)
      if amount != debited_coins.balance
        self.add_items(debited_coins.remove_all)
        raise InsufficientChangeError.new
      end
      debited_coins
    end

    def balance
      all.map(&:value).sum
    end

    def validate(coin)
      raise Vending::InvalidItemError.new unless valid_denominations.include?(coin.id.to_i)
    end

    private

    def validate_denominations(data)
      raise ArgumentError.new('denominations') unless data
      raise ArgumentError.new('denominations') unless data.is_a?(Array)
      data.each do |denom|
        unless denom && denom.is_a?(Integer) && denom > 0
          raise ArgumentError.new('denominations must be array of positive non zero integers')
        end
      end
    end

    def debit_coins(amount)
      change_collection = CoinContainer.new(denominations: self.valid_denominations)
      ids.map(&:to_i).sort.reverse.each do |denomination_key|
        while (change_collection.balance < amount ) &&
              (coin = self[denomination_key]) &&
              (denomination_key.to_i <= (amount - change_collection.balance)) do
          change_collection.add(self.remove(coin))
        end
      end
      change_collection
    end
  end
end
