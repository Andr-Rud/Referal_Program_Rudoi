const { expect } = require("chai");
const { ethers } = require("hardhat");
const { Contract } = require("hardhat/internal/hardhat-network/stack-traces/model");

describe("ClientInfo", function() {
    let acc1;
    let acc2;
    let clientInfo;
    let referalTree;

    beforeEach(async function() {
        [acc1, acc2] = await ethers.getSigners();

        const ClientInfo = await ethers.getContractFactory("ClientInfo", acc1);
        clientInfo = await ClientInfo.deploy();
        await clientInfo.deployed();

        const ReferalTree = await ethers.getContractFactory("ReferalTree", acc1);
        referalTree = await ReferalTree.deploy();
        await referalTree.deployed();

        await clientInfo.initialize(referalTree.address)
    })

    it("ClientInfo.sol should be deployed", async function() {
        expect(clientInfo.address).to.be.properAddress;
    })

    it("ReferalTree.sol should be deployed", async function() {
        expect(referalTree.address).to.be.properAddress;
    })

    it("Zero balance after init", async function() {
        expect(await clientInfo.getMyBalance()).to.equal(0);
    })

})