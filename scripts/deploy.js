async function main() {
    const ReferalTree = await ethers.getContractFactory('ReferalTree');
    console.log('Deploying ReferalTree...');
    const referalTree = await ReferalTree.deploy();
    await referalTree.deployed();
    console.log('ReferalTree deployed to:', referalTree.address);

    const ClientInfo = await ethers.getContractFactory('ClientInfo');
    console.log('Deploying ClientInfo...');
    const clientInfo = await ClientInfo.deploy();
    await clientInfo.deployed();
    console.log('ClientInfo deployed to:', clientInfo.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });