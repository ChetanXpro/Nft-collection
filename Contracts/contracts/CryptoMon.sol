// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoMon is ERC721Enumerable, Ownable {
    string _baseTokenURI;

    bool public presaleStarted;

    IWhitelist whitelist;

    uint256 public presaleEnded;

    uint256 public maxTokenIds = 30;

    uint256 public tokenIds;

    uint256 public _price = 0.001 ether;

    bool public _paused;

    modifier onlyWhennotPaused() {
        require(!_paused, "Contract currently pause");
        _;
    }

    constructor(string memory baseURI, address whitelistedContract)
        ERC721("CryptoMon", "CM")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistedContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhennotPaused {
        require(presaleStarted, "Presale is Not started");
        require(block.timestamp < presaleEnded, "Presale is ended");
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(maxTokenIds > tokenIds, "Exceeded the limit");
        require(msg.value >= _price, "Please send correct amount of ether");

        tokenIds += 1;

        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhennotPaused {
        require(
            presaleStarted && block.timestamp >= presaleEnded,
            "Presale has not ended yet"
        );
        require(maxTokenIds > tokenIds, "Exceed the limit");

        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool send, ) = _owner.call{value: amount}("");
        require(send, "Failed to send Ether");
    }

    receive() external payable {}

    fallback() external payable {}
}
