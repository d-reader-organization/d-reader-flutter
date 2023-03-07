import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<CountState> useCountState<T>(CountState initialData) {
  final result = useState<CountState>(initialData);
  return result;
}

class CountState {
  const CountState({
    required this.count,
    required this.isSelected,
  });
  final int count;
  final bool isSelected;

  CountState copyWith({required int count, required bool isSelected}) {
    return CountState(count: count, isSelected: isSelected);
  }
}
