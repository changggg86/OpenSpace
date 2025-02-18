// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20WithHook.sol";
import "./MyERC721.sol";

contract NFTMarket is ITokenReceiver {
    BaseERC20WithHook public token;
    MyERC721 public nft;

    struct Listing {
        uint256 price;
        address seller;
    }

    mapping(uint256 => Listing) public listings;

    event Listed(uint256 indexed tokenId, uint256 price, address indexed seller);
    event Purchased(uint256 indexed tokenId, uint256 price, address indexed buyer);

    constructor(BaseERC20WithHook _token, MyERC721 _nft) {
        token = _token;
        nft = _nft;
    }

    function list(uint256 tokenId, uint256 price) public {
        require(nft.ownerOf(tokenId) == msg.sender, "Only NFT owner can list");
        require(price > 0, "Price must be greater than zero");
        listings[tokenId] = Listing(price, msg.sender);
        emit Listed(tokenId, price, msg.sender);
    }

    function buyNFT(address buyer, uint256 tokenId) public {
        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "NFT is not listed for sale");

        uint256 price = listing.price;
        address seller = listing.seller;

        // require(token.balanceOf(buyer) >= price, "Buyer does not have enough tokens");

        nft.safeTransferFrom(seller, buyer, tokenId);
        token.transfer(seller, price);
        delete listings[tokenId];
        emit Purchased(tokenId, price, buyer);
    }

    function tokensReceived(address from, uint256 amount, bytes calldata data) external override {
        require(msg.sender == address(token), "Unauthorized token");
        uint256 tokenId = abi.decode(data, (uint256));
        require(tokenId > 0, "Invalid Token ID");
        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "NFT is not listed for sale");
        buyNFT(from, tokenId);
        if (amount > listing.price) {
            token.transfer(from, amount - listing.price);
        }
    }

}