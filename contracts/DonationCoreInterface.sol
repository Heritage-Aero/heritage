

contract DonationCoreInterface {
  function name() external pure returns (string _name);
  function symbol() external pure returns (string _symbol);
  function getDonation(uint32 _id) external view returns (uint32 _originalDonationId, uint32 _donationId, string _description, uint128 _goal, uint128 _raised, uint128 _amount, address _beneficiary, address _donor, string _taxId);
  function totalDonationsCreated() external view returns (uint256 _totalDonations);
  function totalDonationsMade() external view returns (uint256 _totalDonations);
  function totalDonationsIssued() external view returns (uint256 _totalDonations);
  function proxyDonation(uint32 _donationId, address _donor) public;
  function createDonationProxy(uint32 _donationId) public returns (address proxyAddress);
  function _createDonation(string _description, uint128 _goal, address _beneficiary, string _taxId) internal returns (uint256);
  function _makeDonation(uint32 _donationId, uint128 _amount, address _donor) internal returns (uint256);
  function _issueDonation(uint32 _donationId, uint128 _amount, address _donor) internal returns (uint256);
  function _deleteDonation(uint32 _donationId) internal;
}
