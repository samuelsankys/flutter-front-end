import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Análise de Banco de Dados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: 'home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'home':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(),
            );
        }
      },
    );
  }
}
