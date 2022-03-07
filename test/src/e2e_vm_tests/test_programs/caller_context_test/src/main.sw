script;
use std::{chain::assert, constants::{ETH_ID, ZERO}, contract_id::ContractId};
use context_testing_abi::*;

fn main() -> bool {
    let gas: u64 = 1000;
    let amount: u64 = 11;
    let other_contract_id = ~ContractId::from(0x285dafd64feb42477cfb3da8193ceb28b5f5277c17591d7c10000661cacdd0c9);

    // contract ID for sway/test/src/e2e_vm_tests/test_programs/balance_test_contract
    let deployed_contract_id = 0xa835193dabf3fe80c0cb62e2ecc424f5ac03bc7f5c896ecc4bd2fd06cc434322;

    let test_contract = abi(ContextTesting, 0x285dafd64feb42477cfb3da8193ceb28b5f5277c17591d7c10000661cacdd0c9);

    // test Context::contract_id():
    let returned_contract_id = test_contract.get_id {
        gas: gas, coins: 0, asset_id: ETH_ID
    }
    ();
    assert(returned_contract_id.into() == deployed_contract_id);

    // @todo set up a test contract to mint some tokens for testing balances.
    // test Context::this_balance():
    let returned_this_balance = test_contract.get_this_balance {
        gas: gas, coins: 0, asset_id: ETH_ID
    }
    (ETH_ID);
    assert(returned_this_balance == 0);

    // test Context::balance_of_contract():
    let returned_contract_balance = test_contract.get_balance_of_contract {
        gas: gas, coins: 0, asset_id: ETH_ID
    }
    (ETH_ID, other_contract_id);
    assert(returned_contract_balance == 0);

    // test Context::msg_value():
    let returned_amount = test_contract.get_amount {
        gas: gas, coins: amount, asset_id: ETH_ID
    }
    ();
    assert(returned_amount == amount);

    // test Context::msg_asset_id():
    let returned_asset_id = test_contract.get_asset_id {
        gas: gas, coins: amount, asset_id: ETH_ID
    }
    ();
    assert(returned_asset_id.into() == ETH_ID);

    // test Context::msg_gas():
    // @todo expect the correct gas here... this should fail using `1000`
    let gas = test_contract.get_gas {
        gas: gas, coins: amount, asset_id: ETH_ID
    }
    ();
    assert(gas == 1000);

    // test Context::global_gas():
    // @todo expect the correct gas here... this should fail using `1000`
    let global_gas = test_contract.get_global_gas {
        gas: gas, coins: amount, asset_id: ETH_ID
    }
    ();
    assert(global_gas == 1000);

    true
}
