import 'package:solana/solana.dart' show lamportsPerSol;

String formatPrice(double price, [int decimals = 2]) =>
    price.toStringAsFixed(decimals).replaceFirst(RegExp(r'\.?0*$'), '');

double? formatLamportPrice(int? price, [int decimals = 2]) => price != null
    ? double.tryParse((price / lamportsPerSol)
        .toStringAsFixed(decimals)
        .replaceFirst(RegExp(r'\.?0*$'), ''))
    : null;

String formatPriceWithSignificant(int price) {
  double formattedPrice = price / lamportsPerSol;
  if (formattedPrice >= 1) {
    return formattedPrice.toStringAsFixed(2);
  } else {
    String formatted = formattedPrice.toString();
    int index = formatted.indexOf('.') + 1;
    if (index != -1) {
      int numDecimals = formatted.length - index;
      if (numDecimals <= 2) {
        return formatted;
      } else {
        String withoutDot = formatted.substring(index, formatted.length);
        final regex = RegExp(r'[1-9]');
        final indexOfNonZero = withoutDot.indexOf(regex);

        if (indexOfNonZero < 0) {
          return '0';
        }
        return indexOfNonZero < 0
            ? '0'
            : formatted.substring(0, index + indexOfNonZero + 1);
      }
    }
    return formatted;
  }
}
