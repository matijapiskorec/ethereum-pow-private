
# Run the PoweShell as an administrator and run this command to enable execution of custom scripts: 
# Set-ExecutionPolicy RemoteSigned
# Position yourself in your user directory (replace USERNAME with your own):
# cd C:\Users\USERNAME\
# Make a local directory for the installation and blockchain data:
# mkdir ethereum-pow-private
# cd ethereum-pow-private
# Download the ethereum-pow-private.ps1 script:
# Invoke-WebRequest "https://raw.githubusercontent.com/matijapiskorec/ethereum-pow-private/refs/heads/main/ethereum-pow-private.ps1" -UseBasicParsing -OutFile "ethereum-pow-private.ps1"
# Now you can run the script:
# .\ethereum-pow-private.ps1
# Allow network access if Windows Firewall prompts you, usually after you run the node.
# To attach to the interactive Javascript console run the donwloaded geth.exe binary with the following parameters:
# .\geth.exe --datadir blockchain attach http://localhost:8545

$gethVersion = "geth-windows-amd64-1.10.15-8be800ff"

if (!$args[0]) { 
    Write-Host "Install and run your own private Ethereum PoW node"
    Write-Host "Usage instructions:"
    Write-Host "    .\ethereum-pow-private.ps1 download - download geth and neccessary files"
    Write-Host "    .\ethereum-pow-private.ps1 init - initialize geth for the private Ethereum PoW network"
    Write-Host "    .\ethereum-pow-private.ps1 run - run private Ethereum PoW node"
    Write-Host "    .\ethereum-pow-private.ps1 run ETHERBASE - run private Ethereum PoW node that mines on the ETHERBASE address"
} else {
    switch ( $args[0] ) {
        "download" {
            Write-Host "Downloading Go Ethereum client for Windows..."
            Start-Sleep -Seconds 2 
            Invoke-WebRequest "https://gethstore.blob.core.windows.net/builds/$gethVersion.zip" -OutFile "$gethVersion.zip"
            Expand-Archive -Path "$gethVersion.zip"
            Copy-Item "$gethVersion\$gethVersion\geth.exe" -Destination "."
            Write-Host "Downloading genesis template file and static node file for private Ethereum PoW network..."
            Start-Sleep -Seconds 2 
            Invoke-WebRequest "https://raw.githubusercontent.com/matijapiskorec/ethereum-pow-private/refs/heads/main/genesis.json" -OutFile "genesis.json"
            Invoke-WebRequest "https://raw.githubusercontent.com/matijapiskorec/ethereum-pow-private/refs/heads/main/static-nodes.json" -OutFile "static-nodes.json"
            break
        }
	"init" {
            Write-Host "Initializing private Ethereum PoW node..."
            Start-Sleep -Seconds 2 
            .\geth.exe --datadir blockchain init uzheth.json
            Copy-Item "static-nodes.json" -Destination "blockchain\geth"
            break
        }
        "run" {
            if (!$args[1]) { 
                Write-Host "Running private Ethereum PoW node..."
                Start-Sleep -Seconds 2 
                .\geth.exe --datadir blockchain --http --http.port 8545 --http.corsdomain "*" --http.vhosts "*" --http.api miner,eth,admin,net,web3 --networkid 20250115 --syncmode "full" --http.addr 0.0.0.0 
            } else {
                $etherbase = $args[1]
                Write-Host "Running private Ethereum PoW node and miner using $etherbase as an Etherbase argument..."
                Start-Sleep -Seconds 2 
                .\geth.exe --datadir blockchain --http --http.port 8545 --http.corsdomain "*" --http.vhosts "*" --http.api miner,eth,admin,net,web3 --networkid 20250115 --syncmode "full" --http.addr 0.0.0.0 --mine --miner.threads=1 --miner.etherbase="$etherbase"
            }
            break
        }
    }
}
