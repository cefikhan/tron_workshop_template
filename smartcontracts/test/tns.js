var wait = require('./helpers/wait')
var chalk = require('chalk')
var TWS = artifacts.require("./TWS.sol");

let tws



contract('TWS', function (accounts) {

before(async function () {

  tws = await TWS.deployed()
  if(accounts.length < 3) {
    // Set your own accounts if you are not using Tron Quickstart

  }
})

it("should verify that there are at least three available accounts", async function () {
  if(accounts.length < 3) {
    console.log(chalk.blue('\nYOUR ATTENTION, PLEASE.]\nTo test MetaCoin you should use Tron Quickstart (https://github.com/tronprotocol/docker-tron-quickstart) as your private network.\nAlternatively, you must set your own accounts in the "before" statement in "test/metacoin.js".\n'))
  }
  assert.isTrue(accounts.length >= 3)
})

it("should verify that the contract has been deployed by accounts[0]", async function () {
  assert.equal(await tws.owner(), tronWeb.address.toHex(accounts[0]))
});

it("should set top level domain \"eth\" ",async function(){
  let tx = await tws.setTLD("eth")  
  tx = await tws.isTLD("eth")  
  expect(tx).to.equal(true)    
})

it("should register a domain on top of tld", async function () {

  let tx = await tws.setTLD("eth")  
  tx = await tws.registerDomain(tronWeb.address.toHex(accounts[0]),"saffi","eth");
  tx = await tws.registerDomain(tronWeb.address.toHex(accounts[0]),"ali","eth");
});


it("should get owner of domain via tokenID",async function(){

  let tx = await tws.setTLD("eth")  
  tx = await tws.registerDomain(tronWeb.address.toHex(accounts[0]),"saffi","eth");
  ownerAddress = await tws.getOwner("saffi.eth");
  expect(ownerAddress).to.equal(tronWeb.address.toHex(accounts[0]));
})



it("should get price",async function(){
  let price = await tws.getPrice()  
  expect(price.toNumber()).to.equal(1)
})


it("should buy Domain",async function(){

  let tx = await tws.setBookingListActive()  
   tx = await tws.setWhiteListActive()  
   tx = await tws.setTLD("eth")   
  tx = await tws.registerDomain(tronWeb.address.toHex(accounts[0]),"saffi","eth");
  tx = await tws.addWhiteList(tronWeb.address.toHex(accounts[0]),1);
  const options = {value: 1}
  tx = await tws.buyDomain("alikhan","eth",options)  
  
})



})