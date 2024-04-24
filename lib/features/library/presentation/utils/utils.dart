import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';

Map<String, int> sortAndGetLetterOccurences(List<ComicModel> comics) {
  return comics.fold({}, (previousValue, element) {
    final upperCaseChar = element.title[0].toUpperCase();
    return {
      ...previousValue,
      upperCaseChar: previousValue[upperCaseChar] != null
          ? previousValue[upperCaseChar]! + 1
          : 1
    };
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
