String formatAddress(String address, [int end = 6]) =>
    '${address.substring(0, end)}...${address.substring(address.length - end, address.length)}';
String formatWalletName(String name, [int end = 12]) => name.isNotEmpty
    ? '(${name.length > 12 ? name.substring(0, 12) : name})'
    : '';
