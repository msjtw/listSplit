import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/views/spendingview.dart';
import 'providers/currentviewprovider.dart';
import 'services/save/objectbox.dart';

//import 'theme.dart';
import 'views/alllistview.dart';

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      //theme: theme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/AllListView': (context) => const AllListView(),
        '/SpendingView': (context) => const SpendingView(),
      },
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SafeArea(
//       child: AllListView(),
//     );
//   }
// }

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentView = ref.watch(currentViewProvider);
    switch (currentView) {
      case 0:
        return const AllListView();
      case 1:
        return const SpendingView();
    }
    return Container();
  }
}
