String formatPrice(double price, [int decimals = 2]) =>
    price.toStringAsFixed(decimals).replaceFirst(RegExp(r'\.?0*$'), '');
