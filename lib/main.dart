import 'package:flutter/material.dart';
import 'package:athingani/src/ui/container_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ContainerWidget(),
      theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ThemeData.light(useMaterial3: true)
              .colorScheme
              .copyWith(primary: Colors.deepPurpleAccent, secondary: Colors.green, tertiary: Colors.deepPurple)),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ThemeData.dark(useMaterial3: true)
              .colorScheme
              .copyWith(primary: Colors.deepPurpleAccent, secondary: Colors.green, tertiary: Colors.deepPurple)),
      themeMode: ThemeMode.light,
    );
  }
}
