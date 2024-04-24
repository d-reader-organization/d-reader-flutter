import 'dart:math';

import 'package:d_reader_flutter/features/settings/domain/models/spl_token.dart';
import 'package:intl/intl.dart';
import 'package:solana/solana.dart' show lamportsPerSol;

class Formatter {
  static String formatAddress(String address, [int end = 6]) {
    return '${address.substring(0, end)}...${address.substring(address.length - end, address.length)}';
  }

  static String formatDate(DateTime date) {
    String day = '0${date.day}'.substring(0, 2);
    String month = '0${date.month}'.substring(0, 2);
    return '$day/$month/${date.year}';
  }

  static String formatDateFull(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }

  static String formatDateInRelative(DateTime? date) {
    if (date == null) {
      return '';
    }
    final currentDate = DateTime.now();
    final difference = date.difference(currentDate);
    const hoursPerDay = 24;
    const minutesPerHour = 60;
    const secondsPerMinute = 60;

    if (difference.inDays > 0) {
      final hoursLeft = difference.inHours - (hoursPerDay * difference.inDays);
      return '${difference.inDays}d ${hoursLeft}h';
    } else if (difference.inHours > 0) {
      final minutesLeft =
          difference.inMinutes - (difference.inHours * minutesPerHour);
      return '${difference.inHours}h ${minutesLeft}m';
    } else if (difference.inMinutes > 0) {
      final secondsLeft =
          difference.inSeconds - (difference.inMinutes * secondsPerMinute);
      return '${difference.inMinutes}m ${secondsLeft}s';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds}s';
    }
    return '';
  }

  static String formatPrice(double price, [int decimals = 2]) =>
      price.toStringAsFixed(decimals).replaceFirst(RegExp(r'\.?0*$'), '');

  static double? formatLamportPrice(int? price,
          [int decimals = 2]) =>
      price != null
          ? double.tryParse((price / lamportsPerSol)
              .toStringAsFixed(decimals)
              .replaceFirst(RegExp(r'\.?0*$'), ''))
          : null;

  static String formatPriceWithSignificant(int price) {
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

  static String formatCount(dynamic count) {
    return NumberFormat.compact().format(count);
  }

  static String formatPriceByCurrency(
      {required int mintPrice, required SplToken? splToken}) {
    if (splToken == null) {
      return formatPriceWithSignificant(mintPrice);
    }
    final divideResult = mintPrice / pow(10, splToken.decimals);
    return formatCount(divideResult);
  }
}
