# Vending Machine Test

## Specification
Design a vending machine using ruby. The vending machine should perform as follows:

- Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product.
- It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted.
- The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
- There should be a way of reloading either products or change at a later point.
- The machine should keep track of the products and change that it contains.


## Assumptions

1. Supports a Single Hard Currency
2. Backend implementation only (i.e. no user interface - tests cover Specification)
3. Once item is vended, change is automatically returned (if applicable)
4. If we can not return correct change then we will not vend the item & inform caller
5. If caller cancels then current balance is returned - this will be using minimum number of coins available within the machine at that point in time.

