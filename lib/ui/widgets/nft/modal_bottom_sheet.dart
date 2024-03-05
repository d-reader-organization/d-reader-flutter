import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_controller.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  String priceInputValue = '';
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height / 2.2,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: ColorPalette.greyscale400,
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
                onChanged: (value) {
                  setState(() {
                    priceInputValue = value;
                  });
                },
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
            nft: widget.nft,
            price: priceInputValue.isNotEmpty
                ? _safeParse(
                    priceInputValue,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

double? _safeParse(String input) => double.tryParse(input);

class SubmitButton extends ConsumerWidget {
  final NftModel nft;
  final double? price;
  const SubmitButton({
    super.key,
    required this.nft,
    this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextButton(
      isLoading: ref.watch(globalStateProvider).isLoading,
      onPressed: price != null
          ? () async {
              try {
                await ref.read(nftControllerProvider.notifier).listNft(
                      sellerAddress: nft.ownerAddress,
                      mintAccount: nft.address,
                      price: price!,
                      callback: (result) {
                        context.pop();
                        showSnackBar(
                          context: context,
                          text: result is bool && result
                              ? 'Listed successfully'
                              : result is String
                                  ? result
                                  : 'Failed to list item',
                          backgroundColor: result is bool && result
                              ? ColorPalette.dReaderGreen
                              : ColorPalette.dReaderRed,
                        );
                      },
                    );
              } catch (exception) {
                rethrow;
              }
            }
          : null,
      size: const Size(double.infinity, 50),
      child: Text(
        'Next',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}
