// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CappedToken is ERC20, Ownable {
    bool public mintingFinished;
    uint256 public immutable MAX_SUPPLY;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupplyTokens // whole tokens (no decimals)
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        MAX_SUPPLY = maxSupplyTokens * 10 ** decimals();
    }

    function mint(address to, uint256 amountTokens) external onlyOwner {
        require(!mintingFinished, "Minting disabled");

        uint256 scaled = amountTokens * 10 ** decimals();
        require(totalSupply() + scaled <= MAX_SUPPLY, "Cap exceeded");

        _mint(to, scaled);
    }

    function finishMinting() external onlyOwner {
        mintingFinished = true;
    }
}
