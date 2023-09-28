import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/currentviewprovider.dart';

class BNB extends ConsumerStatefulWidget {
  const BNB({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BNBState();
}

class _BNBState extends ConsumerState<BNB> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = ref.read(currentViewProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.text_snippet),
          label: 'Notes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payments),
          label: 'Spendings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: 'Groups',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) =>
          ref.read(currentViewProvider.notifier).setView(index),
    );
  }
}
