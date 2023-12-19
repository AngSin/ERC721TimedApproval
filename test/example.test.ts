import {ethers, network} from "hardhat";
import {expect} from "chai";

describe('ERC721TimedApproval', () => {
	const increaseTime = async(seconds: number) => {
		await network.provider.send('evm_increaseTime', [seconds]);
		await network.provider.send('evm_mine', []);
	}

	it('should only let operator transfer NFTs within the transfer approval time limit', async () => {
		const [owner, operator] = await ethers.getSigners();
		const ExampleNFTContractFactory = await ethers.getContractFactory("Example");
		const exampleNftContract = await ExampleNFTContractFactory.deploy();
		// fool-safe check, 10 should be minted
		expect(await exampleNftContract.balanceOf(owner.address)).to.equal(10);

		await exampleNftContract.setApprovalForAll(operator.address, true);
		expect(await exampleNftContract.isApprovedForAll(owner.address, operator.address)).to.equal(true);

		await exampleNftContract.connect(operator).transferFrom(owner.address, operator.address, 1);
		expect(await exampleNftContract.balanceOf(owner.address)).to.equal(9);
		expect(await exampleNftContract.balanceOf(operator.address)).to.equal(1);
		await increaseTime(Number((await exampleNftContract.defaultApprovalTimePeriod()).toString()));
		await expect (exampleNftContract.connect(operator).transferFrom(owner.address, operator.address, 2))
			.to.be.revertedWithCustomError(exampleNftContract, 'ERC721InsufficientApproval');

		// an operator's timePeriod overrides the default time period
		await exampleNftContract.setApprovalForAll(operator.address, true);
		const timeIn1Hour = 60 * 60;
		await exampleNftContract.setOperatorApprovalTimePeriod(operator.address, timeIn1Hour);
		await increaseTime(Number(timeIn1Hour.toString()));
		await expect (exampleNftContract.connect(operator).transferFrom(owner.address, operator.address, 2))
			.to.be.revertedWithCustomError(exampleNftContract, 'ERC721InsufficientApproval');
	});
});