import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_coupon.dart';
import 'package:d_reader_flutter/features/settings/domain/models/spl_token.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/utils/extensions.dart';
import 'package:solana/solana.dart';

Future<String?> requestAirdrop(String publicKey) async {
  try {
    final client = SolanaClient(
      rpcUrl: Uri.parse(
        Config.solanaRpcDevnet,
      ),
      websocketUrl: Uri.parse(
        "ws://api.devnet.solana.com",
      ),
    );
    await client.rpcClient.requestAirdrop(
      publicKey,
      2 * lamportsPerSol,
      commitment: Commitment.finalized,
    );
    return "You have received 2 SOL";
  } on HttpException catch (error) {
    var message = error.toString();
    // sentry log error;
    if (message.contains('429')) {
      return "Too many requests. Try again later.";
    } else if (message.contains('500')) {}
    return "Airdrop has failed.";
  } catch (error) {
    //log error
    return null;
  }
}

CandyMachineCoupon? getActiveCoupon({
  required List<CandyMachineCoupon> coupons,
  required String selectedSplTokenAddress,
}) {
  final userCoupon = coupons.firstWhereOrNull(
    (coupon) {
      return coupon.type == CouponType.registeredUser.getString();
    },
  );
  return userCoupon ??
      coupons.firstWhereOrNull(
        (coupon) {
          return coupon.type == CouponType.publicUser.getString();
        },
      );
}

SplToken getSplTokenWithHighestPriority(List<SplToken> splTokens) {
  return splTokens.firstWhereOrNull(
          (element) => element.priority == splTokenHighestPriority) ??
      splTokens.first;
}

String getSortDirection(SortDirection direction) {
  return direction == SortDirection.asc ? 'asc' : 'desc';
}

String pluralizeString(int count, String word) => count > 1 ? '${word}s' : word;
