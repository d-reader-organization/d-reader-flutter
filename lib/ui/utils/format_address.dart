String formatAddress(String address, [int end = 6]) =>
    '${address.substring(0, end)}...${address.substring(address.length - end, address.length)}';
String formatWalletLabel(String label, [int end = 12]) => label.isNotEmpty
    ? '(${label.length > 12 ? label.substring(0, 12) : label})'
    : '';
