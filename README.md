
# How the Smart Contract Works
DEPLOYMENT ID: at10t9e3fwgqj0dyfc2hr6qnx3nnj54r03dwh8e3ut5hrvmcynhfqzqqqsaem

DEPLOYMENT URL: https://testnet.aleo.info/program/vesting_token_01.aleo

### The contract includes two main functionalities:

# Setting Up a Vesting Schedule

Only the admin (defined in ADMIN_ADDRESS) can create a vesting schedule for a user.
The admin defines:
- Start epoch: When the vesting begins.
- Cliff duration: The period before any tokens can be released.
- Total duration: The full period over which the tokens are released.
- Total amount: The number of tokens locked for the beneficiary.

This data is stored in mappings.
 
# Releasing Vested Tokens
- The beneficiary can call release_vested_tokens() after the cliff period.
- The contract checks how many tokens should be unlocked based on the time that has passed.
- It mints and sends only the portion that is vested (not the full amount).
- The released amount is updated to prevent double withdrawals.

# Is This a ZeFi (Zero-Knowledge DeFi) Application?
Yes, this can be considered a ZeFi (Zero-Knowledge DeFi) application because:

✅ It uses Zero-Knowledge Proofs (ZKPs) via the Aleo blockchain.

✅ It is finance-related, as it manages and distributes digital assets securely.

✅ It ensures privacy, since vesting schedules and token amounts are managed privately on-chain.

# Use Cases in ZeFi
- Private Salary Payments: Employees receive vested salaries over time without exposing financial data.
 
- Confidential Investment Vesting: Investors can receive tokens gradually, ensuring compliance with privacy regulations.
  
- Time-Locked Staking Rewards: Users can earn staking rewards over time, while keeping the total locked balance hidden.
