//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * SPDX-Licenses-Identifier: MIT
 * Basic trigonometry functions
 *
 * Based on the Trigonometry Library by Lefteris Karapetsas:
 * https://github.com/Sikorkaio/sikorka/blob/master/contracts/trigonometry.sol
 * 
 * This version implements a 32-bit lookup tables instead of a 16-bit. This
 * allows accurate topological operations on small areas with very close coordinates.
 *
 * @author Daniel Serrano
 */

library Trigonometry {

    // Table index into the trigonometric table
    uint constant INDEX_WIDTH = 8;
    // Interpolation between successive entries in the tables
    uint constant INTERP_WIDTH = 16;
    uint constant INDEX_OFFSET = 28 - INDEX_WIDTH;
    uint constant INTERP_OFFSET = INDEX_OFFSET - INTERP_WIDTH;
    uint32 constant ANGLES_IN_CYCLE = 1073741824;
    uint32 constant QUADRANT_HIGH_MASK = 536870912;
    uint32 constant QUADRANT_LOW_MASK = 268435456;
    uint constant SINE_TABLE_SIZE = 256;

    // constant sine lookup table generated by gen_tables.py
    // We have no other choice but this since constant arrays don't yet exist
    uint8 constant entry_bytes = 4;
    bytes constant sin_table = "\x00\x00\x00\x00\x00\xc9\x0f\x88\x01\x92\x1d\x20\x02\x5b\x26\xd7\x03\x24\x2a\xbf\x03\xed\x26\xe6\x04\xb6\x19\x5d\x05\x7f\x00\x35\x06\x47\xd9\x7c\x07\x10\xa3\x45\x07\xd9\x5b\x9e\x08\xa2\x00\x9a\x09\x6a\x90\x49\x0a\x33\x08\xbc\x0a\xfb\x68\x05\x0b\xc3\xac\x35\x0c\x8b\xd3\x5e\x0d\x53\xdb\x92\x0e\x1b\xc2\xe4\x0e\xe3\x87\x66\x0f\xab\x27\x2b\x10\x72\xa0\x48\x11\x39\xf0\xcf\x12\x01\x16\xd5\x12\xc8\x10\x6e\x13\x8e\xdb\xb1\x14\x55\x76\xb1\x15\x1b\xdf\x85\x15\xe2\x14\x44\x16\xa8\x13\x05\x17\x6d\xd9\xde\x18\x33\x66\xe8\x18\xf8\xb8\x3c\x19\xbd\xcb\xf3\x1a\x82\xa0\x25\x1b\x47\x32\xef\x1c\x0b\x82\x6a\x1c\xcf\x8c\xb3\x1d\x93\x4f\xe5\x1e\x56\xca\x1e\x1f\x19\xf9\x7b\x1f\xdc\xdc\x1b\x20\x9f\x70\x1c\x21\x61\xb3\x9f\x22\x23\xa4\xc5\x22\xe5\x41\xaf\x23\xa6\x88\x7e\x24\x67\x77\x57\x25\x28\x0c\x5d\x25\xe8\x45\xb6\x26\xa8\x21\x85\x27\x67\x9d\xf4\x28\x26\xb9\x28\x28\xe5\x71\x4a\x29\xa3\xc4\x85\x2a\x61\xb1\x01\x2b\x1f\x34\xeb\x2b\xdc\x4e\x6f\x2c\x98\xfb\xba\x2d\x55\x3a\xfb\x2e\x11\x0a\x62\x2e\xcc\x68\x1e\x2f\x87\x52\x62\x30\x41\xc7\x60\x30\xfb\xc5\x4d\x31\xb5\x4a\x5d\x32\x6e\x54\xc7\x33\x26\xe2\xc2\x33\xde\xf2\x87\x34\x96\x82\x4f\x35\x4d\x90\x56\x36\x04\x1a\xd9\x36\xba\x20\x13\x37\x6f\x9e\x46\x38\x24\x93\xb0\x38\xd8\xfe\x93\x39\x8c\xdd\x32\x3a\x40\x2d\xd1\x3a\xf2\xee\xb7\x3b\xa5\x1e\x29\x3c\x56\xba\x70\x3d\x07\xc1\xd5\x3d\xb8\x32\xa5\x3e\x68\x0b\x2c\x3f\x17\x49\xb7\x3f\xc5\xec\x97\x40\x73\xf2\x1d\x41\x21\x58\x9a\x41\xce\x1e\x64\x42\x7a\x41\xd0\x43\x25\xc1\x35\x43\xd0\x9a\xec\x44\x7a\xcd\x50\x45\x24\x56\xbc\x45\xcd\x35\x8f\x46\x75\x68\x27\x47\x1c\xec\xe6\x47\xc3\xc2\x2e\x48\x69\xe6\x64\x49\x0f\x57\xee\x49\xb4\x15\x33\x4a\x58\x1c\x9d\x4a\xfb\x6c\x97\x4b\x9e\x03\x8f\x4c\x3f\xdf\xf3\x4c\xe1\x00\x34\x4d\x81\x62\xc3\x4e\x21\x06\x17\x4e\xbf\xe8\xa4\x4f\x5e\x08\xe2\x4f\xfb\x65\x4c\x50\x97\xfc\x5e\x51\x33\xcc\x94\x51\xce\xd4\x6e\x52\x69\x12\x6e\x53\x02\x85\x17\x53\x9b\x2a\xef\x54\x33\x02\x7d\x54\xca\x0a\x4a\x55\x60\x40\xe2\x55\xf5\xa4\xd2\x56\x8a\x34\xa9\x57\x1d\xee\xf9\x57\xb0\xd2\x55\x58\x42\xdd\x54\x58\xd4\x0e\x8c\x59\x64\x64\x97\x59\xf3\xde\x12\x5a\x82\x79\x99\x5b\x10\x35\xce\x5b\x9d\x11\x53\x5c\x29\x0a\xcc\x5c\xb4\x20\xdf\x5d\x3e\x52\x36\x5d\xc7\x9d\x7b\x5e\x50\x01\x5d\x5e\xd7\x7c\x89\x5f\x5e\x0d\xb2\x5f\xe3\xb3\x8d\x60\x68\x6c\xce\x60\xec\x38\x2f\x61\x6f\x14\x6b\x61\xf1\x00\x3e\x62\x71\xfa\x68\x62\xf2\x01\xac\x63\x71\x14\xcc\x63\xef\x32\x8f\x64\x6c\x59\xbf\x64\xe8\x89\x25\x65\x63\xbf\x91\x65\xdd\xfb\xd2\x66\x57\x3c\xbb\x66\xcf\x81\x1f\x67\x46\xc7\xd7\x67\xbd\x0f\xbc\x68\x32\x57\xaa\x68\xa6\x9e\x80\x69\x19\xe3\x1f\x69\x8c\x24\x6b\x69\xfd\x61\x4a\x6a\x6d\x98\xa3\x6a\xdc\xc9\x64\x6b\x4a\xf2\x78\x6b\xb8\x12\xd0\x6c\x24\x29\x5f\x6c\x8f\x35\x1b\x6c\xf9\x34\xfb\x6d\x62\x27\xf9\x6d\xca\x0d\x14\x6e\x30\xe3\x49\x6e\x96\xa9\x9c\x6e\xfb\x5f\x11\x6f\x5f\x02\xb1\x6f\xc1\x93\x84\x70\x23\x10\x99\x70\x83\x78\xfe\x70\xe2\xcb\xc5\x71\x41\x08\x04\x71\x9e\x2c\xd1\x71\xfa\x39\x48\x72\x55\x2c\x84\x72\xaf\x05\xa6\x73\x07\xc3\xcf\x73\x5f\x66\x25\x73\xb5\xeb\xd0\x74\x0b\x53\xfa\x74\x5f\x9d\xd0\x74\xb2\xc8\x83\x75\x04\xd3\x44\x75\x55\xbd\x4b\x75\xa5\x85\xce\x75\xf4\x2c\x0a\x76\x41\xaf\x3c\x76\x8e\x0e\xa5\x76\xd9\x49\x88\x77\x23\x5f\x2c\x77\x6c\x4e\xda\x77\xb4\x17\xdf\x77\xfa\xb9\x88\x78\x40\x33\x28\x78\x84\x84\x13\x78\xc7\xab\xa1\x79\x09\xa9\x2c\x79\x4a\x7c\x11\x79\x8a\x23\xb0\x79\xc8\x9f\x6d\x7a\x05\xee\xac\x7a\x42\x10\xd8\x7a\x7d\x05\x5a\x7a\xb6\xcb\xa3\x7a\xef\x63\x23\x7b\x26\xcb\x4e\x7b\x5d\x03\x9d\x7b\x92\x0b\x88\x7b\xc5\xe2\x8f\x7b\xf8\x88\x2f\x7c\x29\xfb\xed\x7c\x5a\x3d\x4f\x7c\x89\x4b\xdd\x7c\xb7\x27\x23\x7c\xe3\xce\xb1\x7d\x0f\x42\x17\x7d\x39\x80\xeb\x7d\x62\x8a\xc5\x7d\x8a\x5f\x3f\x7d\xb0\xfd\xf7\x7d\xd6\x66\x8e\x7d\xfa\x98\xa7\x7e\x1d\x93\xe9\x7e\x3f\x57\xfe\x7e\x5f\xe4\x92\x7e\x7f\x39\x56\x7e\x9d\x55\xfb\x7e\xba\x3a\x38\x7e\xd5\xe5\xc5\x7e\xf0\x58\x5f\x7f\x09\x91\xc3\x7f\x21\x91\xb3\x7f\x38\x57\xf5\x7f\x4d\xe4\x50\x7f\x62\x36\x8e\x7f\x75\x4e\x7f\x7f\x87\x2b\xf2\x7f\x97\xce\xbc\x7f\xa7\x36\xb3\x7f\xb5\x63\xb2\x7f\xc2\x55\x95\x7f\xce\x0c\x3d\x7f\xd8\x87\x8d\x7f\xe1\xc7\x6a\x7f\xe9\xcb\xbf\x7f\xf0\x94\x77\x7f\xf6\x21\x81\x7f\xfa\x72\xd0\x7f\xfd\x88\x59\x7f\xff\x62\x15\x7f\xff\xff\xff";
    /**
     * Convenience function to apply a mask on an integer to extract a certain
     * number of bits. Using exponents since solidity still does not support
     * shifting.
     *
     * @param _value The integer whose bits we want to get
     * @param _width The width of the bits (in bits) we want to extract
     * @param _offset The offset of the bits (in bits) we want to extract
     * @return An integer containing _width bits of _value starting at the
     *         _offset bit
     */
    function bits(uint _value, uint _width, uint _offset) pure internal returns (uint) {
        return (_value / (2 ** _offset)) & (((2 ** _width)) - 1);
    }

    function sin_table_lookup(uint index) pure internal returns (uint32) {
        bytes memory table = sin_table;
        uint offset = (index + 1) * entry_bytes;
        uint32 trigint_value;
        assembly {
            trigint_value := mload(add(table, offset))
        }

        return trigint_value;
    }

    /**
     * Return the sine of an integer approximated angle as a signed 16-bit
     * integer.
     *
     * @param _angle A 30-bit angle. This divides the circle into 1073741824
     *               angle units, instead of the standard 360 degrees.
     * @return The sine result as a number in the range -2147483647 to 2147483647.
     */
    function sin(uint256 _angle) public pure returns (int) {
        uint interp = bits(_angle, INTERP_WIDTH, INTERP_OFFSET);
        uint index = bits(_angle, INDEX_WIDTH, INDEX_OFFSET);

        bool is_odd_quadrant = (_angle & QUADRANT_LOW_MASK) == 0;
        bool is_negative_quadrant = (_angle & QUADRANT_HIGH_MASK) != 0;

        if (!is_odd_quadrant) {
            index = SINE_TABLE_SIZE - 1 - index;
        }

        uint x1 = sin_table_lookup(index);
        uint x2 = sin_table_lookup(index + 1);
        uint approximation = ((x2 - x1) * interp) / (2 ** INTERP_WIDTH);

        int sine;
        if (is_odd_quadrant) {
            sine = int(x1) + int(approximation);
        } else {
            sine = int(x2) - int(approximation);
        }

        if (is_negative_quadrant) {
            sine *= -1;
        }

        return sine;
    }

    /**
     * Return the cos of an integer approximated angle.
     * It functions just like the sin() method but uses the trigonometric
     * identity sin(x + pi/2) = cos(x) to quickly calculate the cos.
     */
    function cos(uint32 _angle) public pure returns (int) {
        if (_angle > ANGLES_IN_CYCLE - QUADRANT_LOW_MASK) {
            _angle = QUADRANT_LOW_MASK - ANGLES_IN_CYCLE - _angle;
        } else {
            _angle += QUADRANT_LOW_MASK;
        }
        return sin(_angle);
    }

}
