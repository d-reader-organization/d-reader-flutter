import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NftModalBottomSheet extends ConsumerStatefulWidget {
  final NftModel nft;
  const NftModalBottomSheet({
    super.key,
    required this.nft,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NftModalBottomSheetState();
}

class _NftModalBottomSheetState extends ConsumerState<NftModalBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.2,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: ColorPalette.boxBackground300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(widget.nft.name),
              subtitle: Text(widget.nft.comicName),
              leading: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.nft.image,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textEditingController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  labelText: 'List Price',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    maxWidth: 140,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(
                  Config.solanaLogoPath,
                  width: 32,
                  height: 32,
                ),
              ),
            ],
          ),
          SubmitButton(
            mintAccount: widget.nft.address,
            price: _safeParse(
              _textEditingController.text,
            ),
          ),
        ],
      ),
    );
  }
}

double? _safeParse(String input) => double.tryParse(input);

class SubmitButton extends HookConsumerWidget {
  final String mintAccount;
  final double? price;
  const SubmitButton({
    super.key,
    required this.mintAccount,
    this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalHook = useGlobalState();
    return RoundedButton(
      text: 'Next',
      isLoading: globalHook.value.isLoading,
      onPressed: price != null
          ? () async {
              globalHook.value = globalHook.value.copyWith(isLoading: true);
              final response = await ref.read(solanaProvider.notifier).list(
                    mintAccount: mintAccount,
                    price: price!,
                  );
              globalHook.value = globalHook.value.copyWith(isLoading: false);
              print('List response: $response');
              if (context.mounted) {
                ref.invalidate(nftProvider);
                Navigator.pop(context);
              }
            }
          : null,
      size: const Size(double.infinity, 50),
    );
  }
}
