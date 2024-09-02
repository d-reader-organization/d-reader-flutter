import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/modals/owned_digital_assets_bottom_sheet.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const double previewImageHeight = 320;

class PreviewImage extends StatelessWidget {
  final bool canRead, isFullyUploaded;
  final int issueId, issueNumber;
  const PreviewImage({
    super.key,
    required this.canRead,
    required this.isFullyUploaded,
    required this.issueId,
    required this.issueNumber,
  });

  openModalBottomSheet(
      BuildContext context, List<DigitalAssetModel> ownedDigitalAssets) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: ownedDigitalAssets.length > 1 ? 0.65 : 0.5,
          minChildSize: ownedDigitalAssets.length > 1 ? 0.65 : 0.5,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return OwnedDigitalAssetsBottomSheet(
              ownedDigitalAssets: ownedDigitalAssets,
              episodeNumber: issueNumber,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: previewImageHeight,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ColorPalette.greyscale300,
          )),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/icons/comic_preview.svg',
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.eyeSlash,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(
                  height: 16,
                ),
                if (!canRead || !isFullyUploaded) ...[
                  Text(
                    'This is a comic preview!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
                if (!canRead) ...[
                  Text(
                    'To view all pages buy a full copy or become a monthly subscriber',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
                Consumer(
                  builder: (context, ref, child) {
                    final ownedDigitalAssets = ref.watch(
                      digitalAssetsProvider(
                        'comicIssueId=$issueId&userId=${ref.read(environmentProvider).user?.id}',
                      ),
                    );

                    return ownedDigitalAssets.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const SizedBox();
                        }

                        final isAtLeastOneUsed =
                            data.any((digitalAsset) => digitalAsset.isUsed);
                        return isAtLeastOneUsed && canRead
                            ? const SizedBox()
                            : Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: CustomTextButton(
                                  backgroundColor:
                                      ColorPalette.dReaderYellow100,
                                  fontSize: 16,
                                  isLoading: ref.watch(privateLoadingProvider),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    final privateLoadingNotifier = ref
                                        .read(privateLoadingProvider.notifier);
                                    privateLoadingNotifier
                                        .update((state) => true);
                                    openModalBottomSheet(context, data);
                                    privateLoadingNotifier
                                        .update((state) => false);
                                  },
                                  child: const Text(
                                    'Unwrap',
                                  ),
                                ),
                              );
                      },
                      error: (error, stackTrace) {
                        Sentry.captureException(
                          error,
                          stackTrace:
                              'eReader owned DigitalAssets: $stackTrace',
                        );
                        return const SizedBox();
                      },
                      loading: () {
                        return const SizedBox();
                      },
                    );
                  },
                ),
                isFullyUploaded
                    ? const SizedBox()
                    : Text(
                        'This comic is not yet fully uploaded. New chapters might be added weekly or the comic is still in a presale phase',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
