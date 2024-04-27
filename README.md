# ethereum-vending-machine
smart contract vending machine for second assignment of blockchain subject

# functions
## getSoda
if you call this function with count value, you will get "Purchase complete. you get soda" message.
note that you should call this function with sending ether greater than or equal to total price(=1 ether * count).
soda is 1 ether

## getJuice
if you call this function with count value, you will get "Purchase complete. you get juice" message.
note that you should call this function with sending ether greater than or equal to total price(=2 ether * count).
juice is 2 ether

## getWater
if you call this function with count value, you will get "Purchase complete. you get water" message.
note that you should call this function with sending ether greater than or equal to total price(=3 ether * count).
water is 3 ether

## withdraw
if you call this function with address value, this contract will send all ether in it to the address that you input.
note that this function can only be called by contract owner.

## getLogs
if you call this function, you will get purchase log with address and amount(in wei).
note that this function can only be called by contract owner.

# demo video
you can watch the video via clicking the image below
[![Video Label](http://img.youtube.com/vi/MEiX_zkOOQE/0.jpg)](https://youtu.be/MEiX_zkOOQE)

[https://youtu.be/MEiX_zkOOQE](https://youtu.be/MEiX_zkOOQE)

# how to run?
1. visit solidity web compiler 'remix' [https://remix.ethereum.org/](https://remix.ethereum.org/)
2. create new workspace
   
   ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/02e19300-e1df-4577-bdc2-2164a0a8dd25)

   ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/0d123495-d33b-41b9-a860-ae39b72cf320)


4. upload 'VendingMachine.sol'

   ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/748bf149-c84c-4826-8d43-76c1c50ab452)

5. compile
   
   ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/fc96a9f0-5848-4fb5-a46a-585574a48538)

7. deploying
   
   ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/71ecf762-e81d-4b40-93c4-4706eedf29e4)

8. get beverage!
    
   ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/3bbd5fe6-cf3f-47ab-ab3e-5dc4c2eeda90)
  ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/dc903532-0de1-400e-ac51-4f52a412e6f4)
  ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/efffaa31-1594-46c3-8ac6-785c60d44f09)
  ![image](https://github.com/minchoCoin/ethereum-vending-machine/assets/62372650/597300b3-6180-435f-8660-4e307ee23481)

  if you send 5 ether and purchase 2 cups of juice, you will get 2 juice and 1 ether(for exchange)


