# Basis Yolo



Basis Yolo is a lightweight implementation of the [Basis Yolo Protocol](basisyolo.com) on HECO. 

## History of Basis 

Basis is an algorithmic stablecoin protocol where the money supply is dynamically adjusted to meet changes in money demand.  

- When demand is rising, the blockchain will create more Basis Yolo. The expanded supply is designed to bring the Basis price back down.
- When demand is falling, the blockchain will buy back Basis Yolo. The contracted supply is designed to restore Basis price.
- The Basis Yolo protocol is designed to expand and contract supply similarly to the way central banks buy and sell fiscal debt to stabilize purchasing power. For this reason, we refer to Basis Yolo  as having an algorithmic central bank.


Basis was shut down in 2018, due to regulatory concerns its Bond and Share tokens have security characteristics. The project team opted for compliance, and shut down operations, returned money to investors and discontinued development of the project. 

## The Basis Yolo Protocol

Basis Yolo differs from the original Project in several meaningful ways: 

1. **Rationally simplified** - several core mechanisms of the Basis Yolo protocol has been simplified, especially around bond issuance and seigniorage distribution. We've thought deeply about the tradeoffs for these changes, and believe they allow significant gains in UX and contract simplicity, while preserving the intended behavior of the original monetary policy design. 
2. **Censorship resistant** - we launch this project anonymously,  We believe this will allow the project to avoid the censorship of regulators that scuttled the original Basis Yolo Protocol, but will also allow Basis Yolo to avoid founder glorification & single points of failure that have plagued so many other projects. 
3. **Fairly distributed** - both Basis Yolo Shares and Basis Yolo Cash has zero premine and no investors - community members can earn the initial supply of both assets by helping to contribute to bootstrap liquidity & adoption of Basis Yolo. 

### A Three-token System

There exists three types of assets in the Basis Yolo system. 

- **Basis Yolo Cash ($BYC)**: a stablecoin, which the protocol aims to keep value-pegged to 1 US Dollar. 
- **Basis Yolo Bonds ($BYB)**: IOUs issued by the system to buy back Basis Cash when price($BAC) < $1. Bonds are sold at a meaningful discount to price($BAC), and redeemed at $1 when price($BYC) normalizes to $1. 
- **Basis YOlO Shares ($BYS)**: receives surplus seigniorage (seigniorage left remaining after all the bonds have been redeemed).

### Stability Mechanism

- **Contraction**: When the price($BYC) < ($1 - epsilon), users can trade in $BYC for $BYB at the BYBBYC exchange rate of price($BYC). This allows bonds to be always sold at a discount to cash during a contraction.
- **Expansion**: When the price($BYC) > ($1 + epsilon), users can trade in 1 $BYB for 1 $BYC. This allows bonds to be redeemed always at a premium to the purchase price. 
- **Seigniorage Allocation**: If there are no more bonds to be redeemed, (i.e. bond Supply is negligibly small), more $BYC is minted totalSupply($BYC) * (price($BYC) - 1), and placed in a pool for $BYS holders to claim pro-rata in a 24 hour period. 



## Motivation

We, the core developers of Basis Yolo, were early supporters & observers of Basis when it first launched, and to this day believe that it is one of the best ideas to have ever been put forward in crypto. While Bitcoin first got us interested in blockchain's use cases, it was Basis that first truly inspired us, by painting a picture of a world that runs entirely on decentralized digital dollars the policies for which cannot be corrupted or politicized. Basis is more relevant now today than it ever was in 2017/2018 - with regulators striking back against the decentralized movement by cracking down on Telegram and Libra, while their governments are printing money faster than ever before in human history. 

This is not a DeFi project. We are simply leveraging the industry's excitement in the category to bring much deserved attention and engagement to the Basis Yolo Protocol, and to use this opportunity to distribute ownership in the protocol fairly.

Our only motivation is to bring the Basis Yolo Protocol into the world, and to serve its community in implementing Basis Yolo' vision to become the first widely adopted decentralized dollar. To that end, we are committed to take no financial upside in Basis Cash Yolo's success - we will raise no money and premine no tokens. Instead, when we feel that the protocol has found reasonable product market fit, we will ask the Basis Yolo Shares DAO for donations to keep contributing to the protocol. 


_© Copyright 2021, Basis Yolo 
