<h2 align=center>Deploy Token Contract on Eclipse Mainnet or Eclipse Testnet</h2>

## Prerequisite
- You can run this script on [Codespace](https://github.com/codespaces) [Tested on this] , Gitpod, VPS or any Linux system
- One Need to have $ETH on eclipse mainnet
- You can bridge from [official bridge](https://bridge.eclipse.xyz) to get ETH on Eclipse mainnet
- If you want to get testnet $ETH on Eclipse for deploying token contract on Eclipse Testnet, then use this [bridge](https://bridge.validators.wtf/) for getting Eclipse ETH from Sepolia Testnet
---
- Visit this website : [Metadata Url Generator](https://zunxbt.github.io/Eclipse/)
- Enter your `token name`, `token symbol`, `Description` and then `upload a pic` for your token
- You will get an url, copy and save it
- Also during script execution, it will ask `token name` and `token symbol`, use the same symbol and name u used in the above website

## Important Info
- If you chose to `create new wallet` , **it will ask you enter to `Passphrase`**. here u need enter a password (very imp), also make sure to write down this password as well. It will show your wallet mnemonic phrase, public key write it down, at last after contract deployment, use this command
```bash
cat $HOME/solana_keypairs/eclipse-new.json
```
- You will get an output like this [127, 125, 28, ...., 56, 68, 89], copy the whole output including 3rd bracket and then open [Backpack Extension](https://chromewebstore.google.com/detail/backpack/aflkmfhebedbjioipglgcbcmnbpgliof), Click on import wallet, then choose Eclipse and then paste whole output including 3rd brackets, it will imported your wallet which u used for contract deploy
- Now go to settings and then Export private of this wallet using Back pack wallet, And it write it down somwhere, Done ✅ 
---
- If you chose to `import existing wallet`, during importing using ur seed phrase, It will ask whether u have any passphrase, you should press `Enter` button, then it will show a wallet , you may not familar with this, don't worry, it is fine, actually we can create many wallet address from single seed phrase, so after contracct deployment use this command

```bash
cat $HOME/solana_keypairs/eclipse-import.json
```
- You will get an output like this [127, 125, 28, ...., 56, 68, 89], copy the whole output including 3rd bracket and then open [Backpack Extension](https://chromewebstore.google.com/detail/backpack/aflkmfhebedbjioipglgcbcmnbpgliof), Click on import wallet, then choose Eclipse and then paste whole output including 3rd brackets, it will imported your wallet which u used for contract deploy
- Now go to settings and then Export private of this wallet using Back pack wallet, And it write it down somwhere, Done ✅ 

## Installation
- You can use either this command or
```bash
[ -f "eclipse.sh" ] && rm eclipse.sh; wget -q https://raw.githubusercontent.com/zunxbt/Eclipse/refs/heads/main/eclipse.sh && chmod +x eclipse.sh && ./eclipse.sh
```
- this command
```bash
[ -f "eclipse.sh" ] && rm eclipse.sh; curl -s -O https://raw.githubusercontent.com/zunxbt/Eclipse/refs/heads/main/eclipse.sh && chmod +x eclipse.sh && ./eclipse.sh
```
