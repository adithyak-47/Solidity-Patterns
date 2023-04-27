# Solidity Design Patterns
The smart contract demonstrates the following design patterns:
1. Guard check: Usage of guards to ensure that the smart contract behaves as expected.
2. State Machine: The smart contract demonstrates its behaviour at different states.
3. Access Restriction: Ensures that some functions are executed only by the owner (deployer).
4. Secure Ether Transfer: Makes uses of the 'call' function to transfer ether.
5. Pull over push: Makes sure that the user can claim refund on owner's approval.

The smart contract called BurgerShop demonstrates how a usual burger shop would function, except that it is in the form of a smart contract. It uses a 
compiler version above 0.8.0, and sets a time period after which the shop opens. The smart contract is only for learning purpose.
