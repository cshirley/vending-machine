module Vending
  class Machine

    def initialize(denomination_units: nil, products: nil, change: nil)
      denomination_units ||= DEFAULT_DENOMINATION_UNITS
      @coin_hopper = CoinContainer.new(denominations: denomination_units, coins: change)
      @inventory = Container.new(item_type: Product, items: products)
      @customer_balance = 0
      self
    end

    def products
      @inventory.all
    end

    def machine_balance
      @coin_hopper.balance
    end

    def customer_balance
      @customer_balance
    end

    def insert_coin(coin)
      @coin_hopper.add(coin)
      @customer_balance += coin.value
    end

    def eject_coins
      coins = @coin_hopper.debit!(@customer_balance)
      @customer_balance = 0
      coins.remove_all
    end

    def vend_product(product_name)
      raise ProductNotAvailableError.new  unless selected_product = @inventory[product_name]
      new_balance = (@customer_balance - selected_product.price)
      raise InsufficientFundsError.new  if new_balance < 0
      coins = new_balance == 0 ? [] : @coin_hopper.debit!(new_balance).remove_all
      vended_product = @inventory.remove(selected_product)
      @customer_balance = 0
      { product: vended_product, change: coins}
    end

    def load_product(product)
      @inventory.add(product)
    end

    def load_coin(coin)
      @coin_hopper.add(coin)
    end
  end
end
