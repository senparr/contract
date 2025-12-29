// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CappedToken is ERC20, Ownable {

    // 🔒 Mint control flag (PUT THIS HERE)
    bool public mintingFinished;

    // 🔢 Hard cap
    uint256 public immutable MAX_SUPPLY;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_   // include decimals
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        MAX_SUPPLY = maxSupply_;
    }

    // 🪙 Mint with cap + lock check (REPLACE old mint with this)
    function mint(address to, uint256 amount) external onlyOwner {
        require(!mintingFinished, "Minting disabled");
        require(totalSupply() + amount <= MAX_SUPPLY, "Cap exceeded");
        _mint(to, amount);
    }

    // 🔐 Permanently disable minting
    function finishMinting() external onlyOwner {
        mintingFinished = true;
    }
}
