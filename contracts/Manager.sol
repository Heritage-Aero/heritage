pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/lifecycle/Destructible.sol";


contract HeritageContract {
  function createFundraiser(string _description, uint256 _goal, address _beneficiary, string _taxId, bool _claimable);
}


contract Manager is Ownable, Destructible {
  HeritageContract heritage;
  bool canBatchOne = true;
  bool canBatchTwo = true;

  constructor(address _addr) {
    heritage = HeritageContract(_addr);
  }

  function batchOne() onlyOwner {
    require(canBatchOne);
    heritage.createFundraiser("1", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("3", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("4", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("5", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("6", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("7", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("8", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("9", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("10", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("11", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("12", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("13", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("14", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("15", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("16", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("17", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("18", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("19", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("20", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("21", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("22", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("23", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("24", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("25", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("26", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("27", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("28", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("29", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("30", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("31", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("32", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("33", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("34", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("35", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("36", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("37", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("38", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("39", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("40", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("41", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("42", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("43", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("44", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("45", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("46", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("47", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("48", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("49", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("50", 0, address(0), "Tax Infos", false);
    canBatchOne = false;
  }

  function batchTwo() onlyOwner {
    // etc..
    require(canBatchTwo);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("Batch 2", 0, address(0), "Tax Infos", false);
    heritage.createFundraiser("60 Batch 2", 0, address(0), "Tax Infos", false);
    canBatchTwo = false;
  }
}