import 'package:d_reader_flutter/config/config.dart';
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
