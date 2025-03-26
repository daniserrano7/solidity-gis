# Solidity GIS: On-Chain Geospatial Data Management

This work is some work I did during my time at Astral Protocol in collaboration with [Holly Grimm](https://github.com/hollygrimm), where I contributed to building tools for the decentralized geospatial web. While this is only a portion of the larger and unfinished project, it demonstrates some of the most technically challenging aspects I worked on, particularly around implementing complex geometric calculations in Solidity.

A pioneering project that brings geospatial data management to the Ethereum blockchain, featuring advanced trigonometric calculations and polygon area computations that take into account Earth's curvature.

## Purpose and Motivation

The integration of blockchain technology with Geographic Information Systems (GIS) opens up new possibilities for spatial data management:

- **Verifiable Geographic Claims**: Through GeoNFTs, users can make verifiable claims about geographic areas, which can be used for land registry, property rights, or environmental monitoring
- **Decentralized Spatial Data**: Geographic data can be stored and managed in a decentralized manner, reducing reliance on centralized authorities
- **Transparent Area Calculations**: The implementation of precise area calculations on-chain ensures transparency and verifiability of geographic measurements
- **Spatial Smart Contracts**: Enables the creation of location-based smart contracts that can respond to geographic conditions or events

## Overview

This project implements a sophisticated system for managing geospatial data on the Ethereum blockchain through smart contracts. It introduces the concept of GeoNFTs (Geographic Non-Fungible Tokens) that can represent real-world geographic areas, complete with accurate area calculations that consider Earth's spherical nature.

## Key Features

- **GeoNFT Implementation**: ERC721-based tokens that can represent geographic areas
- **Spatial Data Registry**: A registry system for managing and querying GeoNFTs
- **Advanced Trigonometry**: Custom implementation of trigonometric functions in Solidity
- **Spherical Area Calculations**: Accurate area computations that account for Earth's curvature
- **Polygon and MultiPolygon Support**: Handles complex geographic shapes including holes and multiple polygons
- **Geohash Encoding**: Efficient encoding system for geographic coordinates that enables hierarchical spatial indexing

## Technical Challenges

### 1. Trigonometric Calculations in Solidity

One of the most significant challenges was implementing trigonometric functions in Solidity, which doesn't natively support floating-point arithmetic. The solution involved:

- Creating a custom lookup table for sine values
- Implementing interpolation between table entries
- Using fixed-point arithmetic with appropriate scaling factors
- Handling quadrant-specific calculations

### 2. Spherical Area Calculations

The project implements the geodesic area calculation algorithm (based on Turf.js), which requires:

- Converting geographic coordinates to radians
- Applying spherical trigonometry formulas
- Managing precision and numerical stability
- Handling complex polygon cases (holes, multiple polygons)

### 3. Geohash Implementation

The project includes a sophisticated geohash system that:

- Encodes latitude and longitude coordinates into a single string
- Provides hierarchical spatial indexing capabilities
- Enables efficient spatial queries and proximity searches
- Supports variable precision levels for different use cases
- Facilitates the creation of spatial indexes for blockchain-based GIS applications

## Architecture

The project consists of three main smart contracts:

1. **GeoNFT.sol**: The base ERC721 contract that represents geographic areas as NFTs
2. **Trigonometry.sol**: A library providing trigonometric functions with high precision
3. **SDRegistry.sol**: The spatial data registry that manages GeoNFTs and provides spatial queries
4. **GeohashRegistry.sol**: A specialized registry for managing geohash-based spatial data

## Implementation Details

### Trigonometric Library

The `Trigonometry.sol` library implements:

- 32-bit lookup tables for improved precision
- Interpolation between table entries
- Support for both sine and cosine functions
- Proper handling of all quadrants

### Area Calculations

The area calculation implementation:

- Supports both polygons and multipolygons
- Handles holes in polygons (negative areas)
- Uses geodesic measurements (accounts for Earth's curvature)
- Maintains precision through fixed-point arithmetic

### Geohash System

The geohash implementation provides:

- Base32 encoding for efficient coordinate representation
- Hierarchical spatial indexing capabilities
- Support for variable precision levels
- Methods for calculating geohash neighbors and bounding boxes
- Integration with the spatial data registry for efficient queries

## Author

Daniel Serrano - Former part of the Astral Protocol team (https://github.com/AstralProtocol)

## License

MIT License
