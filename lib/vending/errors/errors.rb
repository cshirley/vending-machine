module Vending
  class InsufficientFundsError < StandardError; end
  class ProductNotAvailable < StandardError; end
  class InsufficientChangeError < StandardError; end
  class InvalidDenomination < StandardError; end
  class InvalidItemError < StandardError; end
end
