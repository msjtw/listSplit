import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setView(int index) {
    state = index;
  }
}

final currentViewProvider = NotifierProvider<ViewNotifier, int>(() {
  return ViewNotifier();
});
