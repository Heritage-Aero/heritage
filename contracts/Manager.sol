pragma solidity 0.4.24;

import "./Ownable.sol";
import "./Destructible.sol";


contract HeritageContract {
  function createFundraiser(string _description, uint256 _goal, address _beneficiary, string _taxId, bool _claimable);
}


contract Manager is Ownable, Destructible {
  HeritageContract heritage;
  bool canBatchOne = true;
  bool canBatchTwo = true;
  bool canBatchThree = true;
  bool canBatchFour = true;
  bool canBatchFive = true;
  address bene;

  constructor(address _addr, address _bene) {
    heritage = HeritageContract(_addr);
    bene = _bene;
  }
  
  function setBene(address _bene) onlyOwner public{
      bene = _bene;
  }


  function batchOne() onlyOwner {
    require(canBatchOne);
   heritage.createFundraiser("1", 1, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("2", 2, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("3", 3, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("4", 4, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("5", 5, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("6", 6, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("7", 7, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("8", 8, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("9", 9, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("10", 10, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("11", 11, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("12", 12, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("13", 13, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("14", 14, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("15", 15, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("16", 16, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("17", 17, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("18", 18, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("19", 19, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("20", 20, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("21", 21, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("22", 22, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("23", 23, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("24", 24, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("25", 25, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("26", 26, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("27", 27, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("28", 28, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("29", 29, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("30", 30, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("31", 31, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("32", 32, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("33", 33, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("34", 34, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("35", 35, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("36", 36, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("37", 37, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("38", 38, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("39", 39, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("40", 40, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("41", 41, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("42", 42, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("43", 43, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("44", 44, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("45", 45, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("46", 46, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("47", 47, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("48", 48, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("49", 49, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("50", 50, bene, "MuttVille December 2018", false);
    canBatchOne = false;
  }

  function batchTwo() onlyOwner {
    // etc..
    require(canBatchTwo);
   heritage.createFundraiser("51", 51, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("52", 52, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("53", 53, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("54", 54, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("55", 55, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("56", 56, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("57", 57, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("58", 58, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("59", 59, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("60", 60, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("61", 61, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("62", 62, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("63", 63, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("64", 64, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("65", 65, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("66", 66, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("67", 67, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("68", 68, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("69", 69, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("70", 70, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("71", 71, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("72", 72, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("73", 73, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("74", 74, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("75", 75, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("76", 76, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("77", 77, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("78", 78, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("79", 79, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("80", 80, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("81", 81, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("82", 82, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("83", 83, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("84", 84, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("85", 85, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("86", 86, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("87", 87, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("88", 88, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("89", 89, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("90", 90, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("91", 91, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("92", 92, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("93", 93, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("94", 94, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("95", 95, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("96", 96, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("97", 97, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("98", 98, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("99", 99, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("100", 100, bene, "MuttVille December 2018", false);
    canBatchTwo = false;
  }
  
  function batchThree() onlyOwner {
      require(canBatchThree);
      heritage.createFundraiser("101", 101, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("102", 102, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("103", 103, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("104", 104, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("105", 105, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("106", 106, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("107", 107, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("108", 108, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("109", 109, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("110", 110, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("111", 111, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("112", 112, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("113", 113, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("114", 114, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("115", 115, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("116", 116, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("117", 117, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("118", 118, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("119", 119, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("120", 120, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("121", 121, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("122", 122, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("123", 123, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("124", 124, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("125", 125, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("126", 126, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("127", 127, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("128", 128, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("129", 129, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("130", 130, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("131", 131, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("132", 132, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("133", 133, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("134", 134, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("135", 135, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("136", 136, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("137", 137, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("138", 138, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("139", 139, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("140", 140, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("141", 141, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("142", 142, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("143", 143, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("144", 144, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("145", 145, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("146", 146, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("147", 147, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("148", 148, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("149", 149, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("150", 150, bene, "MuttVille December 2018", false);
      canBatchThree = false;
  }
  
   function batchFour() onlyOwner {
      require(canBatchFour);
      heritage.createFundraiser("151", 151, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("152", 152, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("153", 153, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("154", 154, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("155", 155, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("156", 156, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("157", 157, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("158", 158, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("159", 159, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("160", 160, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("161", 161, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("162", 162, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("163", 163, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("164", 164, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("165", 165, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("166", 166, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("167", 167, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("168", 168, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("169", 169, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("170", 170, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("171", 171, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("172", 172, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("173", 173, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("174", 174, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("175", 175, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("176", 176, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("177", 177, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("178", 178, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("179", 179, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("180", 180, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("181", 181, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("182", 182, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("183", 183, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("184", 184, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("185", 185, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("186", 186, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("187", 187, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("188", 188, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("189", 189, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("190", 190, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("191", 191, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("192", 192, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("193", 193, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("194", 194, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("195", 195, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("196", 196, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("197", 197, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("198", 198, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("199", 199, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("200", 200, bene, "MuttVille December 2018", false);
      canBatchFour = false;
  }
  
   function batchFive() onlyOwner {
      require(canBatchFive);
      heritage.createFundraiser("201", 201, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("202", 202, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("203", 203, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("204", 204, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("205", 205, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("206", 206, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("207", 207, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("208", 208, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("209", 209, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("210", 210, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("211", 211, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("212", 212, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("213", 213, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("214", 214, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("215", 215, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("216", 216, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("217", 217, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("218", 218, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("219", 219, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("220", 220, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("221", 221, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("222", 222, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("223", 223, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("224", 224, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("225", 225, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("226", 226, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("227", 227, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("228", 228, bene, "MuttVille December 2018", false);
      heritage.createFundraiser("229", 229, bene, "MuttVille December 2018", false);
      canBatchFive = false;
  }
  
}
