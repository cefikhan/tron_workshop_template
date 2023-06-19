var StringUtil = artifacts.require("./StringUtil.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var TWS = artifacts.require("./TWS.sol");

module.exports = function(deployer) {
  deployer.deploy(StringUtil);
  deployer.deploy(SafeMath);
  deployer.link(SafeMath,StringUtil, TWS);

  deployer.deploy(TWS);
};
