# frozen_string_literal: true

module Vending
  class InsufficientFundsError   < StandardError; end
  class ProductNotAvailableError < StandardError; end
  class InsufficientChangeError  < StandardError; end
  class InvalidItemError         < StandardError; end
end
