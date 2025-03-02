
// The 'vesting_token' program with linear vested token lock.
program vesting_token_01.aleo {
    // Constants defining the token parameters.
    const ADMIN_ADDRESS: address = aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h;

    // Mappings for vesting schedules.
    mapping vesting_owner: address => address;
    mapping vesting_start_epoch: address => u32;
    mapping vesting_cliff_duration: address => u32;
    mapping vesting_duration: address => u32;
    mapping vesting_amount: address => u128;
    mapping vesting_released: address => u128;


    /**
     * Sets up a vesting schedule for a beneficiary.
     */
    async transition create_vesting_schedule(
        beneficiary: address,
        start_epoch: u32,
        cliff_duration: u32,
        duration: u32,
        amount: u128
    ) -> Future {
        assert_eq(self.caller, ADMIN_ADDRESS);
        return finalize_create_vesting(beneficiary, start_epoch, cliff_duration, duration, amount);
    }

    async function finalize_create_vesting(
        beneficiary: address,
        start_epoch: u32,
        cliff_duration: u32,
        duration: u32,
        amount: u128
    ) {
        assert(!vesting_owner.contains(beneficiary));

        // Store each field separately
        vesting_owner.set(beneficiary, beneficiary);
        vesting_start_epoch.set(beneficiary, start_epoch);
        vesting_cliff_duration.set(beneficiary, cliff_duration);
        vesting_duration.set(beneficiary, duration);
        vesting_amount.set(beneficiary, amount);
        vesting_released.set(beneficiary, 0u128);
    }

    /**
     * Releases vested tokens to the owner.
     */
    async transition release_vested_tokens(
        beneficiary: address,
        current_epoch: u32
    ) -> (Future) {
        let caller: address = self.caller;
        assert_eq(caller, beneficiary);

        return finalize_release(beneficiary, current_epoch);
    }

    async function finalize_release(beneficiary: address, current_epoch: u32) {

       // Retrieve vesting details from mappings
        let start_epoch: u32 = vesting_start_epoch.get(beneficiary);
        let cliff_duration: u32 = vesting_cliff_duration.get(beneficiary);
        let duration: u32 = vesting_duration.get(beneficiary);
        let total_amount: u128 = vesting_amount.get(beneficiary);
        let released: u128 = vesting_released.get(beneficiary);

        // Ensure vesting period has started
        let cliff_end: u32 = start_epoch + cliff_duration;
        assert(current_epoch >= cliff_end);

        // Calculate vested amount
        let elapsed_epochs: u32 = current_epoch - start_epoch;
        let vested_amount: u128 = elapsed_epochs >= duration ? total_amount : (total_amount * elapsed_epochs as u128) / (duration as u128);


        let releasable_amount: u128 = vested_amount - released;
        assert(releasable_amount > 0u128);

        // Update the released amount in mappings
        vesting_released.set(beneficiary, vested_amount);

    }
}
