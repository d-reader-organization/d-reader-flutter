import 'package:collection/collection.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_group.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

SolanaClient createSolanaClient({required String rpcUrl}) {
  return SolanaClient(
    rpcUrl: Uri.parse(
      rpcUrl,
    ),
    websocketUrl: Uri.parse(
      rpcUrl.replaceAll(
        'https',
        'ws',
      ),
    ),
  );
}

Future<bool> isWalletAppAvailable() async {
  return LocalAssociationScenario.isAvailable();
}

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

CandyMachineGroupModel? getActiveGroup(List<CandyMachineGroupModel> groups) {
  final currentDate = DateTime.now();
  return groups.firstWhereOrNull(
    (group) {
      final isStartDateLessOrEqualThanCurrent = group.startDate != null &&
          (group.startDate!.isBefore(currentDate) ||
              group.startDate!.isAtSameMomentAs(currentDate));
      final isEndDateBiggerThanCurrent =
          group.endDate != null && currentDate.isBefore(group.endDate!);
      return isStartDateLessOrEqualThanCurrent && isEndDateBiggerThanCurrent;
    },
  );
}

String getSortDirection(SortDirection direction) {
  return direction == SortDirection.asc ? 'asc' : 'desc';
}

String pluralizeString(int count, String word) => count > 1 ? '${word}s' : word;
