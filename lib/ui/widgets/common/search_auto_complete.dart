import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/styles.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAutoComplete extends ConsumerStatefulWidget {
  const SearchAutoComplete({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchAutoCompleteState();
}

class _SearchAutoCompleteState extends ConsumerState<SearchAutoComplete> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<ComicModel>(
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        cursorColor: Colors.white,
        controller: _controller,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.white,
        ),
        decoration: searchInputDecoration(
          hintText: 'Search comics',
          prefixIcon: IconButton(
            onPressed: null,
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                ColorPalette.dReaderGrey,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              _controller.clear();
            },
            child: const Icon(
              Icons.close_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ),
      suggestionsCallback: (pattern) async {
        return await ref.read(
            comicsProvider('skip=0&take=20&nameSubstring=$pattern').future);
      },
      itemBuilder: (context, ComicModel suggestion) {
        return SuggestionsListItem(comic: suggestion);
      },
      onSuggestionSelected: (ComicModel suggestion) {
        nextScreenPush(
          context,
          ComicDetails(
            slug: suggestion.slug,
          ),
        );
      },
      noItemsFoundBuilder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: ColorPalette.appBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 64.0,
          alignment: Alignment.center,
          child: Text(
            'No results found',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
      loadingBuilder: (context) {
        return Container(
          height: 128,
          decoration: BoxDecoration(
            color: ColorPalette.appBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: SizedBox(
              height: 48,
              width: 48,
              child: CircularProgressIndicator(
                backgroundColor: ColorPalette.dReaderBlue,
              ),
            ),
          ),
        );
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        elevation: 8.0,
        color: ColorPalette.appBackgroundColor,
      ),
    );
  }
}

class SuggestionsListItem extends StatelessWidget {
  final ComicModel comic;

  const SuggestionsListItem({
    Key? key,
    required this.comic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: CommonCachedImage(
          imageUrl: comic.cover,
          fit: BoxFit.fill,
          cacheKey: comic.slug,
        ),
      ),
      title: Row(
        children: [
          Text(
            comic.title,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            '${comic.stats?.issuesCount} items',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
