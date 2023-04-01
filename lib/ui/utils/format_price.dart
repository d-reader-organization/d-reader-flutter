import 'package:solana/solana.dart' show lamportsPerSol;

String formatPrice(double price, [int decimals = 2]) =>
    price.toStringAsFixed(decimals).replaceFirst(RegExp(r'\.?0*$'), '');

String formatLamportPrice(double price, [int decimals = 2]) =>
    (price / lamportsPerSol)
        .toStringAsFixed(decimals)
        .replaceFirst(RegExp(r'\.?0*$'), '');
