import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/styles.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchAutoComplete extends ConsumerWidget {
  const SearchAutoComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicModel>> comicsProvider = ref.watch(comicProvider);
    return comicsProvider.when(
      data: (comics) {
        return Autocomplete<ComicModel>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return [];
            }
            return comics.where((element) => element.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (comic) => comic.name,
          optionsViewBuilder: (context, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(4.0),
                ),
              ),
              child: Container(
                color: dReaderBlack,
                height: 64.0 * options.length,
                padding: const EdgeInsets.only(right: 16),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final ComicModel comic = options.elementAt(index);
                    return AutoCompleteListItem(
                      comic: comic,
                      onSelected: onSelected,
                    );
                  },
                ),
              ),
            ),
          ),
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              cursorColor: dReaderYellow,
              focusNode: focusNode,
              onFieldSubmitted: (value) {
                onFieldSubmitted();
              },
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: dReaderYellow,
              ),
              decoration: searchInputDecoration,
            );
          },
        );
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => const SizedBox(
        height: 58,
        child: SkeletonCard(),
      ),
    );
  }
}

class AutoCompleteListItem extends StatelessWidget {
  final ComicModel comic;
  final Function(ComicModel comicModel) onSelected;
  const AutoCompleteListItem({
    Key? key,
    required this.comic,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onSelected(comic),
      leading: SizedBox(
        height: 32,
        width: 32,
        child: CommonCachedImage(
          imageUrl: comic.cover,
          fit: BoxFit.scaleDown,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                comic.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '${comic.issues.length} items',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Image.asset(
            Config.solanaLogoPath,
            width: 24,
          ),
        ],
      ),
    );
  }
}
