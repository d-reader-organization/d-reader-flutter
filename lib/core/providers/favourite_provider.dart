import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<FavouriteState> useFavouriteState<T>(FavouriteState initialData) {
  final result = useState<FavouriteState>(initialData);
  return result;
}

class FavouriteState {
  const FavouriteState({
    required this.count,
    required this.isFavourite,
  });
  final int count;
  final bool isFavourite;

  FavouriteState copyWith({required int count, required bool isFavourite}) {
    return FavouriteState(count: count, isFavourite: isFavourite);
  }
}
