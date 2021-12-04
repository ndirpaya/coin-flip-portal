// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract CoinFlipPortal {
    uint256 totalFlips;

    /*
    *   help generate a random number
     */
    uint256 private seed;

    constructor() payable {
        console.log("Hello, Smart here with the contract!");

        seed = (block.timestamp + block.difficulty) % 1000;
    }

    event NewFlip(address indexed from, string wish, string side, uint256 timestamp);

    struct Flip {
        address wisher; // address of the user that made a wish.
        string wish; // The wish the user made.
        string side; // The side of coin the user got, Heads or Tails.
        uint256 timestamp; // The timestamp when the user made the wish.
    }

    /*
    *   varaible flips that stores an array of structs.
    *   This holds all the coin flips anyone ever sends.   
    */
    Flip[] flips;

    /*
    *   map address to last time the user flipped a coin. for cooldown.
     */
    mapping(address => uint256) public lastFlippedAt;

    function flipCoin(string memory _wish) public {
        /*
        *    make sure the current timestamp is at least x-minutes bigger than the last timestamp stored
        */
        require(
            lastFlippedAt[msg.sender] + 1 minutes < block.timestamp,
            "Wait a minute."
        );

        lastFlippedAt[msg.sender] = block.timestamp;

        totalFlips += 1;
        string memory side;
        console.log("%s has flipped a coin", msg.sender);

        seed = (block.difficulty + block.timestamp + seed) % 2;
        console.log(seed);

        if (seed == 0) {
            side = 'Heads';
        } else {
            side = 'Tails';
        }

        /*
        *   Store the data in the array
        */
        flips.push(Flip(msg.sender, _wish, side, block.timestamp));

        /*
        *   fire event when a new flip happens.
        */
        emit NewFlip(msg.sender, _wish, side, block.timestamp);  

        uint256 prizeAmount = 0.0001 ether;

        if (keccak256(abi.encodePacked(side)) == keccak256(abi.encodePacked('Tails'))){
            require(
                prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has."
            );
            console.log("you flipped %s no wish but you get %d in compensation", side, prizeAmount);
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw monery from contract");
        } else {
            console.log("you flipped %s no compensation for you", side);
        }
    }

    /*
    *   getAllFlips returns the struct array, fips.
    *   This will make it easy to retrieve the flips from the website.
    */
    function getAllFlips() public view returns (Flip[] memory) {
        return flips;
    }
    

    function getTotalFlips() public view returns (uint256) {
        console.log("We have %d total coin flips!", totalFlips);
        return totalFlips;
    }
}