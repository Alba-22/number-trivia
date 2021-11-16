import 'package:flutter/material.dart';
import 'package:number_trivia/modules/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green.shade800,
          secondary: Colors.green.shade600,
        ),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
