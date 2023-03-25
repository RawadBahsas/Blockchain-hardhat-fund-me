// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// library PriceConverter {
//     function getPrice(
//         AggregatorV3Interface priceFeed
//     ) internal view returns (uint256) {
//         // ABI from npm interface
//         //Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
//         // AggregatorV3Interface priceFeed = AggregatorV3Interface(
//         //     0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
//         // );
//         (, int256 price, , , ) = priceFeed.latestRoundData();
//         //int256 dec = int8(priceFeed.decimals());
//         return uint256(price * (10 ** 8));
//     }

//     function getConversionRate(
//         uint256 ethAmount,
//         AggregatorV3Interface priceFeed
//     ) internal view returns (uint256) {
//         //int256 dec = 10 ^ int8(priceFeed.decimals());
//         uint256 ethPrice = getPrice(priceFeed);
//         uint256 ethAmountiInUsd = ((ethPrice * ethAmount) / 10000000000000000);
//         return ethAmountiInUsd;
//     }
// }
library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    // 1000000000
    // call it get fiatConversionRate, since it assumes something about decimals
    // It wouldn't work for every aggregator
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}
