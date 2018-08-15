module ModelHelpers

  def mock_coin_collection
    coins = []
    Vending::DEFAULT_DENOMINATION_UNITS.each do |denom|
      coins << Vending::Coin.new(name: denom.to_s, value: denom)
    end
    coins
  end

  def mock_product_collection
    (1..10).inject([]) { |arr, i| arr << Vending::Product.new(name: "test #{i}", price: 100 + i) }
  end
end
