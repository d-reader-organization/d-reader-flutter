import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/list/notifier/list_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DigitalAssetModalBottomSheet extends ConsumerStatefulWidget {
  final DigitalAssetModel digitalAsset;
  const DigitalAssetModalBottomSheet({
    super.key,
    required this.digitalAsset,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DigitalAssetModalBottomSheetState();
}

class _DigitalAssetModalBottomSheetState
    extends ConsumerState<DigitalAssetModalBottomSheet> {
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
              title: Text(
                widget.digitalAsset.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                widget.digitalAsset.comicName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              leading: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.digitalAsset.image,
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
            digitalAsset: widget.digitalAsset,
            price: priceInputValue.isNotEmpty
                ? double.tryParse(
                    priceInputValue,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class SubmitButton extends ConsumerWidget {
  final DigitalAssetModel digitalAsset;
  final double? price;
  const SubmitButton({
    super.key,
    required this.digitalAsset,
    this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextButton(
      isLoading: ref.watch(globalNotifierProvider).isLoading,
      onPressed: price != null
          ? () async {
              await ref
                  .read(listNotifierProvider.notifier)
                  .list(
                    assetAddress: digitalAsset.address,
                    sellerAddress: digitalAsset.ownerAddress,
                    price: price!,
                  )
                  .then((value) => context.pop());
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
