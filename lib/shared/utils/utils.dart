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
