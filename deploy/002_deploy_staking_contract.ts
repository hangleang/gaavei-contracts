import { DeployFunction } from "hardhat-deploy/types";

import { VERIFICATION_BLOCK_CONFIRMATIONS } from "../utils/constants";

const func: DeployFunction = async ({ getNamedAccounts, deployments, network, run }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const isDev = !network.live;
  const waitConfirmations = network.live ? VERIFICATION_BLOCK_CONFIRMATIONS : undefined;

  let wrappedEthAddress: string;
  let rewardTokenAddress: string;
  if (isDev) {
    // deploy mocks/test contract
    const wrappedEth = await deploy("TestWrappedEth", { from: deployer, log: true, autoMine: true });
    const rewardToken = await deploy("TestRewardToken", { from: deployer, log: true, autoMine: true });
    wrappedEthAddress = wrappedEth.address;
    rewardTokenAddress = rewardToken.address;
  } else {
    // set external contract address
    wrappedEthAddress = "0x0000000000000000000000000000000000000000";
    rewardTokenAddress = "0x0000000000000000000000000000000000000000";
  }

  const dropAlbumAddres = (await deployments.get("DropAlbum")).address;

  // the following will only deploy "Staking" if the contract was never deployed or if the code changed since last deployment
  const args = [100, 100, dropAlbumAddres, rewardTokenAddress, wrappedEthAddress];
  const staking = await deploy("Staking", {
    from: deployer,
    args,
    log: true,
    autoMine: isDev,
    waitConfirmations,
  });

  // Verify the deployment
  if (!isDev) {
    log("Verifying...");
    await run("verify:verify", {
      address: staking.address,
      constructorArguments: args,
    });
  }
};

export default func;
func.tags = ["all", "Staking"];
func.dependencies = ["DropAlbum"]; // this contains dependencies tags need to execute before deploy this contract
