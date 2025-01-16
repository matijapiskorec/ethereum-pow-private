# Running a private Ethereum Proof-of-Work network

These are instructions for running a private Ethereum Proof-of-Work (PoW) network using `geth` client.

## Creating a Metamask wallet

Install a Metamask browser extension which is available at [https://metamask.io/](https://metamask.io/).

Create a new wallet in Metamask, save the seed phrase, save the account address which you will use later for mining.

Create a custom network and add `http://185.252.234.250:8545` as the default RPC URL.

## Running your own node - Linux and Mac instructions

Download the installation script:
```
wget https://raw.githubusercontent.com/matijapiskorec/ethereum-pow-private/refs/heads/main/ethereum-pow-private.sh
```

Make the script executable:
```
chmod +x ethereum-pow-private.sh
```

Run the script to get the usage instructions:
```
./ethereum-pow-private.sh
```

To initialize the node just execute the following commands:
```
./ethereum-pow-private.sh download linux64
./ethereum-pow-private.sh init
```

**NOTE**: For Mac users replace `linux64` with `mac`!

You can run the node with mining enabled by specifying etherbase address (you can use the Metamask account address which you created earlier):
```
./ethereum-pow-private.sh run "0xB9d84B80FE7eC9c4e73BDbB27639C921085FC0d3"
```

Or you can run the node without mining:
```
./ethereum-pow-private.sh run
```

## Running your own node - Windows instructions

Run the PoweShell as an administrator and run this command to enable execution of custom scripts: 
```
Set-ExecutionPolicy RemoteSigned
```

Position yourself in your user directory (replace USERNAME with your own):
```
cd C:\Users\USERNAME\
```

Make a local directory for the installation and blockchain data:
```
mkdir ethereum-pow-private
cd ethereum-pow-private
```
Download the `ethereum-pow-private.ps1` script:
```
Invoke-WebRequest "https://raw.githubusercontent.com/matijapiskorec/ethereum-pow-private/refs/heads/main/ethereum-pow-private.ps1" -UseBasicParsing -OutFile "ethereum-pow-private.ps1"
```

Now you can run the script to get usage instructions:
```
.\ethereum-pow-private.ps1
```

Otherwise the following commands are similar as for Linux and Mac users:
```
.\ethereum-pow-private.ps1 download
.\ethereum-pow-private.ps1 init
``` 

Finally, run your node in mining mode by providing etherbase address or without mining:
```
./ethereum-pow-private.sh run "0xB9d84B80FE7eC9c4e73BDbB27639C921085FC0d3"
./ethereum-pow-private.sh run
```

Allow network access if Windows Firewall prompts you, usually after you run the node.

## Interacting with the running node

In another terminal run the following command to attach to the running node:
```
./geth --datadir ./blockchain attach http://localhost:8545
```

**NOTE**: Windows users should replace `./geth` with `.\geth.exe`!

You are in interactive Javascript console, you can now interact with the node, for example with the following commands:
```
admin.peers
admin.nodeInfo
eth.blockNumber
eth.syncing
eth.mining
web3.fromWei(eth.getBalance("0x70963f83F6ED8C84e48518987400e52a1E7cf1E8"), "ether")
web3.fromWei(eth.getBalance(eth.coinbase), "ether")
eth.getHeaderByNumber(eth.blockNumber)
```

List all transactions:
```
var latestBlock = eth.blockNumber;

for (var i = 0; i <= latestBlock; i++) {
    var block = eth.getBlock(i, true);
    if (block && block.transactions) {
        block.transactions.forEach(function(tx) {
            console.log("Transaction Hash: " + tx.hash);
            console.log("  From: " + tx.from);
            console.log("  To: " + tx.to);
            console.log("  Value: " + tx.value + " Wei");
            console.log("  Gas: " + tx.gas);
            console.log("  Gas Price: " + tx.gasPrice + " Wei");
            console.log("-----------------------------------");
        });
    }
}
```

## Deploying an ERC-20 token

For deploying an ERC-20 token use the Remix web-based IDE available at [https://remix.ethereum.org/](https://remix.ethereum.org/).

Copy the following code into the Remix editor:
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.9.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";

contract MatijaToken is ERC20, Ownable {
    constructor() ERC20("BlockUpToken", "BLOCKUP")
    {
        _mint(msg.sender, 123 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
```

Change the compiler version to `0.8.18` and compile.

Switch to the `Deploy` tab, change the `Environment` to `Injected provider - Metamask` and deploy your contract.

