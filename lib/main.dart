import 'package:flutter/material.dart';
import 'package:memo/riverpod/memo_provider.dart';
import 'package:memo/root_tab.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'model/model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Memo>(MemoAdapter());
  Hive.registerAdapter<Category>(CategoryAdapter());
  await Hive.openBox<Memo>('memo');
  await Hive.openBox<Category>('category');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemoProvider()),
      ],
      child: MaterialApp(
        // routes: {
        //   MemoDetail.routeName: (context) => MemoDetail(),
        // },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'a',
          useMaterial3: true,
          colorSchemeSeed: Colors.grey,
        ),
        home: RootTab(),
      ),
    ),

  );
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     final memoProvider = Provider.of<MemoProvider>(context);
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => MemoProvider()),
//       ],
//       child: MaterialApp(
//         // routes: {
//         //   MemoDetail.routeName: (context) => MemoDetail(),
//         // },
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           fontFamily: 'a',
//           useMaterial3: true,
//           colorSchemeSeed: Colors.grey,
//         ),
//         home: ChangeNotifierProvider(
//           create: (context) => MemoProvider()..initialize(),
//           child: RootTab(),
//         ),
//       ),
//     );
//   }
// }


