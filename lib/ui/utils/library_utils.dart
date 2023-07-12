import 'package:d_reader_flutter/core/models/comic.dart';

Map<String, int> sortAndGetLetterOccurences(List<ComicModel> comics) {
  comics.sort(
    (a, b) {
      return a.title.compareTo(b.title);
    },
  );
  return comics.fold(
      {},
      (previousValue, element) => {
            ...previousValue,
            element.title[0]: previousValue[element.title[0]] != null
                ? previousValue[element.title[0]]! + 1
                : 1
          });
}
