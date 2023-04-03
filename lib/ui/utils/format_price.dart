import 'package:solana/solana.dart' show lamportsPerSol;

String formatPrice(double price, [int decimals = 2]) =>
    price.toStringAsFixed(decimals).replaceFirst(RegExp(r'\.?0*$'), '');

double? formatLamportPrice(int? price, [int decimals = 2]) => price != null
    ? double.tryParse((price / lamportsPerSol)
        .toStringAsFixed(decimals)
        .replaceFirst(RegExp(r'\.?0*$'), ''))
    : null;
