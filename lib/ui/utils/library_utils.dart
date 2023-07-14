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

(int, int) getSublistBorders(Map<String, int> sortedLetters, int currentIndex) {
  int previousLettersCounts = 0;
  int currentElementOccurences =
      (sortedLetters[sortedLetters.keys.elementAt(currentIndex)] ?? 0);
  for (var i = 0; i < currentIndex; ++i) {
    previousLettersCounts +=
        sortedLetters[sortedLetters.keys.elementAt(i)] ?? 0;
  }

  int startAt = previousLettersCounts;
  int endAt = previousLettersCounts + currentElementOccurences;
  return (startAt, endAt);
}
