String formatAddress(String address, [int end = 6]) =>
    '${address.substring(0, end)}...${address.substring(address.length - end, address.length)}';
