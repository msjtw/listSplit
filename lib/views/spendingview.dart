import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/bnb.dart';

class SpendingView extends ConsumerStatefulWidget {
  const SpendingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpendingViewState();
}

class _SpendingViewState extends ConsumerState<SpendingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your expenses'),
      ),
      bottomNavigationBar: const BNB(),
      body: Container(),
    );
  }
}




